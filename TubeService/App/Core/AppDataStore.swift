import CoreLocation
import DataStores
import Foundation
@preconcurrency import MapKit
import Shared

@MainActor
@Observable
final class AppDataStore {

    private(set) var lineStatus: LineStatusDataStore
    private(set) var stations: StationsDataStore
    private(set) var location: LocationDataStore
    private(set) var localSearchResults: LocalSearchResultsStore
    private(set) var systemStatus: SystemStatusDataStore
    private(set) var purchases: PurchaseStore
    private(set) var notifications: NotificationsDataStore
    private(set) var journeyPlanner: JourneyPlannerStore

    private let dependencies: AppDependencies

    var tflAPI: TflAPIClientType {
        dependencies.tflAPI
    }

    init(dependencies: AppDependencies) {
        self.dependencies = dependencies

        let stations = StationsDataStore(tflAPI: dependencies.tflAPI)
        self.stations = stations

        self.lineStatus = LineStatusDataStore(
            tflAPI: dependencies.tflAPI,
            tubeServiceAPI: dependencies.tubeServiceAPI,
            now: dependencies.now,
            featureFlags: { dependencies.userDefaults.value.featureFlags }
        )
        self.location = LocationDataStore(
            locationManager: dependencies.locationManager,
            stations: stations
        )
        let localSearchResults = LocalSearchResultsStore(completerClient: dependencies.localSearchCompleterClient)
        self.localSearchResults = localSearchResults
        self.systemStatus = SystemStatusDataStore(
            systemStatusAPI: dependencies.systemStatusAPI,
            now: dependencies.now
        )
        self.purchases = PurchaseStore()
        self.notifications = NotificationsDataStore(
            api: dependencies.notificationsAPI,
            pushNotificationEnvironment: dependencies.pushNotificationEnvironment,
            userDefaults: dependencies.userDefaults.value,
        )
        self.journeyPlanner = JourneyPlannerStore(
            tflAPI: dependencies.tflAPI,
            localSearchResults: localSearchResults
        )
    }

    func start() async {
        dependencies.userDefaults.value.migrateLegacyValuesIfNeeded()
        await purchases.start()
    }

    func handlePushToken(_ token: String) async {
        await notifications.registerDevice(pushToken: token, appVersion: Bundle.main.shortVersion)
    }

    func sceneDidBecomeActive() async {
        await purchases.refreshEntitlements()
        await notifications.updateAuthorizationStatus()
    }
}
