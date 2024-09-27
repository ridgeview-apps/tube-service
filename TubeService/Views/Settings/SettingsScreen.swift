import DataStores
import Models
import PresentationViews
import RidgeviewCore
import SwiftUI

struct SettingsScreen: View {
    
    @Environment(\.appConfig) var appConfig
    @Environment(\.locale) var locale
    @Environment(\.dismiss) var dismiss
    @Environment(SystemStatusDataStore.self) var systemStatusData
    
    @AppStorage(UserDefaults.Keys.userPreferences.rawValue, store: .standard)
    private var userPreferences: UserPreferences = .default
    
    var body: some View {
        NavigationStack {
            SettingsView(
                appVersionNumber: Bundle.main.appVersionNumber,
                appReviewURL: appConfig.appReviewURL,
                contactUs: contactUsConfig,
                editableValues: editableValues,
                systemStatus: systemStatusData.currentStatus,
                onDebugAction: handleDebugAction
            )
            .navigationTitle(Text(.settingsNavigationTitle))
            .toolbar {
                NavigationButton.Close { dismiss() }
            }
        }
    }
    
    private var editableValues: Binding<Settings.EditableValues> {
        .init(
            get: {
                .init(
                    journeyPlannerModesSelection: userPreferences.journeyPlannerModeIDs
                )
            },
            set: { newValue in
                userPreferences.saveJourneyPlannerModes(
                    newValue.journeyPlannerModesSelection
                )
            }
        )
    }
    
    private var contactUsConfig: Settings.ContactUs {
        .init(emailAddress: appConfig.contactUsEmail,
              appVersion: Bundle.main.appVersionNumber,
              appName: Bundle.main.appName,
              deviceInfo: Device.current.modelName,
              localeInfo: "\(locale.identifier) - \(locale.language.languageCode?.identifier ?? "")")
    }
    
    private func handleDebugAction(_ action: Settings.DebugAction) {
        userPreferences = .default
    }
}


// MARK: - Previews

#if DEBUG
struct SettingsScreen_Previews: PreviewProvider {
    static var previews: some View {
        SettingsScreen()
            .withStubbedEnvironment()
    }
}
#endif
