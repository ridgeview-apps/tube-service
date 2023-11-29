import Combine
import CoreLocation
import DataClients
import Models
import Foundation


@MainActor
public final class LocationModel: NSObject, ObservableObject {
    
    private let locationManager: LocationClientType
    
    enum DetectionState {
        case detecting
        case failed(Error)
        case detected
    }
    
    @Published private(set) var authorizationStatus: CLAuthorizationStatus
    @Published private(set) var currentLocation: Location?
    @Published private(set) var refreshDate: Date?
    @Published private(set) var detectionState: DetectionState = .detecting
    
    public init(locationManager: LocationClientType) {
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
    
    func promptForPermissions() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func refreshCurrentLocation() {
        detectionState = .detecting
        locationManager.requestLocation()
    }
        
    func startDetectingCurrentLocationIfAuthorized() {
        guard isAuthorized else {
            return
        }
        locationManager.requestLocation()
        locationManager.startMonitoringSignificantLocationChanges()
    }
    
    func stopDetectingCurrentLocation() {
        locationManager.stopMonitoringSignificantLocationChanges()
    }
    
    var isAuthorized: Bool {
        locationManager.isAuthorized
    }
}


// MARK: - CLLocationManagerDelegate

// N.B. I could've moved the delegate to a separate NSObject (to prevent LocationModel from having to conform to NSObject
// but it added unnecesssary complexity for no added benefit).

extension LocationModel: CLLocationManagerDelegate {
    
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
        refreshDate = .now
    }
}
