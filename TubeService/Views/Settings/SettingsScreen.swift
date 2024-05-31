import DataStores
import Models
import PresentationViews
import RidgeviewCore
import SwiftUI

struct SettingsScreen: View {
    
    @Environment(\.appEnvironment) var appEnvironment
    @Environment(\.locale) var locale
    @Environment(\.dismiss) var dismiss
    
    @AppStorage(UserDefaults.Keys.userPreferences.rawValue, store: AppEnvironment.shared.userDefaults)
    private var userPreferences: UserPreferences = .default
    
    @State private var editableValues: Settings.EditableValues = .default
    
    var body: some View {
        NavigationStack {
            SettingsView(appVersionNumber: Bundle.main.appVersionNumber,
                         appReviewURL: appEnvironment.appReviewURL,
                         contactUs: .init(emailAddress: appEnvironment.contactUsEmail,
                                          appVersion: Bundle.main.appVersionNumber,
                                          appName: Bundle.main.appName,
                                          deviceInfo: Device.current.modelName,
                                          localeInfo: "\(locale.identifier) - \(locale.language.languageCode?.identifier ?? "")"),
                         editableValues: $editableValues)
            .navigationTitle(Text(.settingsNavigationTitle))
            .toolbar {
                NavigationButton.Close { dismiss() }
            }
            .onChange(of: editableValues) { _, newValue in
                userPreferences.saveJourneyPlannerModes(newValue.journeyPlannerModesSelection)
            }
            .task {
                editableValues = .init(journeyPlannerModesSelection: userPreferences.journeyPlannerModeIDs)
            }
        }
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
