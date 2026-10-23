import Foundation

extension NewFeatureBadges: Codable {

    enum CodingKeys: String, CodingKey {
        case firstSeenAt
        case usedFeatures
    }

    // Manual decoding lets new fields gain their defaults when reading older stored values.
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        firstSeenAt = (try? container.decode([NewFeature: Date].self, forKey: .firstSeenAt)) ?? [:]
        usedFeatures = (try? container.decode(Set<NewFeature>.self, forKey: .usedFeatures)) ?? []
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(firstSeenAt, forKey: .firstSeenAt)
        try container.encode(usedFeatures, forKey: .usedFeatures)
    }
}

extension NewFeatureBadges: RawRepresentable {
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
