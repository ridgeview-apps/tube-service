import Models
import SwiftUI

enum StationDestination: Hashable {
    case arrivals(Station)
    case info(Station)

    @MainActor
    @ViewBuilder
    var screen: some View {
        switch self {
        case .arrivals(let station):
            StationArrivalsScreen(station: station)
        case .info(let station):
            StationInfoScreen(station: station)
        }
    }
}
