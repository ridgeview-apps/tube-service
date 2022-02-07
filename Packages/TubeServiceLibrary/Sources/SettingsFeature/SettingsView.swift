import ComposableArchitecture
import DataClients
import SharedViews
import SwiftUI

public typealias SettingsStore = Store<Settings.State, Settings.Action>

public struct SettingsView: View {
    
    private let store: SettingsStore
    @ObservedObject private var viewStore: ViewStore<Settings.State, Settings.Action>
    
    @State private var showDebugSection: Bool = false
    
    public init(store: SettingsStore) {
        self.store = store
        self.viewStore = ViewStore(store)
    }
    
    public var body: some View {
        Form {
            List {
                aboutSection
                supportSection
                if showDebugSection {
                    debugSection
                }
            }
        }
        .navigationTitle(Text("settings.navigation.title", bundle: .module))
        .onAppear {
            viewStore.send(.onAppear)
        }
    }
    
    // MARK: - About
    private var aboutSection: some View {
        Section(
            header: Text("settings.section.about.title", bundle: .module)
        ) {
            HStack {
                Text("settings.app.version.title", bundle: .module)
                Spacer()
                Text(viewStore.appVersionNumber)
            }
            .contentShape(Rectangle())
            .onTapGesture(count: 10) {
                showDebugSection = true
            }
            NavigationLink(destination: acknowledgements) {
                Text("settings.acknowledgements.title", bundle: .module)
            }
        }
    }
    
    // MARK: - Support
    private var supportSection: some View {
        Section(
            header: Text("settings.section.support.title", bundle: .module)
        ) {
            MailButton(to: [viewStore.contactUs.emailAddress],
                       subject: emailSubject,
                       body: emailBody) {
                Text("settings.contact.us.title", bundle: .module)
            }
            if let submitAppReviewUrl = viewStore.submitAppReviewUrl {
                Link(destination: submitAppReviewUrl) {
                    Text("settings.rate.this.app.title", bundle: .module)
                }
            }
        }
    }
    
    private var emailSubject: String {
        String(
            format: localizedString("contact.us.subject %@"),
            viewStore.contactUs.appName
        )
    }
    
    private var emailBody: String {
        """
        \(localizedString("contact.us.body.diagnostic.info"))
                
        \(localizedString("contact.us.body.app.version")): \(viewStore.contactUs.appVersion)
        \(localizedString("contact.us.body.device.info")): \(viewStore.contactUs.deviceInfo)
        \(localizedString("contact.us.body.locale.info")): \(viewStore.contactUs.localeInfo)
        """
    }
    
    private func localizedString(_ key: String) -> String {
        NSLocalizedString(key, bundle: .module, comment: "")
    }
    
    private var acknowledgements: some View {
        HStack {
            Text("settings.app.powered.by")
            Link("TfL Open Data",
                 destination: URL(string: "https://tfl.gov.uk/info-for/open-data-users/")!)
                
                .foregroundColor(.blue)
        }
        .font(.headline)
    }
    
    // MARK: - Debug
    private var debugSection: some View {
        Section(header: Text("Debug")) {
            Button(action: {
                viewStore.send(.testCrashReporting)
            }) {
                Text("Test crash reporting")
            }
        }
    }

}

// MARK: - Previews
#if DEBUG
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SettingsView(store: .fake())
                .embeddedInNavigationView()
            SettingsView(store: .fake())
                .embeddedInNavigationView()
                .previewOption(colorScheme: .dark)
        }
    }
}
#endif
