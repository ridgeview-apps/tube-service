import DataStores
import Foundation

#if DEBUG

extension AppDependencies {
    static let stub = AppDependencies(
        transportAPI: StubTransportAPIClient(),
        systemStatusAPI: StubSystemStatusAPIClient(),
        locationManager: StubLocationManager(),
        localSearchCompleterClient: StubLocalSearchCompleterClient(),
        userDefaults: .stub
    )
}

extension AppDataStore {
    static let stub: AppDataStore = .init(dependencies: .stub)
}

extension UserDefaultsProvider {
    static let stub = UserDefaultsProvider(.init(suiteName: "StubbedSuite")!)
}

#endif
