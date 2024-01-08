import CoreLocation

public final class StubLocationManager: LocationManagerType {
    
    public init() {}
    
    private static let nearKingsCross = CLLocation(latitude: 51.53104336273923, longitude: -0.12064156021021255)
    
    public var location: CLLocation? = nearKingsCross
    public var authorizationStatus: CLAuthorizationStatus = .authorizedWhenInUse
    
    public func requestLocation() {}
    public func requestWhenInUseAuthorization() {}
    public func startMonitoringSignificantLocationChanges() {}
    public func stopMonitoringSignificantLocationChanges() {}

}
