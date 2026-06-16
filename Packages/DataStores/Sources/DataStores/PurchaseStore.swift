import Foundation
import StoreKit

@MainActor
@Observable
public final class PurchaseStore {

    public enum ProductID: String, CaseIterable {
        case tubeServicePlus = "com.ridgeviewapps.tubeservice.plus"
    }

    // MARK: - State

    public internal(set) var entitledProductIDs: Set<ProductID> = []

    public var hasTubeServicePlus: Bool { isEntitled(to: .tubeServicePlus) }

    private let productIDs: Set<ProductID>
    private var updatesTask: Task<Void, Never>?

    // MARK: - Init

    public init(productIDs: Set<ProductID> = Set(ProductID.allCases)) {
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
        let products = try await Product.products(for: [productID.rawValue])
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
                let productID = ProductID(rawValue: tx.productID),
                productIDs.contains(productID),
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
