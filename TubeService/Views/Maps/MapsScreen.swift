import PresentationViews
import SwiftUI

struct MapsScreen: View {
    
    @Environment(\.showSheet) var showSheet
    
    var body: some View {
        NavigationStack {
            MapsListView(onAction: handleMapsListViewAction)
                .navigationTitle(Text(.mapsNavigationTitle))
                .withSettingsToolbarButton()
        }
    }
    
    private func handleMapsListViewAction(_ action: MapsListView.Action) {
        switch action {
        case .tappedLink(let mapLink):
            showSheet(.safari(mapLink.url))
        }        
    }
}


// MARK: - Previews

#Preview {
    MapsScreen()
}
