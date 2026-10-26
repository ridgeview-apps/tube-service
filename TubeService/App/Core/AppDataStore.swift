import CoreLocation
import DataStores
import Foundation
import Models
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

    init(dependencies: AppDependencies) {
        self.dependencies = dependencies

        let stations = StationsDataStore(tflAPI: dependencies.tflAPI)
        self.stations = stations

        let purchases = PurchaseStore(
            productIDs: dependencies.purchaseProductIDs,
            featureFlags: { dependencies.userDefaults.value.featureFlags }
        )
        self.purchases = purchases

        self.lineStatus = LineStatusDataStore(
            tflAPI: dependencies.tflAPI,
            tubeServiceAPI: dependencies.tubeServiceAPI,
            now: dependencies.now,
            featureFlags: { dependencies.userDefaults.value.featureFlags },
            hasTubeServicePlus: { purchases.hasTubeServicePlus }
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
        await applyEntitlements()
    }

    func handleRegisteredPushToken(_ token: String) async {
        await notifications.handlePushToken(token, appVersion: Bundle.main.appVersion)
    }

    func handleNotificationLaunch(_ payload: LineStatusNotificationPayload) async {
        if lineStatus.requiresRefresh(for: payload) {
            await lineStatus.refresh(for: .live)
        }
    }

    /// Line status screens may have refreshed before Plus was known (entitlements load at launch, or the user has just
    /// subscribed), skipping the disruption summary. Line statuses are still fresh, so only the summary is requested.
    func tubeServicePlusDidChange(_ hasTubeServicePlus: Bool) async {
        await applyEntitlements()
        guard hasTubeServicePlus else { return }
        await lineStatus.refreshIfStale(for: .live)
    }

    func sceneDidBecomeActive() async {
        await purchases.refreshEntitlements()
        await applyEntitlements()
        await notifications.refreshAuthorizationStatus()
    }

    /// Applies the entitlements once loaded (e.g. turning the notification device off if a subscription has lapsed, and
    /// back on if it's been restored).
    private func applyEntitlements() async {
        guard purchases.hasLoadedEntitlements else { return }
        await notifications.setDeviceEnabled(purchases.hasTubeServicePlus)
    }
}
