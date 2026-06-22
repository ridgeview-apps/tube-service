import DataStores
import Foundation

struct AppDependencies: Sendable {
    let tflAPI: TflAPIClientType
    let tubeServiceAPI: TubeServiceAPIClientType
    let notificationsAPI: NotificationsAPIClientType
    let systemStatusAPI: SystemStatusAPIClientType
    let locationManager: LocationManagerType
    let localSearchCompleterClient: LocalSearchCompleterClientType
    let userDefaults: UserDefaultsProvider
    let authorizationProvider: AuthorizationProvider
    let now: @Sendable () -> Date

    init(
        tflAPI: TflAPIClientType,
        tubeServiceAPI: TubeServiceAPIClientType,
        notificationsAPI: NotificationsAPIClientType,
        systemStatusAPI: SystemStatusAPIClientType,
        locationManager: LocationManagerType,
        localSearchCompleterClient: LocalSearchCompleterClientType,
        userDefaults: UserDefaultsProvider,
        authorizationProvider: AuthorizationProvider,
        now: @escaping @Sendable () -> Date = { .now }
    ) {
        self.tflAPI = tflAPI
        self.tubeServiceAPI = tubeServiceAPI
        self.notificationsAPI = notificationsAPI
        self.systemStatusAPI = systemStatusAPI
        self.locationManager = locationManager
        self.localSearchCompleterClient = localSearchCompleterClient
        self.userDefaults = userDefaults
        self.authorizationProvider = authorizationProvider
        self.now = now
    }
}

extension AppDependencies {
    #if DEBUG
        private nonisolated(unsafe) static var previewOverride: AppDependencies?

        static func setPreviewOverride(_ dependencies: AppDependencies) {
            previewOverride = dependencies
        }
    #endif

    static let current: AppDependencies = {
        #if DEBUG
            if let previewOverride {
                return previewOverride
            }

            if ProcessInfo.isRunningUnitTests || ProcessInfo.isRunningUITests {
                return .stub
            }
        #endif


        return .live
    }()
}
