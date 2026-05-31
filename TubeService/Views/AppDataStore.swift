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
    private(set) var localSearchResults: LocalSearchResultsStore
    private(set) var systemStatus: SystemStatusDataStore
    
    init(
        transportAPI: TransportAPIClientType,
        systemStatusAPI: SystemStatusAPIClientType,
        userDefaults: UserDefaults,
        locationManager: LocationManagerType,
        localSearchResults: LocalSearchResultsStore = .init(),
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
        self.localSearchResults = localSearchResults
        self.systemStatus = SystemStatusDataStore(systemStatusAPI: systemStatusAPI, now: now)
    }
    
    func initialiseAppData() {
        userDefaults.migrateLegacyValuesIfNeeded()
    }
}


extension AppDataStore {
    static let live: AppDataStore = .init(
        transportAPI: TransportAPIClient.live,
        systemStatusAPI: SystemStatusAPIClient.live,
        userDefaults: .standard,
        locationManager: CLLocationManager()
    )
}

extension TransportAPIClient {
    static let live = TransportAPIClient(
        baseURL: AppConfig.shared.transportAPI.baseURL,
        appID: AppConfig.shared.transportAPI.appID,
        appKey: AppConfig.shared.transportAPI.appKey
    )
}

extension SystemStatusAPIClient {
    static let live = SystemStatusAPIClient(
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
