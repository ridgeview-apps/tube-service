import Foundation

#if DEBUG

public extension LineStatusDataStore {
    
    static func stub(transportAPI: TransportAPIClientType,
                     now: @escaping () -> Date = { Date() }) -> LineStatusDataStore {
        return .init(transportAPI: transportAPI, now: now)
    }    
}

#endif
