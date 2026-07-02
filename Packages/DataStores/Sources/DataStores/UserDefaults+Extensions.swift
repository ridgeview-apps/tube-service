import Foundation
import Models
import Shared

public extension UserDefaults {

    enum Keys: String {
        case userPreferences = "userPreferences_v2"
        case featureFlags = "featureFlags_v1"
        case notificationState = "notificationState_v1"
    }

    // N.B. @AppStorage property wrapper is available from SwiftUI views and should be used whenever possible.
    // These properties are exposed for scenarios where @AppStorage is more difficult to work with (e.g. widget timelines, SwiftUI Previews)

    var featureFlags: FeatureFlags {
        get {
            guard let encodedRawValue = string(forKey: Keys.featureFlags.rawValue),
                let decodedValue = FeatureFlags(rawValue: encodedRawValue)
            else {
                return .default
            }
            return decodedValue
        }
        set {
            set(newValue.rawValue, forKey: Keys.featureFlags.rawValue)
        }
    }

    var notificationState: NotificationState {
        get {
            guard let rawValue = string(forKey: Keys.notificationState.rawValue),
                let decoded = NotificationState(rawValue: rawValue)
            else {
                return .default
            }
            return decoded
        }
        set {
            set(newValue.rawValue, forKey: Keys.notificationState.rawValue)
        }
    }

    var userPreferences: UserPreferences {
        get {
            guard let encodedRawValue = string(forKey: Keys.userPreferences.rawValue),
                let decodedValue = UserPreferences(rawValue: encodedRawValue)
            else {
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
            let legacyDecodedValue = try? JSONDecoder().decode(UserPreferences.self, from: data)
        {

            if let encoded = try? JSONEncoder().encode(legacyDecodedValue),
                let string = String(data: encoded, encoding: .utf8)
            {
                AppLogger.networking.info("Migrating legacy user defaults to new key: \(UserDefaults.Keys.userPreferences.rawValue)")
                setValue(string, forKey: UserDefaults.Keys.userPreferences.rawValue)
            }
        }
    }
}
