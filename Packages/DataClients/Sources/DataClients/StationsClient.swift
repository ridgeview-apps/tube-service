import Combine
import Model
import RidgeviewCore
import Foundation

public struct StationsClient {
    public let load: () -> AnyPublisher<[Station], Never>
}

// MARK: - Real instance
public extension StationsClient {
    
    static let real = StationsClient(
        load: {
            let decodedStations: [Station] = Bundle.module.decodedJSON(from: "stations.json") ?? []
            return Just(decodedStations).eraseToAnyPublisher()
        }
    )
    
}

// MARK: - Fake instance
#if DEBUG
public extension StationsClient {
    
    static let fake = StationsClient.real
}
#endif
