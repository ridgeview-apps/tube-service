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

    /// Whether the debug paywall bypass can apply: only for installs from outside the App Store, such as TestFlight.
    /// The same build is installed from both, so this is read at launch rather than set at build time. Off until
    /// confirmed, and off if it can't be, so an App Store install never bypasses the paywall, even with a bypass saved
    /// by a TestFlight install it replaced.
    public private(set) var allowsPaywallBypass = false

    public var hasTubeServicePlus: Bool {
        (allowsPaywallBypass && featureFlags().isPaywallBypassed) || !entitledProductIDs.isEmpty
    }

    public var storeKitProductIDs: [String] {
        productIDs.map(\.value)
    }

    public let productIDs: [ProductID]
    private var updatesTask: Task<Void, Never>?
    private let featureFlags: () -> FeatureFlags
    private let readInstallEnvironment: @Sendable () async -> AppStore.Environment?

    // MARK: - Init

    /// - Parameter readInstallEnvironment: For tests: the environment that signed the app's install, or `nil` if it
    ///   can't be read. Defaults to reading the app's install record.
    public init(
        productIDs: [ProductID],
        featureFlags: @escaping () -> FeatureFlags,
        readInstallEnvironment: (@Sendable () async -> AppStore.Environment?)? = nil
    ) {
        self.productIDs = productIDs
        self.featureFlags = featureFlags
        self.readInstallEnvironment = readInstallEnvironment ?? Self.readAppTransactionEnvironment
    }

    // MARK: - Lifecycle

    public func start() async {
        updatesTask?.cancel()
        await refreshAllowsPaywallBypass()
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

    /// Internal so tests can check the bypass without starting StoreKit's transaction updates.
    func refreshAllowsPaywallBypass() async {
        guard let environment = await readInstallEnvironment() else { return }
        allowsPaywallBypass = environment != .production
    }

    /// The environment from the app's install record, which Apple signs: `.production` for the App Store, `.sandbox`
    /// for TestFlight and development builds, `.xcode` with StoreKit Testing in Xcode. Debug builds only come from
    /// Xcode, so they count as `.xcode` where there's no record to read, such as on the simulator.
    private static func readAppTransactionEnvironment() async -> AppStore.Environment? {
        guard case .verified(let appTransaction) = try? await AppTransaction.shared else {
            #if DEBUG
                return .xcode
            #else
                return nil
            #endif
        }
        return appTransaction.environment
    }

    /// Unverified transactions aren't finished, but entitlements are still refreshed (they only count verified ones).
    private func finish(_ verification: VerificationResult<Transaction>) async {
        if case .verified(let tx) = verification {
            await tx.finish()
        }
        await refreshEntitlements()
    }
}
