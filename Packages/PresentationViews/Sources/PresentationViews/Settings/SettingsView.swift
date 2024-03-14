import Models
import SwiftUI

public struct SettingsView: View {
    
    public typealias ContactUs = Settings.ContactUs
    public typealias EditableValues = Settings.EditableValues
    
    public let appVersionNumber: String
    public let appReviewURL: URL
    public let contactUs: ContactUs
    
    @Binding var editableValues: EditableValues
    
    public init(appVersionNumber: String,
                appReviewURL: URL,
                contactUs: ContactUs,
                editableValues: Binding<EditableValues>) {
        self.appVersionNumber = appVersionNumber
        self.appReviewURL = appReviewURL
        self.contactUs = contactUs
        self._editableValues = editableValues
    }
        
    public var body: some View {
        Form {
            journeyPlannerSection
            supportSection
            aboutSection
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

    private var journeyPlannerSection: some View {
        Section(
            header: Text("settings.journey.planner.title", bundle: .module)
        ) {
            NavigationLink {
                JourneyModePickerView(
                    selection: $editableValues.journeyPlannerModesSelection
                )
                .navigationTitle(Text("settings.journey.mode.picker.navigation.title", bundle: .module))
            } label: {
                HStack {
                    Text("settings.journey.planner.transport.modes", bundle: .module)
                    Spacer()
                    modesDetailLabelTitle
                }
            }
        }
    }
    
    private var modesDetailLabelTitle: some View {
        if editableValues.allJourneyPlannerModesSelected {
            Text("journey.planner.travel.options.modes.detail.all", bundle: .module)
        } else {
            Text("journey.planner.travel.options.modes.selection.count \(editableValues.journeyPlannerModesSelection.count)", bundle: .module)
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
            \(localizedString("contact.us.body.os.version")): \(osNameAndVersion)
            """
    }
    
    private var osNameAndVersion: String {
        "\(UIDevice.current.systemName) \(UIDevice.current.systemVersion)"
    }
    
    private func localizedString(_ key: String) -> String {
        NSLocalizedString(key, bundle: .module, comment: "")
    }
}


// MARK: - Previews
private struct Previewer: View {
    @State var editableValues: Settings.EditableValues = .default
    
    var body: some View {
        NavigationStack {
            SettingsView(
                appVersionNumber: "1.1.1",
                appReviewURL: URL(string: "https://www.google.com")!,
                contactUs: .empty,
                editableValues: $editableValues
            )
        }
    }
}

#Preview {
    Previewer()
}
