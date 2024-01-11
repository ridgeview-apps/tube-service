import CoreLocation
import Models
import Foundation

@MainActor
@Observable
public final class LocationDataStore: NSObject {
    
    private let locationManager: LocationManagerType
    
    public enum DetectionState {
        case detecting
        case failed(Error)
        case detected
    }
    
    public private(set) var authorizationStatus: CLAuthorizationStatus
    public private(set) var currentLocation: Location?
    public private(set) var detectionState: DetectionState = .detecting
    
    public var isAuthorized: Bool {
        locationManager.isAuthorized
    }
    
    public init(locationManager: LocationManagerType) {
        self.locationManager = locationManager
        self.authorizationStatus = locationManager.authorizationStatus
        self.currentLocation = locationManager.location?.toLocation()
        super.init()
        (locationManager as? CLLocationManager)?.delegate = self
    }
    
    public func nearestStations(to location: Location, in stations: [Station]) -> [NearbyStation] {
        let userLocation = location.toCLLocation()
        
        let nearestStations = stations.map {
            let stationLocation = $0.location.toCLLocation()
            return NearbyStation(distance: userLocation.distance(from: stationLocation),
                                 station: $0)
        }.sorted {
            $0.distance < $1.distance
        }
        
        return nearestStations
    }
    
    public func promptForPermissions() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    public func refreshCurrentLocation() {
        detectionState = .detecting
        locationManager.requestLocation()
    }
        
    public func startDetectingCurrentLocationIfAuthorized() {
        guard isAuthorized else {
            return
        }
        locationManager.requestLocation()
        locationManager.startMonitoringSignificantLocationChanges()
    }
    
    public func stopDetectingCurrentLocation() {
        locationManager.stopMonitoringSignificantLocationChanges()
    }
}


// MARK: - CLLocationManagerDelegate

// N.B. I could've moved the delegate to a separate NSObject (to prevent LocationModel from having to conform to NSObject
// but it added unnecesssary complexity for no added benefit).

extension LocationDataStore: CLLocationManagerDelegate {
    
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
        startDetectingCurrentLocationIfAuthorized() // i.e. CHANGED to authorized (e.g. so permissions have just been granted)
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        detectionState = .failed(error)
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last?.toLocation() else {
            return
        }
        detectionState = .detected
        currentLocation = location
    }
}
