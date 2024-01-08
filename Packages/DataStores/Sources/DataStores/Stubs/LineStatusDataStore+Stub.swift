import Foundation

#if DEBUG

public extension LineStatusDataStore {
    
    static func stub(transportAPI: TransportAPIClientType = StubTransportAPIClient(),
                     now: @escaping () -> Date = { Date() }) -> LineStatusDataStore {
        return .init(transportAPI: transportAPI, now: now)
    }    
}

#endif
