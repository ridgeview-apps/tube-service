import Models
import SwiftUI

enum BusStopDestination: Hashable {
    case arrivals(BusStop)
    case info(BusStop)

    @MainActor
    @ViewBuilder
    var screen: some View {
        switch self {
        case .arrivals(let stop):
            BusStopArrivalsScreen(stop: stop)
        case .info(let stop):
            BusStopInfoScreen(stop: stop)
        }
    }
}
