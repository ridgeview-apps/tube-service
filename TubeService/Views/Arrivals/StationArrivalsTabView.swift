import ComposableArchitecture
import SwiftUI

struct ArrivalsTabView: View {
    
    let store: StationsArrivalsTabStore

    var body: some View {
        WithViewStore(self.store) { viewStore in
            NavigationView {
                StationsArrivalsPickerContainerView(
                    store: self.store.stationArrivalsPickerStore
                )
                .phoneOnlyStackNavigationView()
            }
        }
    }
}

struct StationArrivalsTabView_Previews: PreviewProvider {
    static var previews: some View {
        ArrivalsTabView(store: .fake())
    }
}
