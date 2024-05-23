import CoreLocation
import DataStores
import Foundation

@MainActor
@Observable
final class AppDataStore {
    
    let transportAPI: TransportAPIClientType
    let userDefaults: UserDefaults
    let locationManager: LocationManagerType
    
    private(set) var lineStatus: LineStatusDataStore
    private(set) var stations: StationsDataStore
    private(set) var userPreferences: UserPreferencesDataStore
    private(set) var location: LocationDataStore
    private(set) var localSearchCompleter: LocalSearchCompleter
    
    init(transportAPI: TransportAPIClientType,
         userDefaults: UserDefaults,
         locationManager: LocationManagerType,
         now: @escaping () -> Date = { Date() }) {
        self.transportAPI = transportAPI
        self.userDefaults = userDefaults
        self.locationManager = locationManager
        
        let stations = StationsDataStore(transportAPI: transportAPI)
        self.stations = stations
        
        self.lineStatus = LineStatusDataStore(transportAPI: transportAPI, now: now)        
        self.userPreferences = UserPreferencesDataStore(userDefaults: userDefaults)
        self.location = LocationDataStore(locationManager: locationManager,
                                          stations: stations)
        self.localSearchCompleter = LocalSearchCompleter()
    }
}


extension AppDataStore {
    static var shared: AppDataStore {
        .init(transportAPI: TransportAPIClient(baseURL: AppEnvironment.shared.transportAPI.baseURL,
                                               appID: AppEnvironment.shared.transportAPI.appID,
                                               appKey: AppEnvironment.shared.transportAPI.appKey),
              userDefaults: .standard,
              locationManager: CLLocationManager())
    }
}

#if DEBUG
extension AppDataStore {
    static func stub() -> AppDataStore {
        .init(transportAPI: StubTransportAPIClient(),
              userDefaults: .standard,
              locationManager: StubLocationManager())
    }
}
#endif
