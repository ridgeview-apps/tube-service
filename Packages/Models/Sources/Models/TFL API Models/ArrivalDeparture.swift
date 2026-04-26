import Foundation

public struct ArrivalDeparture: Hashable, Codable, Sendable {
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
    
    public let platformName: String?
    public let destinationName: String?
    public let naptanId: String?
    public let stationName: String?
    public let estimatedTimeOfArrival: Date?
    public let scheduledTimeOfArrival: Date?
    public let estimatedTimeOfDeparture: Date?
    public let scheduledTimeOfDeparture: Date?
    public let minutesAndSecondsToArrival: String?
    public let minutesAndSecondsToDeparture: String?
    public let departureStatus: DepartureStatus
    
    public init(platformName: String,
                destinationName: String?,
                naptanId: String?,
                stationName: String?,
                estimatedTimeOfArrival: Date?,
                scheduledTimeOfArrival: Date?,
                estimatedTimeOfDeparture: Date?,
                scheduledTimeOfDeparture: Date?,
                minutesAndSecondsToArrival: String?,
                minutesAndSecondsToDeparture: String?,
                departureStatus: DepartureStatus) {
        self.platformName = platformName
        self.destinationName = destinationName
        self.naptanId = naptanId
        self.stationName = stationName
        self.estimatedTimeOfArrival = estimatedTimeOfArrival
        self.scheduledTimeOfArrival = scheduledTimeOfArrival
        self.estimatedTimeOfDeparture = estimatedTimeOfDeparture
        self.scheduledTimeOfDeparture = scheduledTimeOfDeparture
        self.minutesAndSecondsToArrival = minutesAndSecondsToArrival
        self.minutesAndSecondsToDeparture = minutesAndSecondsToDeparture
        self.departureStatus = departureStatus
    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.platformName = try container.decodeIfPresent(String.self, forKey: .platformName)
        self.destinationName = try container.decodeIfPresent(String.self, forKey: .destinationName)
        self.naptanId = try container.decodeIfPresent(String.self, forKey: .naptanId)
        self.stationName = try container.decodeIfPresent(String.self, forKey: .stationName)
        self.estimatedTimeOfArrival = try container.decodeIfPresent(Date.self, forKey: .estimatedTimeOfArrival)
        self.scheduledTimeOfArrival = try container.decodeIfPresent(Date.self, forKey: .scheduledTimeOfArrival)
        self.estimatedTimeOfDeparture = try container.decodeIfPresent(Date.self, forKey: .estimatedTimeOfDeparture)
        self.scheduledTimeOfDeparture = try container.decodeIfPresent(Date.self, forKey: .scheduledTimeOfDeparture)
        self.minutesAndSecondsToArrival = try container.decodeIfPresent(String.self, forKey: .minutesAndSecondsToArrival)
        self.minutesAndSecondsToDeparture = try container.decodeIfPresent(String.self, forKey: .minutesAndSecondsToDeparture)
        self.departureStatus = (try? container.decodeIfPresent(ArrivalDeparture.DepartureStatus.self, forKey: .departureStatus)) ?? .unknownMissing
    }
}

extension ArrivalDeparture: Identifiable {
    
    public var id: String {
        [platformName,
         destinationName,
         minutesAndSecondsToDeparture,
         minutesAndSecondsToArrival]
            .compactMap { $0 }
            .joined(separator: "-")
    }
}
