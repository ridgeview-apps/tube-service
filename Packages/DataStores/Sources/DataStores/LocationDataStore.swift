import CoreLocation
import Foundation
import MapKit
import Models
import Shared

public protocol ReverseGeocoderType: Sendable {
    func locationName(for location: CLLocation) async throws -> LocationName?
}

public struct MapKitReverseGeocoder: ReverseGeocoderType {

    public init() {}

    public func locationName(for location: CLLocation) async throws -> LocationName? {
        guard let request = MKReverseGeocodingRequest(location: location) else {
            return nil
        }
        return try await request.mapItems.first?.toLocationName()
    }
}

@Observable
@MainActor
public final class LocationDataStore: NSObject {

    public enum DetectionState {
        case detecting
        case failed(Error)
        case detected
    }

    // MARK: - State

    private let locationManager: LocationManagerType
    private let locationManagerDelegate = LocationManagerDelegate()
    private let stations: StationsDataStore
    private let geocoder: ReverseGeocoderType
    private let now: () -> Date

    public private(set) var authorizationStatus: CLAuthorizationStatus
    public private(set) var detectionState: DetectionState = .detected
    public private(set) var nearestStations: [NearbyStation] = []

    private var currentLocation: Timestamped<LocationCoordinate>?
    private var locationName: Timestamped<LocationName>?
    private var needsFreshLocationName = false
    private(set) var locationNameUpdateTask: Task<Void, Never>?

    private static let maxLocationAge: TimeInterval = 60
    private static let minLocationNameRefreshInterval: TimeInterval = 60
    private static let minLocationNameRefreshDistance: Double = 500

    public init(
        locationManager: LocationManagerType,
        stations: StationsDataStore,
        geocoder: ReverseGeocoderType = MapKitReverseGeocoder(),
        now: @escaping () -> Date = { .now }
    ) {
        self.locationManager = locationManager
        self.authorizationStatus = locationManager.authorizationStatus
        self.stations = stations
        self.geocoder = geocoder
        self.now = now
        super.init()

        locationManagerDelegate.onAction = { [weak self] action in
            self?.handleLocationManagerDelegateAction(action)
        }
        locationManager.setDelegate(locationManagerDelegate)
    }

    // MARK: - Outputs

    public var currentLocationCoordinate: LocationCoordinate? {
        currentLocation?.value
    }

    public var currentLocationName: LocationName? {
        locationName?.value
    }

    public var isAuthorized: Bool {
        locationManager.isAuthorized
    }

    public var isAuthorizedOrUndetermined: Bool {
        locationManager.isAuthorized || authorizationStatus == .notDetermined
    }

    // MARK: - Actions

    public func promptForPermissions() {
        detectionState = .detecting
        locationManager.requestWhenInUseAuthorization()
    }

    public func refreshCurrentLocation() {
        guard isAuthorized else {
            return
        }
        detectionState = .detecting
        locationManager.requestLocation()
    }

    public func refreshCurrentLocationWithFreshName() {
        guard isAuthorized else {
            return
        }
        needsFreshLocationName = true
        refreshCurrentLocation()
    }

    public func startLocationUpdatesIfAuthorized() {
        guard isAuthorized else {
            return
        }
        refreshCurrentLocationIfStale()
        locationManager.startMonitoringSignificantLocationChanges()
    }

    public func stopLocationUpdates() {
        locationManager.stopMonitoringSignificantLocationChanges()
    }

    // MARK: - Implementation

    private func refreshCurrentLocationIfStale() {
        if let currentLocation, !currentLocation.isOlder(than: Self.maxLocationAge, at: now()) {
            return
        }
        refreshCurrentLocation()
    }

    private func handleLocationManagerDelegateAction(_ action: LocationManagerDelegate.Action) {
        switch action {
        case .didChangeAuthorization:
            authorizationStatus = locationManager.authorizationStatus
            startLocationUpdatesIfAuthorized()

            if !isAuthorized {
                resetLocationState()
            }
        case .didFailWithError(_, let error):
            detectionState = .failed(error)
        case .didUpdateLocations(_, let locations):
            guard let location = locations.last?.toLocation() else {
                return
            }
            detectionState = .detected
            processLocationUpdate(location)
        }
    }

    private func processLocationUpdate(_ newCoordinate: LocationCoordinate) {
        let oldCoordinate = currentLocationCoordinate
        currentLocation = Timestamped(value: newCoordinate, date: now())
        if shouldRefreshLocationName(from: oldCoordinate, to: newCoordinate) {
            refreshLocationName(for: newCoordinate)
        }
        needsFreshLocationName = false
        nearestStations = stations.allLondon.nearestStations(to: newCoordinate)
    }

    private func shouldRefreshLocationName(
        from oldCoordinate: LocationCoordinate?,
        to newCoordinate: LocationCoordinate
    ) -> Bool {
        guard !needsFreshLocationName, let oldCoordinate else {
            return true
        }
        let hasMovedFarEnough = newCoordinate.distance(to: oldCoordinate) > Self.minLocationNameRefreshDistance
        let isNameOldEnough = locationName?.isOlder(than: Self.minLocationNameRefreshInterval, at: now()) ?? true
        return hasMovedFarEnough && isNameOldEnough
    }

    private func refreshLocationName(for coordinate: LocationCoordinate) {
        locationNameUpdateTask?.cancel()
        locationNameUpdateTask = Task { [weak self] in
            guard let self else { return }
            do {
                guard let name = try await geocoder.locationName(for: coordinate.toCLLocation()),
                    currentLocationCoordinate == coordinate
                else {
                    return
                }
                locationName = Timestamped(value: name, date: now())
            } catch {
                if Task.isCancelled {
                    return
                }
                AppLogger.networking.error("Failed to update location name for new location: \(error)")
            }
        }
    }

    private func resetLocationState() {
        locationNameUpdateTask?.cancel()
        locationNameUpdateTask = nil
        currentLocation = nil
        locationName = nil
        needsFreshLocationName = false
        detectionState = .detected
        nearestStations = []
    }
}

private struct Timestamped<Value> {
    let value: Value
    let date: Date

    func isOlder(than age: TimeInterval, at now: Date) -> Bool {
        now.timeIntervalSince(date) > age
    }
}

extension Sequence where Element == Station {
    func nearestStations(to location: LocationCoordinate) -> [NearbyStation] {
        map { station in
            NearbyStation(station, distance: location.distance(to: station.location))
        }.sorted {
            $0.distance < $1.distance
        }
    }
}

private extension MKMapItem {
    func toLocationName() -> LocationName {
        let titleItems = [name, addressRepresentations?.cityName].compactMap { $0 }.filter { !$0.isEmpty }

        let titleItem: String = titleItems.indices.contains(0) ? titleItems[0] : ""
        let subtitleItem: String = titleItems.indices.contains(1) ? titleItems[1] : ""

        return .init(
            title: titleItem,
            subtitle: subtitleItem
        )
    }
}


private class LocationManagerDelegate: NSObject, CLLocationManagerDelegate {
    enum Action {
        case didChangeAuthorization(LocationManagerType)
        case didFailWithError(LocationManagerType, Error)
        case didUpdateLocations(LocationManagerType, [CLLocation])
    }

    var onAction: ((Action) -> Void)?

    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        onAction?(.didChangeAuthorization(manager))
    }

    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        onAction?(.didFailWithError(manager, error))
    }

    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        onAction?(.didUpdateLocations(manager, locations))
    }
}
