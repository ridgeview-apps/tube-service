//{
//    "$type": "Tfl.Api.Presentation.Entities.ArrivalDeparture, Tfl.Api.Presentation.Entities",
//    "platformName": "Platform Unknown",
//    "destinationName": "Abbey Wood",
//    "naptanId": "910GPADTON",
//    "stationName": "London Paddington Rail Station",
//    "estimatedTimeOfDeparture": "2022-06-01T18:28:00Z",
//    "scheduledTimeOfDeparture": "2022-06-01T18:28:00Z",
//    "minutesAndSecondsToArrival": "",
//    "minutesAndSecondsToDeparture": "12:43",
//    "departureStatus": "OnTime"
//},

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
    public let estimatedTimeOfDeparture: Date?
    public let scheduledTimeOfDeparture: Date?
    public let minutesAndSecondsToArrival: String?
    public let minutesAndSecondsToDeparture: String?
    public let departureStatus: DepartureStatus?
    
    public init(platformName: String,
                destinationName: String?,
                naptanId: String?,
                stationName: String?,
                estimatedTimeOfDeparture: Date?,
                scheduledTimeOfDeparture: Date?,
                minutesAndSecondsToArrival: String?,
                minutesAndSecondsToDeparture: String?,
                departureStatus: DepartureStatus?) {
        self.platformName = platformName
        self.destinationName = destinationName
        self.naptanId = naptanId
        self.stationName = stationName
        self.estimatedTimeOfDeparture = estimatedTimeOfDeparture
        self.scheduledTimeOfDeparture = scheduledTimeOfDeparture
        self.minutesAndSecondsToArrival = minutesAndSecondsToArrival
        self.minutesAndSecondsToDeparture = minutesAndSecondsToDeparture
        self.departureStatus = departureStatus
    }
}

extension ArrivalDeparture: Identifiable {
    
    public var id: String {
        return "\(naptanId ?? "")-\(platformName ?? "")-\(destinationName ?? "")-\(minutesAndSecondsToArrival ?? "")-\(minutesAndSecondsToDeparture ?? "")-\(stationName ?? "")-"
    }
}
