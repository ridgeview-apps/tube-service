import Combine
import CoreLocation
import DataStores
import Foundation

@MainActor
final class AppDataStore: ObservableObject {
    
    let transportAPI: TransportAPIClientType
    let userDefaults: UserDefaults
    let locationManager: LocationManagerType
    
    private(set) var lineStatus: LineStatusDataStore
    private(set) var stations: StationsDataStore
    private(set) var userPreferences: UserPreferencesDataStore
    private(set) var location: LocationDataStore
    
    init(transportAPI: TransportAPIClientType,
         userDefaults: UserDefaults,
         locationManager: LocationManagerType,
         now: @escaping () -> Date = { Date() }) {
        self.transportAPI = transportAPI
        self.userDefaults = userDefaults
        self.locationManager = locationManager
        
        self.lineStatus = LineStatusDataStore(transportAPI: transportAPI, now: now)
        self.stations = StationsDataStore(transportAPI: transportAPI)
        self.userPreferences = UserPreferencesDataStore(userDefaults: userDefaults)
        self.location = LocationDataStore(locationManager: locationManager)
    }
}


extension AppDataStore {
    static var real: AppDataStore {
        .init(transportAPI: TransportAPIClient(baseURL: AppConfig.real.transportAPI.baseURL,
                                               appID: AppConfig.real.transportAPI.appID,
                                               appKey: AppConfig.real.transportAPI.appKey),
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
