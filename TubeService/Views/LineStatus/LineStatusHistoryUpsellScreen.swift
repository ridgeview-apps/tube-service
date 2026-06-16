import DataStores
import Models
import PresentationViews
import SwiftUI

@MainActor
struct LineStatusHistoryUpsellScreen: View {

    @Environment(PurchaseStore.self) var purchases

    let lineID: TrainLineID

    var body: some View {
        LineStatusLockedView(lineID: lineID, onAction: handleAction)
    }

    private func handleAction(_ action: LineStatusLockedView.Action) {
        switch action {
        case .unlockTapped:
            Task { try? await purchases.purchase(.tubeServicePlus) }
        case .restoreTapped:
            Task { try? await purchases.restorePurchases() }
        }
    }
}


// MARK: - Previews

#if DEBUG
    #Preview {
        PreviewEnvironment {
            NavigationStack {
                LineStatusHistoryUpsellScreen(lineID: .victoria)
            }
        }
    }
#endif
