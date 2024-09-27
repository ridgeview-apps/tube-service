import Models
import SwiftUI

public struct SettingsView: View {
    
    public typealias ContactUs = Settings.ContactUs
    public typealias EditableValues = Settings.EditableValues
    public typealias DebugAction = Settings.DebugAction
    
    public let appVersionNumber: String
    public let appReviewURL: URL
    public let contactUs: ContactUs
    public let systemStatus: SystemStatus?
    public let onDebugAction: (Settings.DebugAction) -> Void
    
    @Binding var editableValues: EditableValues
    
    @State private var showDebugSection = false
    @State private var showDebugConfirmAlert = false
    
    public init(
        appVersionNumber: String,
        appReviewURL: URL,
        contactUs: ContactUs,
        editableValues: Binding<EditableValues>,
        systemStatus: SystemStatus?,
        onDebugAction: @escaping (Settings.DebugAction) -> Void
    ) {
        self.appVersionNumber = appVersionNumber
        self.appReviewURL = appReviewURL
        self.contactUs = contactUs
        self._editableValues = editableValues
        self.systemStatus = systemStatus
        self.onDebugAction = onDebugAction
    }
        
    public var body: some View {
        Form {
            journeyPlannerSection
            supportSection
            aboutSection
            debugSection
        }
        .onTapGesture(count: 10) {
            showDebugSection = true
        }
    }
        
    
    // MARK: - Layout views
    
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
            NavigationLink {
                SystemStatusDetailView(systemStatus: systemStatus)
            } label: {
                Text(.settingsSystemStatusTitle)
            }
        } header: {
            Text(.settingsSectionSupportTitle)
        }
    }
    
    private var modesDetailLabelTitle: some View {
        if editableValues.allJourneyPlannerModesSelected {
            Text(.journeyPlannerTravelOptionsModesDetailAll)
        } else {
            Text(.journeyPlannerTravelOptionsModesSelectionCount(editableValues.journeyPlannerModesSelection.count))
        }
    }
    
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
    
    @ViewBuilder
    private var debugSection: some View {
        if showDebugSection {
            Section {
                Button("Reset user defaults?") {
                    showDebugConfirmAlert = true
                }
            }
            .alert("Are you sure?", isPresented: $showDebugConfirmAlert) {
                Button("No", role: .cancel) {}
                Button("Yes", role: .destructive) {
                    print("Yes")
                    onDebugAction(.resetUserDefaults)
                }
            }
        }
    }
}


// MARK: - Previews

import ModelStubs

private struct Previewer: View {
    @State var editableValues: Settings.EditableValues = .default
    
    var body: some View {
        NavigationStack {
            SettingsView(
                appVersionNumber: "1.1.1",
                appReviewURL: URL(string: "https://www.google.com")!,
                contactUs: .empty,
                editableValues: $editableValues,
                systemStatus: nil,
                onDebugAction: { _ in }
            )
        }
    }
}

#Preview {
    Previewer()
}
