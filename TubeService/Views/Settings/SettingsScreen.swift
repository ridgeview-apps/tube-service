import DataStores
import Models
import PresentationViews
import Shared
import SwiftUI

struct SettingsScreen: View {

    @Environment(\.appConfig) private var appConfig
    @Environment(\.locale) private var locale
    @Environment(\.openSettings) private var openSettings
    @Environment(PurchaseStore.self) private var purchases
    @Environment(SystemStatusDataStore.self) private var systemStatusData
    @Environment(NotificationsDataStore.self) private var notifications

    @State private var router = Router<SettingsRoute>()
    @State private var showManageSubscriptionsSheet = false

    @AppStorage(
        UserDefaults.Keys.userPreferences.rawValue,
        store: AppDependencies.current.userDefaults.value
    )
    private var userPreferences: UserPreferences = .default

    @AppStorage(
        UserDefaults.Keys.featureFlags.rawValue,
        store: AppDependencies.current.userDefaults.value
    )
    private var featureFlags: FeatureFlags = .default

    var body: some View {
        NavigationStack(path: $router.navigation.path) {
            rootView
                .appSheetRouter($router.sheetRouter)
                .navigationDestination(for: SettingsRoute.self) { route in
                    destinationView(for: route)
                }
        }
    }

    private var rootView: some View {
        SettingsView(
            appVersionNumber: Bundle.main.appVersionDisplayString ?? "",
            appReviewURL: appConfig.appReviewURL,
            contactUs: contactUsConfig,
            systemStatus: systemStatusData.currentStatus,
            notificationRowState: notificationRowState,
            isSubscribed: purchases.hasTubeServicePlus,
            onAction: handleAction
        )
        .manageSubscriptions(isPresented: $showManageSubscriptionsSheet)
        .navigationTitle(Text(L10n.settingsNavigationTitle))
    }

    private var showNotificationsRow: Bool {
        featureFlags.isNotificationsEnabled
    }

    private var notificationRowState: Settings.NotificationRowState {
        .init(
            isVisible: showNotificationsRow,
            showsPermissionWarning: notifications.isPermissionDenied,
            isPaused: notifications.device?.enabled == false
        )
    }

    private var contactUsConfig: Settings.ContactUs {
        .init(
            emailAddress: appConfig.contactUsEmail,
            appVersion: Bundle.main.appVersionDisplayString ?? "",
            appName: Bundle.main.appName ?? "",
            deviceInfo: Device.modelDescription,
            localeInfo: "\(locale.identifier) - \(locale.language.languageCode?.identifier ?? "")"
        )
    }

    private func handleAction(_ action: SettingsView.Action) {
        switch action {
        case .openDebugSettings:
            router.navigation.push(.debugSettings)
        case .manageSubscription:
            showManageSubscriptionsSheet = true
        case .notificationsTapped:
            router.sheetRouter.show(
                .notificationSettings(.globalSettings, notifications.isConfigured ? .manage : .onboarding),
                style: .standard
            )
        }
    }

    @ViewBuilder
    private func destinationView(for route: SettingsRoute) -> some View {
        switch route {
        case .debugSettings:
            DebugSettingsScreen()
        }
    }
}


// MARK: - Previews

#if DEBUG
    #Preview {
        PreviewEnvironment {
            SettingsScreen()
        }
    }
#endif
