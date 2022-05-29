import Combine
import Foundation
import Model
import ModelFakes
import Shared

#if DEBUG

// MARK: - KeyValueStore

public extension KeyValueStore {
    
    private static var inMemoryStorage =  [String: Any]()
    static let fake = KeyValueStore(
        get: { key -> Any? in
            inMemoryStorage[key]
        },
        set: { pair in
            inMemoryStorage[pair.key] = pair.value
        }
    )
}


// MARK: - StationsClient

public extension StationsClient {
    
    static var fake: StationsClient {
        .init(
            load: {
                let decodedStations: [Station] = try! JSONDecoder().decode([Station].self, from: fakeStations)
                return Just(decodedStations).eraseToAnyPublisher()
            }
        )
    }
}


// MARK: - TransportAPIClient
public extension TransportAPIClient {
    static let fake = TransportAPIClient(
        lineStatuses: { () -> AnyPublisher<[LineStatus], APIFailure> in
            Result.successPublisher(LineStatus.fakes())
        },
        arrivals: { request -> AnyPublisher<[Arrival], APIFailure> in
            Result.successPublisher(Arrival.fakes(ofTypes: .multiLine))
        },
        arrivalDepartures: { request -> AnyPublisher<[ArrivalDeparture], APIFailure> in
            Result.successPublisher(ArrivalDeparture.fakeElizabethLineData())
        }
    )
}


// MARK: - UserPreferencesClient
public extension UserPreferencesClient {
    static let fake = UserPreferencesClient(keyValueStore: .fake)
}

#endif
