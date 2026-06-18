import DataStores
import Models
import PresentationViews
import RidgeviewCore
import SwiftUI

struct SettingsScreen: View {

    private enum DestinationID: Identifiable {
        var id: Self { self }
        case debugMenu
    }

    @Environment(\.appConfig) var appConfig
    @Environment(\.locale) var locale
    @Environment(SystemStatusDataStore.self) var systemStatusData

    @AppStorage(
        UserDefaults.Keys.userPreferences.rawValue,
        store: AppDependencies.current.userDefaults.value
    )
    private var userPreferences: UserPreferences = .default

    @State private var navigationState = NavigationState<DestinationID>()

    var body: some View {
        NavigationStack(path: $navigationState.navigationPath) {
            SettingsView(
                appVersionNumber: Bundle.main.appVersionNumber,
                appReviewURL: appConfig.appReviewURL,
                contactUs: contactUsConfig,
                systemStatus: systemStatusData.currentStatus,
                onAction: handleAction
            )
            .withCloseToolbarButton()
            .navigationTitle(Text(L10n.settingsNavigationTitle))
            .navigationDestination(for: DestinationID.self) { destinationID in
                destinationView(for: destinationID)
            }
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
        navigationState.push(to: .debugMenu)
    }

    @ViewBuilder
    private func destinationView(for destinationID: DestinationID) -> some View {
        switch destinationID {
        case .debugMenu:
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
