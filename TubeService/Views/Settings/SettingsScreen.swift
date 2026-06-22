import DataStores
import Models
import PresentationViews
import RidgeviewCore
import SwiftUI

struct SettingsScreen: View {

    private enum DestinationID: Identifiable {
        var id: Self { self }
        case debugMenu
        case notificationsPreferences
    }

    @Environment(\.appConfig) var appConfig
    @Environment(\.locale) var locale
    @Environment(\.openSettings) var openSettings
    @Environment(\.showSheet) var showSheet
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

    @State private var navigationState = NavigationState<DestinationID>()

    var body: some View {
        NavigationStack(path: $navigationState.navigationPath) {
            SettingsView(
                appVersionNumber: Bundle.main.appVersionNumber,
                appReviewURL: appConfig.appReviewURL,
                contactUs: contactUsConfig,
                systemStatus: systemStatusData.currentStatus,
                notificationsRowState: notificationsRowState,
                onAction: handleAction
            )
            .withCloseToolbarButton()
            .navigationTitle(Text(L10n.settingsNavigationTitle))
            .navigationDestination(for: DestinationID.self) { destinationID in
                destinationView(for: destinationID)
            }
        }
    }

    private var notificationsRowState: Settings.NotificationsRowState? {
        guard featureFlags.isNotificationsEnabled else { return nil }
        guard notifications.preferences?.enabled == true else { return .notSetUp }
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
            navigationState.push(to: .debugMenu)
        case .notificationsTapped:
            switch notificationsRowState {
            case .active:
                navigationState.push(to: .notificationsPreferences)
            case .permissionDenied:
                openSettings()
            default:
                showSheet(.notificationsOnboarding())
            }
        }
    }

    @ViewBuilder
    private func destinationView(for destinationID: DestinationID) -> some View {
        switch destinationID {
        case .debugMenu:
            DebugSettingsScreen()
        case .notificationsPreferences:
            if let preferences = notifications.preferences {
                NotificationsPreferencesScreen(preferences: preferences)
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
