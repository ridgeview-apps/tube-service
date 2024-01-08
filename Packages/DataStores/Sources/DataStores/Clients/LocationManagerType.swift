import CoreLocation

// MARK: - Data types

public protocol LocationManagerType {
    var location: CLLocation? { get }
    var authorizationStatus: CLAuthorizationStatus { get }
    func requestLocation()
    func requestWhenInUseAuthorization()
    func startMonitoringSignificantLocationChanges()
    func stopMonitoringSignificantLocationChanges()
}

public extension LocationManagerType {
    
    var isAuthorized: Bool {
        switch authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse, .authorized:
            return true
        case .notDetermined, .restricted, .denied:
            return false
        @unknown default:
            return false
        }
    }
}

extension CLLocationManager: LocationManagerType {}
