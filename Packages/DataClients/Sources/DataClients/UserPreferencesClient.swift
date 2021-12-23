import Foundation
import Model
import Combine

public struct UserPreferences: Equatable, Codable {
    
    public enum BrowserType: Int, Identifiable, CaseIterable, Codable {
        public var id: Int { rawValue }
        case external, inApp
    }
    
    public enum ArrivalsPickerFilterOption: Int, Identifiable, CaseIterable, Codable {
        public var id: Int { rawValue }
        case all, favourites
    }
    
    public var favourites: Set<Station.ArrivalsGroup.ID>
    public var lastUsedFilterOption: ArrivalsPickerFilterOption
    public var preferredBrowserType: BrowserType
    
    public static let empty: UserPreferences = .init(favourites: [],
                                                     lastUsedFilterOption: .all,
                                                     preferredBrowserType: .inApp)
    
    public init(
        favourites: Set<Station.ArrivalsGroup.ID>,
        lastUsedFilterOption: UserPreferences.ArrivalsPickerFilterOption,
        preferredBrowserType: UserPreferences.BrowserType
    ) {
        self.favourites = favourites
        self.lastUsedFilterOption = lastUsedFilterOption
        self.preferredBrowserType = preferredBrowserType
    }
}

public struct UserPreferencesClient {
    public let load: () -> AnyPublisher<UserPreferences, Never>
    public let update: (UserPreferences) -> AnyPublisher<UserPreferences, Never>
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

//// MARK: - Fake instance
#if DEBUG
public extension UserPreferencesClient {
    static let fake = UserPreferencesClient(keyValueStore: .fake)
}
#endif
