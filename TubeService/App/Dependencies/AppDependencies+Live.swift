import CoreLocation
import DataStores
import Foundation
@preconcurrency import MapKit

extension AppDependencies {
    static let live = AppDependencies(
        tflAPI: TflAPIClient.live,
        systemStatusAPI: SystemStatusAPIClient.live,
        locationManager: CLLocationManager(),
        localSearchCompleterClient: MKLocalSearchCompleter(),
        userDefaults: .live
    )
}

extension AppDataStore {
    static let live: AppDataStore = .init(dependencies: .live)
}

extension TflAPIClient {
    static let live = TflAPIClient(
        baseURL: AppConfig.main.tflAPI.baseURL,
        appKey: AppConfig.main.tflAPI.appKey
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
