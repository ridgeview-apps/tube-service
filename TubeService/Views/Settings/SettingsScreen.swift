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
    @Environment(Navigator.self) private var navigator

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
        .navigationBarTitleDisplayMode(.inline)
        .toolbar { CloseToolbarItem() }
    }

    private var showNotificationsRow: Bool {
        featureFlags.isNotificationsEnabled
    }

    private var notificationRowState: Settings.NotificationRowState {
        .init(
            isVisible: showNotificationsRow,
            showsPermissionWarning: notifications.isPermissionDenied,
            configuredLineCount: notifications.linePreferences.count
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
            navigator.push(.debugSettings)
        case .manageSubscription:
            showManageSubscriptionsSheet = true
        case .notificationsTapped:
            navigator.present(.notifications(.root(lineID: nil)))
        case .systemStatusTapped:
            navigator.push(.systemStatus)
        }
    }
}


// MARK: - Previews

#if DEBUG
    #Preview {
        PreviewEnvironment(withNavigationHost: true) {
            SettingsScreen()
        }
    }
#endif
