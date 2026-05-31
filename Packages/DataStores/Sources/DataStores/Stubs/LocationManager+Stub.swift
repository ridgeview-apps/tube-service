import CoreLocation

public final class StubLocationManager: LocationManagerType, @unchecked Sendable {
    
    public init() {}
    
    public var authorizationStatus: CLAuthorizationStatus = .authorizedWhenInUse
    public private(set) var requestLocationCallCount = 0
    public private(set) var requestWhenInUseAuthorizationCallCount = 0
    public private(set) var startMonitoringChangesCallCount = 0
    public private(set) var stopMonitoringChangesCallCount = 0
    private weak var delegate: CLLocationManagerDelegate?
    
    public func setDelegate(_ delegate: CLLocationManagerDelegate) {
        self.delegate = delegate
    }
    
    public func requestLocation() {
        requestLocationCallCount += 1
    }
    
    public func requestWhenInUseAuthorization() {
        requestWhenInUseAuthorizationCallCount += 1
    }
    
    public func startMonitoringSignificantLocationChanges() {
        startMonitoringChangesCallCount += 1
    }
    
    public func stopMonitoringSignificantLocationChanges() {
        stopMonitoringChangesCallCount += 1
    }
    
    public func simulateAuthorizationChange(_ authorizationStatus: CLAuthorizationStatus) {
        self.authorizationStatus = authorizationStatus
        delegate?.locationManagerDidChangeAuthorization?(CLLocationManager())
    }
    
    public func simulateLocationUpdate(_ locations: [CLLocation]) {
        delegate?.locationManager?(CLLocationManager(), didUpdateLocations: locations)
    }
    
    public func simulateLocationFailure(_ error: Error) {
        delegate?.locationManager?(CLLocationManager(), didFailWithError: error)
    }

}
