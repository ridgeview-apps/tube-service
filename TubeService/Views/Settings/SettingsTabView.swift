import ComposableArchitecture
import SettingsFeature
import SwiftUI

struct SettingsTabView: View {
    
    let store: SettingsTabStore

    var body: some View {
        WithViewStore(self.store) { viewStore in
            NavigationView {
                SettingsView(store: self.store.settingsStore)
            }
        }
    }
}

// MARK: - Previews
#if DEBUG
struct SettingsTabView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsTabView(store: .fake())
    }
}
#endif
