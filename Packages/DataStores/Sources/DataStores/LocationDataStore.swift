import Combine
import CoreLocation
import Models
import Foundation


@MainActor
public final class LocationDataStore: NSObject, ObservableObject {
    
    private let locationManager: LocationManagerType
    private let stations: StationsDataStore
    private let geocoder: CLGeocoder
    
    public enum DetectionState {
        case detecting
        case failed(Error)
        case detected
    }
    
    @Published public private(set) var authorizationStatus: CLAuthorizationStatus
    @Published public private(set) var currentLocationCoordinate: LocationCoordinate?
    @Published public private(set) var currentLocationName: LocationName?
    @Published public private(set) var detectionState: DetectionState = .detected
    @Published public private(set) var nearbyStations: [NearbyStation] = []
    
    private var currentLocationNameLastUpdated: Date = .distantPast
    private var forceRefreshLocationName: Bool = false
    
    public var isAuthorized: Bool {
        locationManager.isAuthorized
    }
    
    public var isAuthorizedOrUndetermined: Bool {
        locationManager.isAuthorized || authorizationStatus == .notDetermined
    }
    
    public init(locationManager: LocationManagerType,
                stations: StationsDataStore) {
        self.locationManager = locationManager
        self.authorizationStatus = locationManager.authorizationStatus
        self.stations = stations
        self.geocoder = CLGeocoder()
        super.init()
        (locationManager as? CLLocationManager)?.delegate = self
        
        if let location = locationManager.location {
            updateCurrentLocation(to: location.toLocation())
        }
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
        
    public func startDetectingCurrentLocationIfAuthorized() {
        guard isAuthorized else {
            return
        }
        refreshCurrentLocation(forceRefreshLocationName: forceRefreshLocationName)
        locationManager.startMonitoringSignificantLocationChanges()
    }
    
    public func stopDetectingCurrentLocation() {
        locationManager.stopMonitoringSignificantLocationChanges()
    }
    
    private func updateCurrentLocation(to newValue: LocationCoordinate) {
        let oldValue = currentLocationCoordinate
        currentLocationCoordinate = newValue
        if shouldUpdateLocationName(oldValue: oldValue, newValue: newValue) {
            updateCurrentLocationName()
        }
        updateNearbyStations()
    }
    
    private func updateCurrentLocationName() {
        guard let currentLocationCoordinate else { return }
        Task {
            do {
                try await updateCurrentLocationName(for: currentLocationCoordinate)
            } catch {
                print("Failed to update location name for new location")
            }
        }
    }
    
    private func shouldUpdateLocationName(oldValue: LocationCoordinate?, newValue: LocationCoordinate) -> Bool {
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
    
    private func updateCurrentLocationName(for newLocation: LocationCoordinate) async throws {
        guard let placemark = try await geocoder.reverseGeocodeLocation(newLocation.toCLLocation()).first else {
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
    
    private func clearAllLocationValues() {
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

// N.B. I could've moved the delegate to a separate NSObject (to prevent LocationModel from having to conform to NSObject
// but it added unnecesssary complexity for no added benefit).

extension LocationDataStore: CLLocationManagerDelegate {
    
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
        startDetectingCurrentLocationIfAuthorized() // i.e. CHANGED to authorized (e.g. so permissions have just been granted)
        
        if !isAuthorized {
            clearAllLocationValues()
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        detectionState = .failed(error)
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last?.toLocation() else {
            return
        }
        detectionState = .detected
        updateCurrentLocation(to: location)
    }
}
