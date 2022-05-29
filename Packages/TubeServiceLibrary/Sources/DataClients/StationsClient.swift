import Combine
import Model
import RidgeviewCore
import Foundation

public struct StationsClient {
    public let load: () -> AnyPublisher<[Station], Never>
}

// MARK: - Real instance
public extension StationsClient {
    
    static func real() -> StationsClient {
        .init(
            load: {
                let decodedStations: [Station] = Bundle.module.decodedJSON(from: "stations.json") ?? []
                return Just(decodedStations).eraseToAnyPublisher()
            }
        )
    }    
}
