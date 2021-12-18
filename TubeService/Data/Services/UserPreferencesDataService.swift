import ComposableArchitecture
import Model

struct UserPreferences: Equatable, Codable {
    var favourites: Set<Station.ArrivalsGroup.ID>
    var lastUsedFilterOption: ArrivalsPicker.ViewState.Filter
    var preferredBrowserType: Settings.ViewState.BrowserType
    
    static let empty: UserPreferences = .init(favourites: [],
                                              lastUsedFilterOption: .all,
                                              preferredBrowserType: .inApp)
}

struct UserPreferencesDataService {
    private let jsonDecoder = JSONDecoder()
    private let jsonEncoder = JSONEncoder()
    
    private enum UserDefaultsKey: String {
        case userPreferences
    }
    
    let keyValueStore: KeyValueStore
    
    func load() -> Effect<UserPreferences, Never> {
        guard let data = keyValueStore.get(UserDefaultsKey.userPreferences.rawValue) as? Data,
              let userPreferences = try? jsonDecoder.decode(UserPreferences.self, from: data) else {
            return Effect(value: UserPreferences.empty)
        }
        
        return Effect(value: userPreferences)
    }
    
    func update(userPreferences: UserPreferences) -> Effect<UserPreferences, Never> {
        guard let json = try? jsonEncoder.encode(userPreferences) else {
            assertionFailure()
            return Effect(value: userPreferences)
        }
        keyValueStore.set(.init(key: UserDefaultsKey.userPreferences.rawValue,
                                value: json))
        return load()
    }
}

// MARK: - Real instance
extension UserPreferencesDataService {
    static let real = UserPreferencesDataService(keyValueStore: .real)
}

// MARK: - Fake instance
#if DEBUG
extension UserPreferencesDataService {
    static let fake = UserPreferencesDataService(keyValueStore: .fake)
}
#endif
