import Foundation
import StoreKit

@MainActor
@Observable
public final class PurchaseStore {

    public enum ProductID: CaseIterable, Hashable, Sendable {
        case tubeServicePlus
        case tubeServicePlusMonthly
    }

    public struct ProductIDs: Sendable {
        public var tubeServicePlus: String
        public var tubeServicePlusMonthly: String

        public init(
            tubeServicePlus: String,
            tubeServicePlusMonthly: String
        ) {
            self.tubeServicePlus = tubeServicePlus
            self.tubeServicePlusMonthly = tubeServicePlusMonthly
        }


        public func storeKitProductID(for productID: ProductID) -> String {
            switch productID {
            case .tubeServicePlus:
                tubeServicePlus
            case .tubeServicePlusMonthly:
                tubeServicePlusMonthly
            }
        }

        public func productID(forStoreKitProductID storeKitProductID: String) -> ProductID? {
            ProductID.allCases.first { self.storeKitProductID(for: $0) == storeKitProductID }
        }
    }

    // MARK: - State

    public internal(set) var entitledProductIDs: Set<ProductID> = []
    public var isPaywallBypassed: Bool = false

    public var hasTubeServicePlus: Bool { isPaywallBypassed || !entitledProductIDs.isEmpty }

    public var storeKitProductIDs: [String] {
        ProductID.allCases.map { productIDs.storeKitProductID(for: $0) }
    }

    private let productIDs: ProductIDs
    private var updatesTask: Task<Void, Never>?

    // MARK: - Init

    public init(productIDs: ProductIDs) {
        self.productIDs = productIDs
    }

    // MARK: - Lifecycle

    public func start() async {
        updatesTask?.cancel()
        await refreshEntitlements()
        updatesTask = Task {
            for await _ in Transaction.updates {
                await self.refreshEntitlements()
            }
        }
    }

    // MARK: - Purchasing

    public func isEntitled(to productID: ProductID) -> Bool {
        entitledProductIDs.contains(productID)
    }

    public func purchase(_ productID: ProductID) async throws {
        let products = try await Product.products(for: [productIDs.storeKitProductID(for: productID)])
        guard let product = products.first else { return }
        let result = try await product.purchase()
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
        var entitled: Set<ProductID> = []
        for await result in Transaction.currentEntitlements {
            if case .verified(let tx) = result,
                let productID = productIDs.productID(forStoreKitProductID: tx.productID),
                tx.revocationDate == nil
            {
                entitled.insert(productID)
            }
        }
        entitledProductIDs = entitled
    }

    private func finish(_ verification: VerificationResult<Transaction>) async {
        guard case .verified(let tx) = verification else { return }
        await tx.finish()
        await refreshEntitlements()
    }
}
