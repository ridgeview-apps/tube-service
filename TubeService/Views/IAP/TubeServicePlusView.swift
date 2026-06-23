import DataStores
import PresentationViews
import StoreKit
import SwiftUI

@MainActor
struct TubeServicePlusView: View {

    enum Action {
        case purchaseSuccess
    }

    let context: PaywallContext
    let onAction: (Action) -> Void
    let autoDismissesOnPurchase: Bool

    @Environment(\.dismiss) var dismiss
    @Environment(PurchaseStore.self) var purchases

    init(
        context: PaywallContext = .statusHistory,
        autoDismissesOnPurchase: Bool = false,
        onAction: @escaping (Action) -> Void = { _ in },
    ) {
        self.context = context
        self.autoDismissesOnPurchase = autoDismissesOnPurchase
        self.onAction = onAction
    }

    var body: some View {
        SubscriptionStoreView(
            productIDs: [PurchaseStore.ProductID.tubeServicePlus.rawValue]
        ) {
            TubeServicePlusMarketingContent(context: context)
        }
        .onChange(of: purchases.hasTubeServicePlus) { _, hasNowSubscribed in
            if hasNowSubscribed {
                if autoDismissesOnPurchase {
                    dismiss()
                }
                onAction(.purchaseSuccess)
            }
        }
        .navigationTitle("Tube Service Plus")
        .navigationBarTitleDisplayMode(.inline)
    }
}


// MARK: - Previews

#if DEBUG
    #Preview {
        PreviewEnvironment {
            NavigationStack {
                TubeServicePlusView()
            }
        }
    }
#endif
