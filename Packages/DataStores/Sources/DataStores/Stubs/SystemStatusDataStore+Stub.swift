import Foundation

#if DEBUG

public extension SystemStatusDataStore {
    
    static func stub(systemStatusAPI: SystemStatusAPIClientType,
                     now: @escaping () -> Date = { Date() }) -> SystemStatusDataStore {
        return .init(systemStatusAPI: systemStatusAPI, now: now)
    }
}

#endif
