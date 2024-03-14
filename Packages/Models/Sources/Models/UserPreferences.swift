import Foundation

public struct UserPreferences: Equatable, Codable {
    
    enum CodingKeys: String, CodingKey {
        case favouriteLineGroupIDs = "favourites"
        case recentlySelectedStations
        case favouriteLineIDs
        case journeyPlannerModeIDs
        case recentlySavedJourneys
    }
    
    public var favouriteLineGroupIDs: Set<Station.LineGroup.ID>
    public var favouriteLineIDs: Set<Line.ID>
    public var recentlySelectedStations: [Station.ID]
    public var journeyPlannerModeIDs: Set<ModeID>
    public var recentlySavedJourneys: [SavedJourney]

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.favouriteLineGroupIDs = try container.decode(Set<Station.LineGroup.ID>.self, forKey: .favouriteLineGroupIDs)
        self.recentlySelectedStations = (try? container.decode([Station.ID].self, forKey: .recentlySelectedStations)) ?? []
        self.favouriteLineIDs = (try? container.decodeIfPresent(Set<Line.ID>.self, forKey: .favouriteLineIDs)) ?? []
        self.journeyPlannerModeIDs = (try? container.decode(Set<ModeID>.self, forKey: .journeyPlannerModeIDs)) ?? ModeID.defaultJourneyPlannerModeIDs
        self.recentlySavedJourneys = (try? container.decode([SavedJourney].self, forKey: .recentlySavedJourneys)) ?? []
    }
    
    public static let `default`: UserPreferences = .init(favouriteLineGroupIDs: [],
                                                         favouriteLineIDs: [],
                                                         recentlySelectedStations: [],
                                                         journeyPlannerModeIDs: ModeID.defaultJourneyPlannerModeIDs,
                                                         recentlySavedJourneys: [])
    
    public init(favouriteLineGroupIDs: Set<Station.LineGroup.ID>,
                favouriteLineIDs: Set<Line.ID> = [],
                recentlySelectedStations: [Station.ID] = [],
                journeyPlannerModeIDs: Set<ModeID>,
                recentlySavedJourneys: [SavedJourney]) {
        self.favouriteLineGroupIDs = favouriteLineGroupIDs
        self.favouriteLineIDs = favouriteLineIDs
        self.recentlySelectedStations = recentlySelectedStations
        self.journeyPlannerModeIDs = journeyPlannerModeIDs
        self.recentlySavedJourneys = recentlySavedJourneys
    }
    
}

public struct SavedJourney: Identifiable, Hashable, Codable {
    public enum LocationType: Hashable, Codable {
        case station(id: Station.ID)
        case nationalRail(icsCode: String)
        case specific(LocationName, LocationCoordinate)
        
        
        // MARK: - Custom Equatable conformance
        
        public static func == (lhs: LocationType, rhs: LocationType) -> Bool {
            switch (lhs, rhs) {
            case let (.specific(lhsName, _), .specific(rhsName, _)):
                return lhsName == rhsName
            case let (.station(lhsID), .station(rhsID)):
                return lhsID == rhsID
            case let (.nationalRail(lhsID), .nationalRail(rhsID)):
                return lhsID == rhsID
            default:
                return false
            }
        }
        
        public func hash(into hasher: inout Hasher) {
            switch self {
            case .station(let stationID):
                hasher.combine(stationID)
            case .nationalRail(let stopPointID):
                hasher.combine(stopPointID)
            case .specific(let locationName, _):
                hasher.combine(locationName)
            }
        }
    }
    
    public let id: UUID
    public let fromLocation: LocationType
    public let toLocation: LocationType
    public let viaLocation: LocationType?
    public let lastUsed: Date
    
    public init(id: UUID,
                fromLocation: LocationType,
                toLocation: LocationType,
                viaLocation: LocationType?,
                lastUsed: Date) {
        self.id = id
        self.fromLocation = fromLocation
        self.toLocation = toLocation
        self.viaLocation = viaLocation
        self.lastUsed = lastUsed
    }
}
