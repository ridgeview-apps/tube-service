import ComposableArchitecture
import SwiftUI

struct LineStatusTabView: View {
    
    let store: LineStatusTabStore

    var body: some View {
        WithViewStore(self.store) { viewStore in
            NavigationView {
                LineStatusListView(store: self.store.lineStatusListStore)
                    .phoneOnlyStackNavigationViewForIOS13
            }
        }
    }
}

// MARK: - Previews
#if DEBUG
struct LineStatusTabView_Previews: PreviewProvider {
    static var previews: some View {
        LineStatusTabView(store: .preview())
    }
}
#endif
