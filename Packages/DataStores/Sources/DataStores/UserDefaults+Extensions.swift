import Foundation
import Models

public extension UserDefaults {
    
    enum Keys: String {
        case userPreferences = "userPreferences_v2"
    }
    
    // N.B. @AppStorage property wrapper is available from SwiftUI views and should be used whenever possible.
    // This property is merely exposed for other scenarios where @AppStorage is more difficult to work with (e.g. widget timelines, SwiftUI Previews)
    
    var userPreferences: UserPreferences {
        get {
            guard let encodedRawValue = string(forKey: Keys.userPreferences.rawValue),
                  let decodedValue = UserPreferences(rawValue: encodedRawValue) else {
                return .default
            }
            return decodedValue
        }
        set {
            set(newValue.rawValue, forKey: Keys.userPreferences.rawValue)
        }
    }
}

public extension UserDefaults {
    
    func migrateLegacyValuesIfNeeded() {
        guard string(forKey: UserDefaults.Keys.userPreferences.rawValue) == nil else {
            return
        }
        
        if let data = object(forKey: "userPreferences") as? Data,
           let legacyDecodedValue = try? JSONDecoder().decode(UserPreferences.self, from: data) {
            
            if let encoded = try? JSONEncoder().encode(legacyDecodedValue),
               let string = String(data: encoded, encoding: .utf8) {
                print("Migrating legacy user values defaults to new key: \(UserDefaults.Keys.userPreferences.rawValue)")
                setValue(string, forKey: UserDefaults.Keys.userPreferences.rawValue)
            }
        }        
    }
}
