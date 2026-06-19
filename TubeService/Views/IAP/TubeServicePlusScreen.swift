import DataStores
import PresentationViews
import StoreKit
import SwiftUI

@MainActor
struct TubeServicePlusScreen: View {

    let context: PaywallContext

    @Environment(\.dismiss) var dismiss
    @Environment(PurchaseStore.self) var purchases

    init(context: PaywallContext = .statusHistory) {
        self.context = context
    }

    var body: some View {
        SubscriptionStoreView(productIDs: ["com.ridgeviewapps.tubeservice.plus"]) {
            TubeServicePlusMarketingContent(context: context)
        }
        .onChange(of: purchases.hasTubeServicePlus) { _, isPlus in
            if isPlus { dismiss() }
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
                TubeServicePlusScreen()
            }
        }
    }
#endif
