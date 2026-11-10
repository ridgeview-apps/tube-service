import DataStores
import Foundation
import Shared
import StoreKit

struct AppDependencies: Sendable {
    let tflAPI: TflAPIClientType
    let tubeServiceAPI: TubeServiceAPIClientType
    let notificationsAPI: NotificationsAPIClientType
    let systemStatusAPI: SystemStatusAPIClientType
    let locationManager: LocationManagerType
    let reverseGeocoder: ReverseGeocoderType
    let localSearchCompleterClient: LocalSearchCompleterClientType
    let userDefaults: UserDefaultsProvider
    let pushNotificationEnvironment: PushNotificationEnvironment
    let purchaseProductIDs: [PurchaseStore.ProductID]
    /// The environment that signed the app's install, or `nil` to read the real one (see `PurchaseStore`).
    let readInstallEnvironment: (@Sendable () async -> AppStore.Environment?)?
    let clock: AppClock

    init(
        tflAPI: TflAPIClientType,
        tubeServiceAPI: TubeServiceAPIClientType,
        notificationsAPI: NotificationsAPIClientType,
        systemStatusAPI: SystemStatusAPIClientType,
        locationManager: LocationManagerType,
        reverseGeocoder: ReverseGeocoderType = MapKitReverseGeocoder(),
        localSearchCompleterClient: LocalSearchCompleterClientType,
        userDefaults: UserDefaultsProvider,
        pushNotificationEnvironment: PushNotificationEnvironment,
        purchaseProductIDs: [PurchaseStore.ProductID],
        readInstallEnvironment: (@Sendable () async -> AppStore.Environment?)? = nil,
        clock: AppClock = .live
    ) {
        self.tflAPI = tflAPI
        self.tubeServiceAPI = tubeServiceAPI
        self.notificationsAPI = notificationsAPI
        self.systemStatusAPI = systemStatusAPI
        self.locationManager = locationManager
        self.reverseGeocoder = reverseGeocoder
        self.localSearchCompleterClient = localSearchCompleterClient
        self.userDefaults = userDefaults
        self.pushNotificationEnvironment = pushNotificationEnvironment
        self.purchaseProductIDs = purchaseProductIDs
        self.readInstallEnvironment = readInstallEnvironment
        self.clock = clock
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

            if let uiTestConfiguration = TubeUITestLaunchConfiguration.fromProcessEnvironment() {
                return .uiTests(uiTestConfiguration)
            }

            if ProcessInfo.isRunningUnitTests {
                return .stub
            }
        #endif

        return .live
    }()
}
