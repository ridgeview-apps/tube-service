import PresentationViews
import SwiftUI

/// The only way to build a navigation stack: it shows `root` in a stack driven by `navigator`, which it makes
/// available to every screen inside.
struct NavigationHost<Root: View>: View {

    @Bindable var navigator: Navigator
    @ViewBuilder let root: () -> Root

    var body: some View {
        NavigationStack(path: $navigator.path) {
            root()
                .navigationDestination(for: Destination.self, destination: destinationView)
        }
        .environment(navigator)
    }

    @ViewBuilder
    private func destinationView(_ destination: Destination) -> some View {
        switch destination {
        case .journeyResults:
            JourneyResultsScreen()
        case .lineStatusDetail(let lineID, let request):
            LineStatusDetailScreen(lineID: lineID, request: request)
        case .lineStatusHistory(let lineID):
            LineStatusHistoryScreen(lineID: lineID)
        case .station(let station):
            StationScreen(station: station)
        case .mapDetail(let mapLink):
            MapDetailView(mapLink: mapLink)
        }
    }
}
