import SwiftUI
import Models

struct DebugSettingsScreen: View {
    @AppStorage(
        UserDefaults.Keys.userPreferences.rawValue,
        store: AppDependencies.current.userDefaults.value
    )
    private var userPreferences: UserPreferences = .default

    @State private var showDebugConfirmAlert = false

    var body: some View {
        Form {
            Section {
                Button("Reset user defaults?") {
                    showDebugConfirmAlert = true
                }
            } header: {
                Text("User defaults")
            }
            .alert("Are you sure?", isPresented: $showDebugConfirmAlert) {
                Button("No", role: .cancel) {}
                Button("Yes", role: .destructive) {
                    userPreferences = .default
                }
            }
        }
    }
}
