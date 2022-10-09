import DataClients
import Foundation

#if DEBUG

extension StationsModel {
    
    static func stub(stationsClient: StationsClientType = StubStationsClient()) -> StationsModel {
        return .init(stationsClient: stationsClient)
    }
}

#endif
