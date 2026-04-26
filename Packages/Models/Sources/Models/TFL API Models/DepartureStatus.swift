public enum DepartureStatus: Codable, Equatable, Hashable, Sendable {
    case onTime
    case delayed
    case cancelled
    case notStoppingAtStation
    case unknown(String)

    private static let missingValue = "missing"

    private var rawValue: String {
        switch self {
        case .onTime:
            "OnTime"
        case .delayed:
            "Delayed"
        case .cancelled:
            "Cancelled"
        case .notStoppingAtStation:
            "NotStoppingAtStation"
        case let .unknown(rawValue):
            rawValue
        }
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self)
        switch rawValue {
        case "OnTime":
            self = .onTime
        case "Delayed":
            self = .delayed
        case "Cancelled":
            self = .cancelled
        case "NotStoppingAtStation":
            self = .notStoppingAtStation
        default:
            self = .unknown(rawValue)
        }
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rawValue)
    }

    static var unknownMissing: DepartureStatus {
        .unknown(Self.missingValue)
    }
}
