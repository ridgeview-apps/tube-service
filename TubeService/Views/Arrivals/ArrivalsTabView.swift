import ComposableArchitecture
import LiveArrivalsFeature
import SwiftUI

struct ArrivalsTabView: View {
    
    let store: ArrivalsTabStore

    var body: some View {
        WithViewStore(self.store) { viewStore in
            NavigationView {
                ArrivalsPickerView(
                    store: self.store.arrivalsPickerStore
                )
            }
        }
    }
}

// MARK: - Previews
#if DEBUG
struct ArrivalsTabView_Previews: PreviewProvider {
    static var previews: some View {
        ArrivalsTabView(store: .fake())
    }
}
#endif
