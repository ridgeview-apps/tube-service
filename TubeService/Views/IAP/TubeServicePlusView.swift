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

    @Environment(PurchaseStore.self) var purchases

    init(
        context: PaywallContext = .statusHistory,
        onAction: @escaping (Action) -> Void = { _ in },
    ) {
        self.context = context
        self.onAction = onAction
    }

    var body: some View {
        SubscriptionStoreView(
            productIDs: [PurchaseStore.ProductID.tubeServicePlus.rawValue]
        ) {
            TubeServicePlusMarketingContent(context: context)
        }
        .storeButton(.hidden, for: .cancellation)
        .onChange(of: purchases.hasTubeServicePlus) { _, hasNowSubscribed in
            if hasNowSubscribed {
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
