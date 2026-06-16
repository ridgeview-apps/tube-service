import DataStores
import PresentationViews
import SwiftUI

@MainActor
struct TubeServicePlusScreen: View {

    @Environment(\.dismiss) var dismiss
    @Environment(PurchaseStore.self) var purchases

    var body: some View {
        TubeServicePlusView(onAction: handleAction)
            .onChange(of: purchases.hasTubeServicePlus) { _, isPlus in
                if isPlus { dismiss() }
            }
    }

    private func handleAction(_ action: TubeServicePlusView.Action) {
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
                TubeServicePlusScreen()
            }
        }
    }
#endif
