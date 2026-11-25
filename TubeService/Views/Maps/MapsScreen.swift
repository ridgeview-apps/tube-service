import PresentationViews
import SwiftUI

struct MapsScreen: View {

    @Environment(Navigator.self) private var navigator

    var body: some View {
        MapsListView(onSelectMap: { navigator.push(.mapDetail(mapLink: $0)) })
            .navigationTitle(Text(L10n.mapsNavigationTitle))
            .navigationBarTitleDisplayMode(.inline)
    }
}


// MARK: - Previews

#if DEBUG
    #Preview {
        PreviewEnvironment(withNavigationHost: true) {
            MapsScreen()
        }
    }
#endif
