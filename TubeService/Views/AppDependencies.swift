import DataStores
import Foundation

struct AppDependencies: Sendable {
    let transportAPI: TransportAPIClientType
    let systemStatusAPI: SystemStatusAPIClientType
    let locationManager: LocationManagerType
    let localSearchCompleterClient: LocalSearchCompleterClientType
    let userDefaults: UserDefaultsProvider
    let now: @Sendable () -> Date

    init(
        transportAPI: TransportAPIClientType,
        systemStatusAPI: SystemStatusAPIClientType,
        locationManager: LocationManagerType,
        localSearchCompleterClient: LocalSearchCompleterClientType,
        userDefaults: UserDefaultsProvider,
        now: @escaping @Sendable () -> Date = { .now }
    ) {
        self.transportAPI = transportAPI
        self.systemStatusAPI = systemStatusAPI
        self.locationManager = locationManager
        self.localSearchCompleterClient = localSearchCompleterClient
        self.userDefaults = userDefaults
        self.now = now
    }
}

extension AppDependencies {
    static let current: AppDependencies = {
        ProcessInfo.isRunningUITests ? .stub : .live
    }()
}
