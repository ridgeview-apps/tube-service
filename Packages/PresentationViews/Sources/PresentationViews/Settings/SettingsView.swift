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
            header: Text(.settingsSectionAboutTitle)
        ) {
            HStack {
                Text(.settingsAppVersionTitle)
                Spacer()
                Text(appVersionNumber)
            }
            .contentShape(Rectangle())
            NavigationLink {
                acknowledgements
            } label: {
                Text(.settingsAcknowledgementsTitle)
            }
        }
    }
    
    @ViewBuilder private var acknowledgements: some View {
        if let acknowledgementsURL = URL(string: "https://tfl.gov.uk/info-for/open-data-users/") {
            HStack {
                Text(.settingsAppPoweredBy)
                Link("TfL Open Data",
                     destination: acknowledgementsURL)
                
                .foregroundColor(.blue)
            }
            .font(.headline)
        }
    }
    
    private var supportSection: some View {
        Section {
            MailButton(to: [contactUs.emailAddress],
                       subject: emailSubject,
                       body: emailBody) {
                Text(.settingsContactUsTitle)
            }
            Link(destination: appReviewURL) {
                Text(.settingsRateThisAppTitle)
            }
        } header: {
            Text(.settingsSectionSupportTitle)
        }
    }

    private var journeyPlannerSection: some View {
        Section {
            NavigationLink {
                JourneyModePickerView(
                    selection: $editableValues.journeyPlannerModesSelection
                )
                .navigationTitle(Text(.settingsJourneyModePickerNavigationTitle))
            } label: {
                HStack {
                    Text(.settingsJourneyPlannerTransportModes)
                    Spacer()
                    modesDetailLabelTitle
                }
            }
        } header: {
            Text(.settingsJourneyPlannerTitle)
        }
    }
    
    private var modesDetailLabelTitle: some View {
        if editableValues.allJourneyPlannerModesSelected {
            Text(.journeyPlannerTravelOptionsModesDetailAll)
        } else {
            Text(.journeyPlannerTravelOptionsModesSelectionCount(editableValues.journeyPlannerModesSelection.count))
        }
    }
    
    
    private var emailSubject: String {
        String(localized: .contactUsSubject(contactUs.appName))
    }
    
    private var emailBody: String {
            """
            \(String(localized: .contactUsBodyDiagnosticInfo))
            
            \(String(localized: .contactUsBodyAppVersion)): \(contactUs.appVersion)
            \(String(localized: .contactUsBodyDeviceInfo)): \(contactUs.deviceInfo)
            \(String(localized: .contactUsBodyLocaleInfo)): \(contactUs.localeInfo)
            \(String(localized: .contactUsBodyOsVersion)): \(osNameAndVersion)
            """
    }
    
    private var osNameAndVersion: String {
        "\(UIDevice.current.systemName) \(UIDevice.current.systemVersion)"
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
