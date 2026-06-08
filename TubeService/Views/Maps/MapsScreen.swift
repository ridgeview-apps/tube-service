import PresentationViews
import SwiftUI

struct MapsScreen: View {

    var body: some View {
        NavigationStack {
            MapsListView()
                .navigationDestination(for: MapLink.self) { mapLink in
                    MapDetailView(mapLink: mapLink)
                }
                .navigationTitle(Text(L10n.mapsNavigationTitle))
                .withSettingsToolbarButton()
        }
    }
}


// MARK: - Previews

#Preview {
    MapsScreen()
}
