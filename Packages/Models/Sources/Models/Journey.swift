import Foundation

public struct JourneyItinerary: Codable, Hashable {
    public let journeys: [Journey]?
}

public struct Journey: Codable, Hashable {
    public let startDateTime: Date?
    public let duration: Int?
    public let arrivalDateTime: Date?
    public let alternativeRoute: Bool?
    public let legs: [JourneyLeg]?
    public let fare: JourneyFare?
}

public struct JourneyLeg: Codable, Hashable {
    
    public let duration: Int?
    public let instruction: JourneyInstruction?
    public let departureTime: Date?
    public let arrivalTime: Date?
    public let departurePoint: StopPoint?
    public let arrivalPoint: StopPoint?
    public let routeOptions: [JourneyRouteOption]?
    public let mode: TflIdentifierType?
    public let path: JourneyPath?
    public let disruptions: [Disruption]?
}

public struct JourneyInstruction: Codable, Hashable {
    public let summary: String?
    public let detailed: String?
}

public struct JourneyRouteOption: Codable, Hashable {
    public let lineIdentifier: TflIdentifierType?
}

public struct JourneyPath: Codable, Hashable {
    public let stopPoints: [TflIdentifier]?
}

public struct StopPoint: Codable, Hashable {
    public let naptanId: String?
    public let platformName: String?
    public let icsCode: String?
    public let commonName: String?
    public let lat: Double?
    public let lon: Double?
}

public struct TflIdentifier: Codable, Hashable {
    public let id: String?
    public let name: String?
}

public enum TflIdentifierType: Hashable, Codable {
    
    case modeID(ModeID)
    case trainLineID(TrainLineID)
    case otherLineID(String)
    case otherID(TflIdentifier)
    case unsupported
    
    var modeID: ModeID? {
        guard case let .modeID(modeID) = self else {
            return nil
        }
        return modeID
    }
    
    var trainLineID: TrainLineID? {
        guard case let .trainLineID(lineID) = self else {
            return nil
        }
        return lineID
    }
    
    private struct DiscriminatorKey: Decodable {
        let type: String?
    }
    
    public init(from decoder: Decoder) throws {
        guard let discriminator = try? DiscriminatorKey(from: decoder).type else {
            self = .unsupported
            return
        }
        
        let identifier = try TflIdentifier(from: decoder)
        
        switch discriminator.lowercased() {
        case "mode":
            guard let id = identifier.id,
                  let mode = ModeID(rawValue: id) else {
                self = .unsupported
                return
            }
            self = .modeID(mode)
        case "line":
            guard let id = identifier.id else {
                self = .unsupported
                return
            }
            if let trainLineID = TrainLineID(rawValue: id) {
                self = .trainLineID(trainLineID)
            } else {
                self = .otherLineID(id)
            }
        default:
            self = .otherID(identifier)
        }
    }
}

public struct JourneyFare: Codable, Hashable {
    public let totalCost: Int? // In pence
    public let fares: [Fare]?
}

public struct Fare: Codable, Hashable {
    let chargeLevel: String?
    let peak: Int?
    let offPeak: Int?
}
