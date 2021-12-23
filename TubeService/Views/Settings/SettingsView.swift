import SwiftUI
import ComposableArchitecture
import DataClients

struct SettingsView: View {
    
    let store: SettingsStore
    
    @State private var showDebugSection: Bool = false
    
    var body: some View {
        WithViewStore(store) { viewStore in
            Form {
                List {
                    aboutSection(viewStore: viewStore)
                    supportSection(viewStore: viewStore)
//                    twitterLinksSection(viewStore: viewStore)
                    if showDebugSection {
                        debugSection(viewStore: viewStore)
                    }
                }
            }
            .navigationTitle("settings.navigation.title")
            .onAppear {
                viewStore.send(.onAppear)
            }
        }
    }
    
    private func selectedBrowserType(viewStore: ViewStore<Settings.State, Settings.Action>) -> Binding<UserPreferences.BrowserType> {
        viewStore.binding(
            get: \.selectedBrowserType,
            send: Settings.Action.select(browserType:)
        )
    }
    
    // MARK: - About
    private func aboutSection(viewStore: ViewStore<Settings.State, Settings.Action>) -> some View {
        Section(
            header: Text("settings.section.about.title")
        ) {
            HStack {
                Text("settings.app.version.title")
                Spacer()
                Text(viewStore.viewState.appVersionNumber)
            }
            .contentShape(Rectangle())
            .onTapGesture(count: 10) {
                showDebugSection = true
            }
            NavigationLink(destination: acknowledgements) {
                Text("settings.acknowledgements.title")
            }
        }
    }
    
    // MARK: - Support
    private func supportSection(viewStore: ViewStore<Settings.State, Settings.Action>) -> some View {
        Section(
            header: Text("settings.section.support.title")
        ) {
            MailButton("settings.contact.us.title",
                       to: [viewStore.contactUs.email],
                       subject: viewStore.contactUs.subject,
                       body: viewStore.contactUs.body)
            if let submitAppReviewUrl = viewStore.submitAppReviewUrl {
                Link("settings.rate.this.app.title",
                     destination: submitAppReviewUrl)
            }
        }
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
    
    // MARK: - Twitter
    private func twitterLinksSection(viewStore: ViewStore<Settings.State, Settings.Action>) -> some View {
        Section(header: Text("Twitter"),
                footer: Text("settings.links.footnote")) {
            Picker("settings.links.open.in.title", selection: selectedBrowserType(viewStore: viewStore)) {
                ForEach(UserPreferences.BrowserType.allCases) { browserType in
                    Text(browserType.localizedKey).tag(browserType)
                }
            }
        }
    }
    
    // MARK: - Debug
    private func debugSection(viewStore: ViewStore<Settings.State, Settings.Action>) -> some View {
        Section(header: Text("Debug")) {
            Button(action: {
                viewStore.send(.debug(.testCrashReporting))
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
            SettingsView(store: .preview())
                .embeddedInNavigationView()
            SettingsView(store: .preview())
                .embeddedInNavigationView()
                .previewOption(colorScheme: .dark)
        }
    }
}
#endif

extension UserPreferences.BrowserType {
    var localizedKey: LocalizedStringKey {
        switch self {
        case .external:
            return "settings.links.external"
        case .inApp:
            return "settings.links.in-app-browser"
        }
    }
}
