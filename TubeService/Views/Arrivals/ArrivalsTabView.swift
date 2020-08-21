import ComposableArchitecture
import SwiftUI

struct ArrivalsTabView: View {
    
    let store: ArrivalsTabStore

    var body: some View {
        WithViewStore(self.store) { viewStore in
            NavigationView {
                ArrivalsPickerView(
                    store: self.store.arrivalsPickerStore
                )
                .phoneOnlyStackNavigationViewForIOS13
            }
        }
    }
}

// MARK: - Previews
#if DEBUG
struct ArrivalsTabView_Previews: PreviewProvider {
    static var previews: some View {
        ArrivalsTabView(store: .preview())
    }
}
#endif
