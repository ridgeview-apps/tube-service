import DataStores
import Models
import Observation
import PresentationViews

// MARK: - Destination

enum Destination: Hashable {
    case journeyResults
    case lineStatusDetail(lineID: TrainLineID, request: LineStatusDataStore.LineStatusRequest)
    case lineStatusHistory(lineID: TrainLineID)
    case station(Station)
    case mapDetail(mapLink: MapLink)
}

// MARK: - Navigator

/// The navigation stack of one `NavigationHost`. Screens push onto the nearest one through the environment, so they
/// work the same whichever host shows them.
@Observable
@MainActor
final class Navigator {

    var path: [Destination] = []

    func push(_ destination: Destination) {
        path.append(destination)
    }

    func popToRoot() {
        path = []
    }
}
