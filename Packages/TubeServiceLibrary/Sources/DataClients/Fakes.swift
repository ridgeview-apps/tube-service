import Combine
import Foundation
import Model
import ModelFakes
import Shared

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
        StationsClient.real(
            jsonBundle: .findModuleBundle(named: "TubeService_DataClients")
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
        }
    )
}


// MARK: - UserPreferencesClient
public extension UserPreferencesClient {
    static let fake = UserPreferencesClient(keyValueStore: .fake)
}
