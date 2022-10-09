import DataClients
import Foundation

#if DEBUG

extension LineStatusModel {
    
    static func stub(transportAPI: TransportAPIClientType = StubTransportAPIClient(),
                     now: @escaping () -> Date = { Date() }) -> LineStatusModel {
        return .init(transportAPI: transportAPI, now: now)
    }
}

#endif
