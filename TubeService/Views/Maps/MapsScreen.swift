import PresentationViews
import SwiftUI

struct MapsScreen: View {
    
    var body: some View {
        NavigationStack {
            MapsListView()
                .navigationTitle(Text(.mapsNavigationTitle))
                .withSettingsToolbarButton()
        }
    }
}


// MARK: - Previews

#Preview {
    MapsScreen()
}
