import Models
import SwiftUI

enum StationDestination: Hashable {
    case detail(Station)
    case info(Station)

    @MainActor
    @ViewBuilder
    var screen: some View {
        switch self {
        case .detail(let station):
            StationScreen(station: station)
        case .info(let station):
            StationInfoScreen(station: station)
        }
    }
}
