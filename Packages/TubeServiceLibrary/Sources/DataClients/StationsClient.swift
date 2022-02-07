import Combine
import Model
import RidgeviewCore
import Foundation

public struct StationsClient {
    public let load: () -> AnyPublisher<[Station], Never>
}

// MARK: - Real instance
public extension StationsClient {
    
    static func real(jsonBundle: Bundle = .dataClientsModule) -> StationsClient {
        .init(
            load: {
                let decodedStations: [Station] = jsonBundle.decodedJSON(from: "stations.json") ?? []
                return Just(decodedStations).eraseToAnyPublisher()
            }
        )
    }
    
}

public extension Bundle {
    static let dataClientsModule = Bundle.module
}
