import DeviceKit
import Models
import PresentationViews
import SwiftUI

struct SettingsScreen: View {
    
    @Environment(\.appConfig) var appConfig
    @Environment(\.locale) var locale
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            SettingsView(appVersionNumber: Bundle.main.appVersionNumber,
                         appReviewURL: appConfig.appReviewURL,
                         contactUs: .init(emailAddress: appConfig.contactUsEmail,
                                          appVersion: Bundle.main.appVersionNumber,
                                          appName: Bundle.main.appName,
                                          deviceInfo: Device.current.safeDescription,
                                          localeInfo: "\(locale.identifier) - \(locale.language.languageCode?.identifier ?? "")"))
            .navigationTitle("settings.navigation.title")
            .toolbar {
                NavigationButton.Close { dismiss() }
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
