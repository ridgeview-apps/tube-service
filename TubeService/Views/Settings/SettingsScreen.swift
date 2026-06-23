import DataStores
import Models
import PresentationViews
import RidgeviewCore
import SwiftUI

struct SettingsScreen: View {

    private enum DestinationID: Identifiable, Hashable {
        var id: Self { self }
        case debugMenu
        case notificationsOnboarding(preselectedLine: TrainLineID?)
        case manageNotifications
    }

    @Environment(\.appConfig) var appConfig
    @Environment(\.locale) var locale
    @Environment(\.openSettings) var openSettings
    @Environment(SystemStatusDataStore.self) var systemStatusData
    @Environment(NotificationsDataStore.self) var notifications

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

    @State private var path = NavigationPath()

    var body: some View {
        NavigationStack(path: $path) {
            SettingsView(
                appVersionNumber: Bundle.main.appVersionNumber,
                appReviewURL: appConfig.appReviewURL,
                contactUs: contactUsConfig,
                systemStatus: systemStatusData.currentStatus,
                notificationsButtonState: notificationsButtonState,
                onAction: handleAction
            )
            .withCloseToolbarButton()
            .navigationTitle(Text(L10n.settingsNavigationTitle))
            .navigationDestination(for: DestinationID.self) { destinationID in
                destinationView(for: destinationID)
            }
        }
    }

    private var notificationsButtonState: NotificationsButtonState? {
        guard featureFlags.isNotificationsEnabled else { return nil }
        guard let prefs = notifications.preferences, !prefs.lines.isEmpty else { return .notSetUp }
        switch notifications.authorizationStatus {
        case .authorized, .provisional, .ephemeral:
            return .active
        case .denied:
            return .permissionDenied
        default:
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
            path.append(DestinationID.debugMenu)
        case .notificationsTapped:
            switch notificationsButtonState {
            case .permissionDenied:
                openSettings()
            case .active:
                path.append(DestinationID.manageNotifications)
            default:
                path.append(DestinationID.notificationsOnboarding(preselectedLine: nil))
            }
        }
    }

    @ViewBuilder
    private func destinationView(for destinationID: DestinationID) -> some View {
        switch destinationID {
        case .debugMenu:
            DebugSettingsScreen()
        case .notificationsOnboarding(let preselectedLine):
            NotificationsOnboardingContent(
                preselectedLine: preselectedLine,
                onDismiss: { path = NavigationPath() },
                onNavigate: { step in path.append(step) },
                onReplaceStack: { steps in
                    while path.count > 1 {
                        path.removeLast()
                    }
                    steps.forEach { path.append($0) }
                }
            )
        case .manageNotifications:
            if let prefs = notifications.preferences {
                ManageNotificationsScreen(preferences: prefs)
            }
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
