import CoreLocation

// MARK: - Data types

public protocol LocationClientType {
    var location: CLLocation? { get }
    var authorizationStatus: CLAuthorizationStatus { get }
    func requestLocation()
    func requestWhenInUseAuthorization()
    func startMonitoringSignificantLocationChanges()
    func stopMonitoringSignificantLocationChanges()
}

public final class StubLocationClient: LocationClientType {
    
    public init() {}
    
    private static let nearKingsCross = CLLocation(latitude: 51.53104336273923, longitude: -0.12064156021021255)
    
    public var location: CLLocation? = nearKingsCross
    public var authorizationStatus: CLAuthorizationStatus = .authorizedWhenInUse
    
    public func requestLocation() {}
    public func requestWhenInUseAuthorization() {}
    public func startMonitoringSignificantLocationChanges() {}
    public func stopMonitoringSignificantLocationChanges() {}

}

public extension LocationClientType {
    
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

extension CLLocationManager: LocationClientType {}
