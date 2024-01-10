import Foundation

public struct ArrivalDeparture: Equatable, Codable {
    public enum DepartureStatus: String, Codable, Equatable {
        case onTime = "OnTime"
        case delayed = "Delayed"
        case cancelled = "Cancelled"
        case notStoppingHere = "NotStoppingAtStation"
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
                departureStatus: DepartureStatus?) {
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
