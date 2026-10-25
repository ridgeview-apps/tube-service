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

    @State private var isRestoring = false
    @State private var alert: TubeServicePlusAlert?

    init(
        context: PaywallContext = .statusHistory,
        onAction: @escaping (Action) -> Void = { _ in },
    ) {
        self.context = context
        self.onAction = onAction
    }

    var body: some View {
        SubscriptionStoreView(productIDs: purchases.storeKitProductIDs) {
            TubeServicePlusMarketingContent(context: context)
        }
        .storeButton(.hidden, for: .cancellation)
        // The control style provides its own, less prominent, restore link.
        .storeButton(.hidden, for: .restorePurchases)
        .subscriptionStoreControlStyle(
            TubeServicePlusControlStyle(isRestoring: isRestoring, onRestore: restorePurchases)
        )
        .tubeServicePlusAlert($alert)
        // Purchases made here don't appear on `Transaction.updates`, so hand them to the store to finish and to
        // unlock Plus; `hasTubeServicePlus` changing then completes the flow.
        .onInAppPurchaseCompletion { _, result in
            switch result {
            case .success(let purchaseResult):
                await purchases.handlePurchaseResult(purchaseResult)
            case .failure(StoreKitError.userCancelled):
                break
            case .failure(let error):
                // With a completion handler in place, the store view no longer reports failures itself.
                alert = .purchaseFailed(errorMessage: error.localizedDescription)
            }
        }
        .onChange(of: purchases.hasTubeServicePlus) { _, hasNowSubscribed in
            if hasNowSubscribed {
                onAction(.purchaseSuccess)
            }
        }
        .navigationTitle(Text(L10n.tubeServicePlusNavigationTitle))
        .navigationBarTitleDisplayMode(.inline)
    }

    /// A restore that finds a subscription needs no feedback here: `hasTubeServicePlus` changing completes the flow.
    private func restorePurchases() {
        isRestoring = true
        Task {
            defer { isRestoring = false }
            do {
                try await purchases.restorePurchases()
                if !purchases.hasTubeServicePlus {
                    alert = .nothingToRestore
                }
            } catch StoreKitError.userCancelled {
                // Dismissing the Apple Account sign-in isn't an error worth reporting.
            } catch {
                alert = .restoreFailed(errorMessage: error.localizedDescription)
            }
        }
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
