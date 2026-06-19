import Foundation

extension FeatureFlags {

    enum CodingKeys: String, CodingKey {
        case isStatusHistoryEnabled
        case isNotificationsEnabled
    }

    // Manual decoding lets new flags gain their defaults when reading older stored values.
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        isStatusHistoryEnabled =
            (try? container.decode(Bool.self, forKey: .isStatusHistoryEnabled)) ?? false
        isNotificationsEnabled =
            (try? container.decode(Bool.self, forKey: .isNotificationsEnabled)) ?? false
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(isStatusHistoryEnabled, forKey: .isStatusHistoryEnabled)
        try container.encode(isNotificationsEnabled, forKey: .isNotificationsEnabled)
    }
}

extension FeatureFlags: RawRepresentable {
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
