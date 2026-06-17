import DataStores
import PresentationViews
import StoreKit
import SwiftUI

@MainActor
struct TubeServicePlusScreen: View {

    @Environment(\.dismiss) var dismiss
    @Environment(PurchaseStore.self) var purchases

    var body: some View {
        SubscriptionStoreView(productIDs: ["com.ridgeviewapps.tubeservice.plus"]) {
            TubeServicePlusMarketingContent()
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
