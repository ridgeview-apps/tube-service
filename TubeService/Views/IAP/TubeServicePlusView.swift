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
    @State private var restoreOutcome: RestorePurchasesOutcome?

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
        .restorePurchasesAlert($restoreOutcome)
        .onChange(of: purchases.hasTubeServicePlus) { _, hasNowSubscribed in
            if hasNowSubscribed {
                onAction(.purchaseSuccess)
            }
        }
        .navigationTitle("Tube Service Plus")
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
                    restoreOutcome = .nothingToRestore
                }
            } catch StoreKitError.userCancelled {
                // Dismissing the Apple Account sign-in isn't an error worth reporting.
            } catch {
                restoreOutcome = .failed(errorMessage: error.localizedDescription)
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
