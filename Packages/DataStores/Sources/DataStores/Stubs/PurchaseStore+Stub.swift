import Foundation

#if DEBUG

    public extension PurchaseStore {
        static func stub(isPlus: Bool = false) -> PurchaseStore {
            let store = PurchaseStore(
                productIDs: .init(
                    tubeServicePlus: "stub.tube-service.plus",
                    tubeServicePlusMonthly: "stub.tube-service.plus.monthly"
                )
            )
            if isPlus {
                store.entitledProductIDs.insert(.tubeServicePlus)
            }
            return store
        }
    }

#endif
