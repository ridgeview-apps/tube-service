import Models
import StoreKit
import Testing

@testable import DataStores

@MainActor
struct PurchaseStoreTests {

    // MARK: - Paywall bypass

    @Test
    func bypassDoesNotApplyBeforeTheInstallEnvironmentIsRead() {
        // Given
        let store = makeStore(isPaywallBypassed: true, installEnvironment: .sandbox)

        // Then
        #expect(store.allowsPaywallBypass == false)
        #expect(store.hasTubeServicePlus == false)
    }

    @Test(arguments: [AppStore.Environment.sandbox, .xcode])
    func bypassAppliesOutsideTheAppStore(installEnvironment: AppStore.Environment) async {
        // Given
        let store = makeStore(isPaywallBypassed: true, installEnvironment: installEnvironment)

        // When
        await store.refreshAllowsPaywallBypass()

        // Then
        #expect(store.allowsPaywallBypass)
        #expect(store.hasTubeServicePlus)
    }

    @Test
    func bypassIsIgnoredForAppStoreInstalls() async {
        // Given
        let store = makeStore(isPaywallBypassed: true, installEnvironment: .production)

        // When
        await store.refreshAllowsPaywallBypass()

        // Then
        #expect(store.allowsPaywallBypass == false)
        #expect(store.hasTubeServicePlus == false)
    }

    @Test
    func bypassIsIgnoredWhenTheInstallEnvironmentCantBeRead() async {
        // Given
        let store = makeStore(isPaywallBypassed: true, installEnvironment: nil)

        // When
        await store.refreshAllowsPaywallBypass()

        // Then
        #expect(store.allowsPaywallBypass == false)
        #expect(store.hasTubeServicePlus == false)
    }

    @Test
    func bypassFlagOffDoesNotGrantPlusOutsideTheAppStore() async {
        // Given
        let store = makeStore(isPaywallBypassed: false, installEnvironment: .sandbox)

        // When
        await store.refreshAllowsPaywallBypass()

        // Then
        #expect(store.hasTubeServicePlus == false)
    }

    @Test
    func entitlementGrantsPlusForAppStoreInstalls() async {
        // Given
        let store = makeStore(isPaywallBypassed: false, installEnvironment: .production)
        await store.refreshAllowsPaywallBypass()

        // When
        store.entitledProductIDs = Set(store.productIDs)

        // Then
        #expect(store.hasTubeServicePlus)
    }

    // MARK: - Helpers

    private func makeStore(isPaywallBypassed: Bool, installEnvironment: AppStore.Environment?) -> PurchaseStore {
        PurchaseStore(
            productIDs: [PurchaseStore.ProductID("test.tube-service.plus")],
            featureFlags: { FeatureFlags(isPaywallBypassed: isPaywallBypassed) },
            readInstallEnvironment: { installEnvironment }
        )
    }
}
