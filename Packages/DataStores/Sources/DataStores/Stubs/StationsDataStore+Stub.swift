import Foundation

#if DEBUG

public extension StationsDataStore {
    
    static func stub(transportAPI: TransportAPIClientType = StubTransportAPIClient()) -> StationsDataStore {
        return .init(transportAPI: transportAPI)
    }
}

#endif
