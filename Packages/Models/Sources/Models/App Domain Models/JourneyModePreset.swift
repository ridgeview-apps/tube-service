import Foundation

public enum JourneyModePreset: Hashable, Sendable {
    case trainAndBus
    case trainOnly
    case busOnly
    case custom(Set<ModeID>)
}

extension JourneyModePreset: Codable {
    private enum CodingKeys: String, CodingKey {
        case type
        case modeIDs
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(String.self, forKey: .type)
        switch type {
        case "trainAndBus":
            self = .trainAndBus
        case "trainOnly":
            self = .trainOnly
        case "busOnly":
            self = .busOnly
        case "custom":
            let rawModeIDs = (try? container.decode([String].self, forKey: .modeIDs)) ?? []
            self = .custom(Set(rawModeIDs.compactMap { ModeID(rawValue: $0) }))
        default:
            self = .trainAndBus
        }
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .trainAndBus:
            try container.encode("trainAndBus", forKey: .type)
        case .trainOnly:
            try container.encode("trainOnly", forKey: .type)
        case .busOnly:
            try container.encode("busOnly", forKey: .type)
        case .custom(let modeIDs):
            try container.encode("custom", forKey: .type)
            try container.encode(modeIDs.map(\.rawValue), forKey: .modeIDs)
        }
    }
}
