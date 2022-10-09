import PresentationViews
import SwiftUI

struct MapsScreen: View {
    
    var body: some View {
        NavigationStack {
            MapsListView()
                .navigationTitle("maps.navigation.title")
                .withSettingsToolbarButton()
        }
    }
}


// MARK: - Previews

#Preview {
    MapsScreen()
}
