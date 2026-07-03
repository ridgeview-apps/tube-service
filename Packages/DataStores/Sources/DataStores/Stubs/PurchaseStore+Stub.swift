import Foundation

#if DEBUG

    public extension PurchaseStore {
        static func stub(isPlus: Bool = false) -> PurchaseStore {
            let store = PurchaseStore(
                productIDs: [
                    PurchaseStore.ProductID("stub.tube-service.plus"),
                    PurchaseStore.ProductID("stub.tube-service.plus.monthly")
                ]
            )
            if isPlus {
                store.entitledProductIDs.formUnion(store.productIDs)
            }
            return store
        }
    }

#endif
