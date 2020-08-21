import ComposableArchitecture
import SwiftUI

struct SettingsTabView: View {
    
    let store: SettingsTabStore

    var body: some View {
        WithViewStore(self.store) { viewStore in
            NavigationView {
                SettingsView(store: self.store.settingsStore)
                    .phoneOnlyStackNavigationViewForIOS13
            }
        }
    }
}

// MARK: - Previews
#if DEBUG
struct SettingsTabView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsTabView(store: .preview())
    }
}
#endif
