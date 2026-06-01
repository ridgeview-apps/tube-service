import CoreLocation
import DataStores
import Foundation
@preconcurrency import MapKit

extension AppDependencies {
    static let live = AppDependencies(
        transportAPI: TransportAPIClient.live,
        systemStatusAPI: SystemStatusAPIClient.live,
        locationManager: CLLocationManager(),
        localSearchCompleterClient: MKLocalSearchCompleter(),
        userDefaults: .live
    )
}

extension AppDataStore {
    static let live: AppDataStore = .init(dependencies: .live)
}

extension TransportAPIClient {
    static let live = TransportAPIClient(
        baseURL: AppConfig.main.transportAPI.baseURL,
        appID: AppConfig.main.transportAPI.appID,
        appKey: AppConfig.main.transportAPI.appKey
    )
}

extension SystemStatusAPIClient {
    static let live = SystemStatusAPIClient(
        baseURL: AppConfig.main.systemStatusAPI.baseURL,
        fileName: AppConfig.main.systemStatusAPI.fileName
    )
}

extension UserDefaultsProvider {
    static let live = UserDefaultsProvider(.standard)
}
