import Foundation
import Models
import StoreKit

@MainActor
@Observable
public final class PurchaseStore {

    public struct ProductID: Hashable, Sendable {
        public let value: String

        public init(_ value: String) {
            self.value = value
        }
    }

    // MARK: - State

    public internal(set) var entitledProductIDs: Set<ProductID> = []

    public var hasTubeServicePlus: Bool {
        featureFlags().isPaywallBypassed || !entitledProductIDs.isEmpty
    }

    public var storeKitProductIDs: [String] {
        productIDs.map(\.value)
    }

    public let productIDs: [ProductID]
    private var updatesTask: Task<Void, Never>?
    private let featureFlags: () -> FeatureFlags

    // MARK: - Init

    public init(
        productIDs: [ProductID],
        featureFlags: @escaping () -> FeatureFlags
    ) {
        self.productIDs = productIDs
        self.featureFlags = featureFlags
    }

    // MARK: - Lifecycle

    public func start() async {
        updatesTask?.cancel()
        await refreshEntitlements()
        // Only reports transactions made outside the app or on other devices, such as renewals. Purchases made in
        // the app's store views arrive through `handlePurchaseResult(_:)` instead.
        updatesTask = Task {
            for await update in Transaction.updates {
                await self.finish(update)
            }
        }
    }

    // MARK: - Purchasing

    public func isEntitled(to productID: ProductID) -> Bool {
        entitledProductIDs.contains(productID)
    }

    public func purchase(_ productID: ProductID) async throws {
        let products = try await Product.products(for: [productID.value])
        guard let product = products.first else { return }
        let result = try await product.purchase()
        await handlePurchaseResult(result)
    }

    /// Completes a purchase made in a StoreKit view, such as the Tube Service Plus store.
    public func handlePurchaseResult(_ result: Product.PurchaseResult) async {
        if case .success(let verification) = result {
            await finish(verification)
        }
    }

    public func restorePurchases() async throws {
        try await AppStore.sync()
        await refreshEntitlements()
    }

    // MARK: - Private

    public func refreshEntitlements() async {
        let productIDs = Set(productIDs)
        var entitled: Set<ProductID> = []
        for await result in Transaction.currentEntitlements {
            if case .verified(let tx) = result,
                productIDs.contains(ProductID(tx.productID)),
                tx.revocationDate == nil
            {
                entitled.insert(ProductID(tx.productID))
            }
        }
        entitledProductIDs = entitled
    }

    /// Unverified transactions aren't finished, but entitlements are still refreshed (they only count verified ones).
    private func finish(_ verification: VerificationResult<Transaction>) async {
        if case .verified(let tx) = verification {
            await tx.finish()
        }
        await refreshEntitlements()
    }
}
