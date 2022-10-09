import Foundation
import Models
import Combine

// MARK: - Data types

public protocol UserPreferencesClientType {
    func load() -> UserPreferences
    func save(_ userPreferences: UserPreferences)
}


// MARK: - UserPreferencesClient {

public struct UserPreferencesClient: UserPreferencesClientType {
    
    private enum UserDefaultsKey: String {
        case userPreferences
    }
    
    let userDefaults: UserDefaults
    
    private let jsonDecoder = JSONDecoder()
    private let jsonEncoder = JSONEncoder()
    
    public init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    public func load() -> UserPreferences {
        guard let data = userDefaults.object(forKey: UserDefaultsKey.userPreferences.rawValue) as? Data,
              let userPreferences = try? jsonDecoder.decode(UserPreferences.self, from: data) else {
            return .empty
        }
        return userPreferences
    }
    
    public func save(_ userPreferences: UserPreferences) {
        guard let json = try? jsonEncoder.encode(userPreferences) else {
            assertionFailure()
            return
        }
        userDefaults.set(json, forKey: UserDefaultsKey.userPreferences.rawValue)
    }
}
