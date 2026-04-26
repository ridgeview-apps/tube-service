import Foundation

public struct JourneyResults: Codable, Hashable, Sendable {
    public let journeys: [Journey]?
}

public struct Journey: Codable, Hashable, Sendable {
    public let startDateTime: Date?
    public let duration: Int?
    public let arrivalDateTime: Date?
    public let alternativeRoute: Bool?
    public let legs: [JourneyLeg]?
    public let fare: JourneyFare?
}

public struct JourneyLeg: Codable, Hashable, Sendable {
    
    public let duration: Int?
    public let instruction: JourneyInstruction?
    public let departureTime: Date?
    public let arrivalTime: Date?
    public let departurePoint: StopPoint?
    public let arrivalPoint: StopPoint?
    public let routeOptions: [JourneyRouteOption]?
    public let mode: TflIdentifier?
    public let path: JourneyPath?
    public let disruptions: [Disruption]?
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.duration = try? container.decodeIfPresent(Int.self, forKey: .duration)
        self.instruction = try? container.decodeIfPresent(JourneyInstruction.self, forKey: .instruction)
        self.departureTime = try? container.decodeIfPresent(Date.self, forKey: .departureTime)
        self.arrivalTime = try? container.decodeIfPresent(Date.self, forKey: .arrivalTime)
        self.departurePoint = try? container.decodeIfPresent(StopPoint.self, forKey: .departurePoint)
        self.arrivalPoint = try? container.decodeIfPresent(StopPoint.self, forKey: .arrivalPoint)
        self.routeOptions = try? container.decodeIfPresent([JourneyRouteOption].self, forKey: .routeOptions)
        self.mode = try? container.decodeIfPresent(TflIdentifier.self, forKey: .mode)
        self.path = try? container.decodeIfPresent(JourneyPath.self, forKey: .path)
        self.disruptions = try? container.decodeIfPresent([Disruption].self, forKey: .disruptions)
    }
}

public struct JourneyInstruction: Codable, Hashable, Sendable {
    public let summary: String?
    public let detailed: String?
}

public struct JourneyRouteOption: Codable, Hashable, Sendable {
    public let lineIdentifier: TflIdentifier?
}

public struct JourneyPath: Codable, Hashable, Sendable {
    public let stopPoints: [TflIdentifier]?
}

public struct StopPoint: Codable, Hashable, Sendable {
    public let naptanId: String?
    public let platformName: String?
    public let icsCode: String?
    public let commonName: String?
    public let lat: Double?
    public let lon: Double?
}

public struct TflIdentifier: Codable, Hashable, Sendable {
    public let id: String?
    public let name: String?
    
    var trainLineID: TrainLineID? {
        guard let id else { return nil }
        return TrainLineID(rawValue: id)
    }
    
    var modeID: ModeID? {
        guard let id else { return nil }
        return ModeID(rawValue: id)
    }
}

public struct JourneyFare: Codable, Hashable, Sendable {
    public let totalCost: Int? // In pence
    public let fares: [Fare]?
}

public struct Fare: Codable, Hashable, Sendable {
    let chargeLevel: String?
    let peak: Int?
    let offPeak: Int?
}
