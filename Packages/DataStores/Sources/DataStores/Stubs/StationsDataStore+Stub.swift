import Foundation

#if DEBUG

public extension StationsDataStore {
    
    static func stub(transportAPI: TransportAPIClientType) -> StationsDataStore {
        return .init(transportAPI: transportAPI)
    }
}

#endif
