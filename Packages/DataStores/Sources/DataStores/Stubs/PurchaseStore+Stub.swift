import Foundation

#if DEBUG

    public extension PurchaseStore {
        static func stub(isPlus: Bool = false) -> PurchaseStore {
            let store = PurchaseStore()
            if isPlus {
                store.entitledProductIDs.insert(.tubeServicePlus)
            }
            return store
        }
    }

#endif
