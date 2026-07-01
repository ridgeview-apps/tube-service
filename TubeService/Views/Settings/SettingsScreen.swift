import DataStores
import Models
import PresentationViews
import RidgeviewCore
import SwiftUI

struct SettingsScreen: View {

    @Environment(\.appConfig) private var appConfig
    @Environment(\.locale) private var locale
    @Environment(\.openSettings) private var openSettings
    @Environment(PurchaseStore.self) private var purchases
    @Environment(SystemStatusDataStore.self) private var systemStatusData
    @Environment(NotificationsDataStore.self) private var notifications

    @State private var router = Router<SettingsRoute>()

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
            appVersionNumber: Bundle.main.appVersionNumber,
            appReviewURL: appConfig.appReviewURL,
            contactUs: contactUsConfig,
            systemStatus: systemStatusData.currentStatus,
            notificationsButtonState: notificationsButtonState,
            onAction: handleAction
        )
        .navigationTitle(Text(L10n.settingsNavigationTitle))
    }

    private var notificationsButtonState: NotificationsButtonState? {
        guard featureFlags.isNotificationsEnabled else { return nil }
        guard purchases.hasTubeServicePlus else { return .locked }
        guard let prefs = notifications.preferences, !prefs.lines.isEmpty else {
            return .notSetUp
        }
        if notifications.canReceivePushNotifications {
            return .active
        } else if notifications.isPermissionDenied {
            return .permissionDenied
        } else {
            return .notSetUp
        }
    }

    private var contactUsConfig: Settings.ContactUs {
        .init(
            emailAddress: appConfig.contactUsEmail,
            appVersion: Bundle.main.appVersionNumber,
            appName: Bundle.main.appName,
            deviceInfo: Device.modelName,
            localeInfo: "\(locale.identifier) - \(locale.language.languageCode?.identifier ?? "")"
        )
    }

    private func handleAction(_ action: SettingsView.Action) {
        switch action {
        case .openDebugSettings:
            router.navigation.push(.debugSettings)
        case .notificationsTapped:
            switch notificationsButtonState {
            case .permissionDenied:
                openSettings()
            case .locked, .active, .inactive, .notSetUp, nil:
                router.sheetRouter.show(
                    .notificationSettings(.globalSettings, notifications.hasCompletedOnboarding ? .manage : .onboarding),
                    style: .fullScreen
                )
            }
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
