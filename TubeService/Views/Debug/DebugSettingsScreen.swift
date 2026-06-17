import DataStores
import Models
import SwiftUI

struct DebugSettingsScreen: View {
    @AppStorage(
        UserDefaults.Keys.userPreferences.rawValue,
        store: AppDependencies.current.userDefaults.value
    )
    private var userPreferences: UserPreferences = .default

    @AppStorage(
        UserDefaults.Keys.featureFlags.rawValue,
        store: AppDependencies.current.userDefaults.value
    )
    private var featureFlags: FeatureFlags = .default

    @State private var showDebugConfirmAlert = false

    var body: some View {
        Form {
            Section {
                Toggle("Status History", isOn: $featureFlags.isStatusHistoryEnabled)
            } header: {
                Text("Feature Toggles")
            }
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
