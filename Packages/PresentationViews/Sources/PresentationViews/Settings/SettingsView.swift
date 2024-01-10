import Models
import SwiftUI

public struct SettingsView: View {
    
    public typealias ContactUs = Settings.ContactUs
    
    public let appVersionNumber: String
    public let appReviewURL: URL
    public let contactUs: ContactUs
    
    public init(appVersionNumber: String,
                appReviewURL: URL,
                contactUs: ContactUs) {
        self.appVersionNumber = appVersionNumber
        self.appReviewURL = appReviewURL
        self.contactUs = contactUs
    }
        
    public var body: some View {
        Form {
            List {
                aboutSection
                supportSection
            }
        }
    }
        
    
    // MARK: - Layout views
    
    private var aboutSection: some View {
        Section(
            header: Text("settings.section.about.title", bundle: .module)
        ) {
            HStack {
                Text("settings.app.version.title", bundle: .module)
                Spacer()
                Text(appVersionNumber)
            }
            .contentShape(Rectangle())
            NavigationLink {
                acknowledgements
            } label: {
                Text("settings.acknowledgements.title", bundle: .module)
            }
        }
    }
    
    @ViewBuilder private var acknowledgements: some View {
        if let acknowledgementsURL = URL(string: "https://tfl.gov.uk/info-for/open-data-users/") {
            HStack {
                Text("settings.app.powered.by", bundle: .module)
                Link("TfL Open Data",
                     destination: acknowledgementsURL)
                
                .foregroundColor(.blue)
            }
            .font(.headline)
        }
    }
    
    private var supportSection: some View {
        Section(
            header: Text("settings.section.support.title", bundle: .module)
        ) {
            MailButton(to: [contactUs.emailAddress],
                       subject: emailSubject,
                       body: emailBody) {
                Text("settings.contact.us.title", bundle: .module)
            }
            Link(destination: appReviewURL) {
                Text("settings.rate.this.app.title", bundle: .module)
            }
        }
    }
    
    private var emailSubject: String {
        String(format: localizedString("contact.us.subject %@"), contactUs.appName)
    }
    
    private var emailBody: String {
            """
            \(localizedString("contact.us.body.diagnostic.info"))
            
            \(localizedString("contact.us.body.app.version")): \(contactUs.appVersion)
            \(localizedString("contact.us.body.device.info")): \(contactUs.deviceInfo)
            \(localizedString("contact.us.body.locale.info")): \(contactUs.localeInfo)
            """
    }
    
    private func localizedString(_ key: String) -> String {
        NSLocalizedString(key, bundle: .module, comment: "")
    }
}


// MARK: - Previews
#if DEBUG
struct Settings_Previews: PreviewProvider {
    
    
    static var previews: some View {
        NavigationStack {
            SettingsView(
                appVersionNumber: "1.1.1",
                appReviewURL: URL(string: "https://www.google.com")!,
                contactUs: .empty
            )
        }

    }
}

#endif
