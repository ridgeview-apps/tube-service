import DataClients
import Foundation

#if DEBUG

extension StationsModel {
    
    static func stub(stationsClient: StationsClientType = StubStationsClient(),
                     transportAPI: TransportAPIClientType = StubTransportAPIClient()) -> StationsModel {
        return .init(stationsClient: stationsClient,
                     transportAPI: transportAPI)
    }
}

#endif
