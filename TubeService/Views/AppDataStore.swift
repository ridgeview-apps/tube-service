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
    private(set) var location: LocationDataStore
    private(set) var localSearchCompleter: LocalSearchCompleter
    private(set) var systemStatus: SystemStatusDataStore
    
    init(
        transportAPI: TransportAPIClientType,
        systemStatusAPI: SystemStatusAPIClientType,
        userDefaults: UserDefaults,
        locationManager: LocationManagerType,
        localSearchCompleter: LocalSearchCompleter = .init(),
        now: @escaping () -> Date = { Date() }
    ) {
        self.transportAPI = transportAPI
        self.userDefaults = userDefaults
        self.locationManager = locationManager
        
        let stations = StationsDataStore(transportAPI: transportAPI)
        self.stations = stations
        
        self.lineStatus = LineStatusDataStore(transportAPI: transportAPI, now: now)        
        self.location = LocationDataStore(locationManager: locationManager,
                                          stations: stations)
        self.localSearchCompleter = localSearchCompleter
        self.systemStatus = SystemStatusDataStore(systemStatusAPI: systemStatusAPI, now: now)
    }
}


extension AppDataStore {
    static let shared: AppDataStore = {
        #if DEBUG
        if ProcessInfo.isRunningUITests {
            return .stub()
        }
        #endif
        
        return .init(
            transportAPI: TransportAPIClient.shared,
            systemStatusAPI: SystemStatusAPIClient.shared,
            userDefaults: .standard,
            locationManager: CLLocationManager())
    }()
}

extension TransportAPIClient {
    static let shared = TransportAPIClient(
        baseURL: AppConfig.shared.transportAPI.baseURL,
        appID: AppConfig.shared.transportAPI.appID,
        appKey: AppConfig.shared.transportAPI.appKey
    )
}

extension SystemStatusAPIClient {
    static let shared = SystemStatusAPIClient(
        baseURL: AppConfig.shared.systemStatusAPI.baseURL,
        fileName: AppConfig.shared.systemStatusAPI.fileName
    )
}

#if DEBUG
extension AppDataStore {
    static func stub() -> AppDataStore {
        .init(transportAPI: StubTransportAPIClient(),
              systemStatusAPI: StubSystemStatusAPIClient(),
              userDefaults: .standard,
              locationManager: StubLocationManager())
    }
}
#endif
