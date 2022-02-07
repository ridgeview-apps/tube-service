import Foundation
import Model
import Combine

public struct UserPreferencesClient {
    public var load: () -> AnyPublisher<UserPreferences, Never>
    public var update: (UserPreferences) -> AnyPublisher<UserPreferences, Never>
    
    func addFavourite(station: Station.ArrivalsGroup.ID) -> AnyPublisher<UserPreferences, Never> {
        load()
            .flatMap { loadedValues -> AnyPublisher<UserPreferences, Never> in
                var newValues = loadedValues
                newValues.favourites.insert(station)
                return update(newValues)
            }
            .eraseToAnyPublisher()
    }
    
    func removeFavourite(station: Station.ArrivalsGroup.ID) -> AnyPublisher<UserPreferences, Never> {
        load()
            .flatMap { loadedValues -> AnyPublisher<UserPreferences, Never> in
                var newValues = loadedValues
                newValues.favourites.remove(station)
                return update(newValues)
            }
            .eraseToAnyPublisher()
    }
}

extension UserPreferencesClient {
    
    private enum UserDefaultsKey: String {
        case userPreferences
    }

    init(keyValueStore: KeyValueStore) {
        let jsonDecoder = JSONDecoder()
        let jsonEncoder = JSONEncoder()
        
        func loadFromUserDefaults() -> AnyPublisher<UserPreferences, Never> {
            guard let data = keyValueStore.get(UserDefaultsKey.userPreferences.rawValue) as? Data,
                  let userPreferences = try? jsonDecoder.decode(UserPreferences.self, from: data) else {
                      return Just(UserPreferences.empty).eraseToAnyPublisher()
                  }
        
            return Just(userPreferences).eraseToAnyPublisher()
        }
        
        self.init(
            load: loadFromUserDefaults,
            update: { userPreferences in
                guard let json = try? jsonEncoder.encode(userPreferences) else {
                    assertionFailure()
                    return Just(userPreferences).eraseToAnyPublisher()
                }
                keyValueStore.set(
                    .init(key: UserDefaultsKey.userPreferences.rawValue,
                          value: json)
                )
                return loadFromUserDefaults()
            }
        )
    }
}

// MARK: - Real instance
public extension UserPreferencesClient {
    static let real = UserPreferencesClient(keyValueStore: .real)
}
