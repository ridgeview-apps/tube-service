import PresentationViews
import SwiftUI

struct MapsScreen: View {

    @Environment(AppRouter.self) private var router

    var body: some View {
        @Bindable var router = router
        NavigationStack(path: $router.mapsPath) {
            MapsListView(onSelectMap: { router.push(.mapDetail(mapLink: $0)) })
                .appRouteDestinations()
                .navigationTitle(Text(L10n.mapsNavigationTitle))
                .withSettingsToolbarButton()
        }
    }
}


// MARK: - Previews

#Preview {
    MapsScreen()
        .environment(AppRouter())
}
