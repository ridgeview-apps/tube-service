import Foundation

#if DEBUG

public extension UserPreferencesDataStore {
    
    static func stub() -> UserPreferencesDataStore {
        .init(userDefaults: uniqueSuiteNameUserDefaults())
    }
    
    private static func uniqueSuiteNameUserDefaults() -> UserDefaults {
        .init(suiteName: UUID().uuidString)!
    }
}

#endif
