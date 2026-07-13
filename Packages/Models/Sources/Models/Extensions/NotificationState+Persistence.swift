import Foundation

extension NotificationState {
    enum CodingKeys: String, CodingKey {
        case device
        case preferences
        case hasCompletedOnboarding
        case hasUserDeletedDevice
        case pendingPreferencesUpdate
    }

    // Manual decoding allows new fields to gain defaults when reading older stored values.
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        device = try? container.decodeIfPresent(NotificationDevice.self, forKey: .device)
        preferences = try? container.decodeIfPresent(NotificationPreferences.self, forKey: .preferences)
        hasCompletedOnboarding =
            (try? container.decode(Bool.self, forKey: .hasCompletedOnboarding)) ?? false
        hasUserDeletedDevice =
            (try? container.decode(Bool.self, forKey: .hasUserDeletedDevice)) ?? false
        pendingPreferencesUpdate =
            try? container.decodeIfPresent(NotificationPreferencesUpdate.self, forKey: .pendingPreferencesUpdate)
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(device, forKey: .device)
        try container.encodeIfPresent(preferences, forKey: .preferences)
        try container.encode(hasCompletedOnboarding, forKey: .hasCompletedOnboarding)
        try container.encode(hasUserDeletedDevice, forKey: .hasUserDeletedDevice)
        try container.encodeIfPresent(pendingPreferencesUpdate, forKey: .pendingPreferencesUpdate)
    }
}

extension NotificationState: RawRepresentable {
    public typealias RawValue = String

    public init?(rawValue: RawValue) {
        guard
            let data = rawValue.data(using: .utf8),
            let decoded = try? JSONDecoder().decode(Self.self, from: data)
        else {
            return nil
        }
        self = decoded
    }

    public var rawValue: RawValue {
        guard
            let data = try? JSONEncoder().encode(self),
            let encodedValue = String(data: data, encoding: .utf8)
        else {
            return ""
        }
        return encodedValue
    }
}
