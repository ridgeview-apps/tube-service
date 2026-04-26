import Foundation

public struct ArrivalDeparture: Hashable, Codable, Sendable {

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
    public let departureStatus: DepartureStatus?
    
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
        self.platformName = try? container.decodeIfPresent(String.self, forKey: .platformName)
        self.destinationName = try? container.decodeIfPresent(String.self, forKey: .destinationName)
        self.naptanId = try? container.decodeIfPresent(String.self, forKey: .naptanId)
        self.stationName = try? container.decodeIfPresent(String.self, forKey: .stationName)
        self.estimatedTimeOfArrival = try? container.decodeIfPresent(Date.self, forKey: .estimatedTimeOfArrival)
        self.scheduledTimeOfArrival = try? container.decodeIfPresent(Date.self, forKey: .scheduledTimeOfArrival)
        self.estimatedTimeOfDeparture = try? container.decodeIfPresent(Date.self, forKey: .estimatedTimeOfDeparture)
        self.scheduledTimeOfDeparture = try? container.decodeIfPresent(Date.self, forKey: .scheduledTimeOfDeparture)
        self.minutesAndSecondsToArrival = try? container.decodeIfPresent(String.self, forKey: .minutesAndSecondsToArrival)
        self.minutesAndSecondsToDeparture = try? container.decodeIfPresent(String.self, forKey: .minutesAndSecondsToDeparture)
        self.departureStatus = try? container.decodeIfPresent(DepartureStatus.self, forKey: .departureStatus)
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
