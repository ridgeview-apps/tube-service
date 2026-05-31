import CoreLocation
import Models
import Foundation

public protocol ReverseGeocoderType: Sendable {
    func reverseGeocodeLocation(_ location: CLLocation) async throws -> [CLPlacemark]
}

extension CLGeocoder: ReverseGeocoderType {}

@Observable
@MainActor
public final class LocationDataStore: NSObject {
    
    private let locationManager: LocationManagerType
    private let locationManagerDelegate = LocationManagerDelegate()
    private let stations: StationsDataStore
    private let geocoder: ReverseGeocoderType
    
    public enum DetectionState {
        case detecting
        case failed(Error)
        case detected
    }
    
    public private(set) var authorizationStatus: CLAuthorizationStatus
    public private(set) var currentLocationCoordinate: LocationCoordinate?
    public private(set) var currentLocationName: LocationName?
    public private(set) var detectionState: DetectionState = .detected
    public private(set) var nearbyStations: [NearbyStation] = []
    
    private var currentLocationNameLastUpdated: Date = .distantPast
    private var forceRefreshLocationName: Bool = false
    private var locationNameUpdateTask: Task<Void, Never>?
    
    public var isAuthorized: Bool {
        locationManager.isAuthorized
    }
    
    public var isAuthorizedOrUndetermined: Bool {
        locationManager.isAuthorized || authorizationStatus == .notDetermined
    }
    
    public init(locationManager: LocationManagerType,
                stations: StationsDataStore,
                geocoder: ReverseGeocoderType = CLGeocoder()) {
        self.locationManager = locationManager
        self.authorizationStatus = locationManager.authorizationStatus
        self.stations = stations
        self.geocoder = geocoder
        super.init()
        
        locationManagerDelegate.onAction = { [weak self] action in
            self?.handleLocationManagerDelegateAction(action)
        }
        locationManager.setDelegate(locationManagerDelegate)
    }
    
    public func promptForPermissions() {
        detectionState = .detecting
        locationManager.requestWhenInUseAuthorization()
    }
    
    public func refreshCurrentLocation(forceRefreshLocationName: Bool = false) {
        guard isAuthorized else {
            return
        }
        
        self.forceRefreshLocationName = forceRefreshLocationName
        detectionState = .detecting
        locationManager.requestLocation()
    }
        
    public func startLocationUpdatesIfAuthorized() {
        guard isAuthorized else {
            return
        }
        refreshCurrentLocation(forceRefreshLocationName: forceRefreshLocationName)
        locationManager.startMonitoringSignificantLocationChanges()
    }
    
    public func stopLocationUpdates() {
        locationManager.stopMonitoringSignificantLocationChanges()
    }
    
    private func processLocationUpdate(_ newValue: LocationCoordinate) {
        let oldValue = currentLocationCoordinate
        currentLocationCoordinate = newValue
        if shouldRefreshLocationName(forOldCoordinate: oldValue, newCoordinate: newValue) {
            refreshLocationNameForChangedCoordinate()
        }
        updateNearbyStations()
    }
    
    private func refreshLocationNameForChangedCoordinate() {
        guard let currentLocationCoordinate else { return }
        locationNameUpdateTask?.cancel()
        locationNameUpdateTask = Task { [weak self] in
            guard let self else { return }
            do {
                try await reverseGeocodeLocationName(for: currentLocationCoordinate)
            } catch {
                if Task.isCancelled {
                    return
                }
                print("Failed to update location name for new location: \(error)")
            }
        }
    }
    
    private func shouldRefreshLocationName(forOldCoordinate oldValue: LocationCoordinate?,
                                           newCoordinate newValue: LocationCoordinate) -> Bool {
        if forceRefreshLocationName {
            return true
        }
        
        guard let oldValue else {
            return true
        }
        
        let oneMinute = 60.0
        let fiveHundredMeters = 500.0
        
        let nameUpdatedOverOneMinuteAgo = Date.now.timeIntervalSince(currentLocationNameLastUpdated) > oneMinute
        let locationHasChangedSignificantly = newValue.toCLLocation().distance(from: oldValue.toCLLocation()) > fiveHundredMeters
        
        return locationHasChangedSignificantly && nameUpdatedOverOneMinuteAgo
    }
    
    private func reverseGeocodeLocationName(for newLocation: LocationCoordinate) async throws {
        guard currentLocationCoordinate == newLocation else {
            return
        }
        
        guard let placemark = try await geocoder.reverseGeocodeLocation(newLocation.toCLLocation()).first else {
            return
        }
        
        guard currentLocationCoordinate == newLocation else {
            return
        }
        
        currentLocationName = placemark.toLocationName()
        currentLocationNameLastUpdated = .now
    }
    
    private func updateNearbyStations() {
        guard let currentLocationCoordinate else {
            assertionFailure("Trying to update nearby stations without a location")
            return
        }
        
        nearbyStations = stations.allStations.nearestStations(to: currentLocationCoordinate)
    }
    
    private func resetLocationState() {
        locationNameUpdateTask?.cancel()
        locationNameUpdateTask = nil
        currentLocationCoordinate = nil
        currentLocationName = nil
        currentLocationNameLastUpdated = .distantPast
        detectionState = .detected
        nearbyStations = []
    }
}

extension Sequence where Element == Station {
    func nearestStations(to location: LocationCoordinate) -> [NearbyStation] {
        let userLocation = location.toCLLocation()
        
        return map {
            let stationLocation = $0.location.toCLLocation()
            return NearbyStation(distance: userLocation.distance(from: stationLocation),
                                 station: $0)
        }.sorted {
            $0.distance < $1.distance
        }
    }
}

private extension CLPlacemark {
    func toLocationName() -> LocationName {
        let titleItems = [thoroughfare, subLocality].compactMap { $0 }.filter { !$0.isEmpty }
        
        let titleItem: String = titleItems.indices.contains(0) ? titleItems[0] : ""
        let subtitleItem: String = titleItems.indices.contains(1) ? titleItems[1] : ""
        
        return .init(title: titleItem,
                     subtitle: subtitleItem)
    }
}


// MARK: - CLLocationManagerDelegate

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

private extension LocationDataStore {
    
    func handleLocationManagerDelegateAction(_ action: LocationManagerDelegate.Action) {
        switch action {
        case .didChangeAuthorization:
            authorizationStatus = locationManager.authorizationStatus
            startLocationUpdatesIfAuthorized() // i.e. CHANGED to authorized (e.g. so permissions have just been granted)
            
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
}
