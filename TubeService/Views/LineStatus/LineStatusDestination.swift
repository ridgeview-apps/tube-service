import DataStores
import Models
import PresentationViews
import SwiftUI

enum LineStatusDestination: Hashable {
    case detail(lineID: TrainLineID, request: LineStatusDataStore.LineStatusRequest)
    case history(lineID: TrainLineID)

    var paywallContext: PaywallContext? {
        switch self {
        case .history: .statusHistory
        case .detail: nil
        }
    }

    @MainActor
    @ViewBuilder
    var screen: some View {
        switch self {
        case .detail(let lineID, let request):
            LineStatusDetailScreen(lineID: lineID, request: request)
        case .history(let lineID):
            LineStatusHistoryScreen(lineID: lineID)
        }
    }
}
