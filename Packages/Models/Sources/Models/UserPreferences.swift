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
        self.journeyPlannerModeIDs = (try? container.decode(Set<ModeID>.self, forKey: .journeyPlannerModeIDs)) ?? ModeID.journeyPlannerModeIDs
        self.recentlySavedJourneys = (try? container.decode([SavedJourney].self, forKey: .recentlySavedJourneys)) ?? []
    }
    
    public static let empty: UserPreferences = .init(favouriteLineGroupIDs: [],
                                                     favouriteLineIDs: [],
                                                     recentlySelectedStations: [],
                                                     journeyPlannerModeIDs: [],
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

public struct SavedJourney: Equatable, Codable {
    public enum LocationType: Equatable, Codable {
        case station(id: Station.ID)
        case nationalRail(icsCode: String)
        case specific(LocationName, LocationCoordinate)
    }
    
    public let fromLocation: LocationType
    public let toLocation: LocationType
    public let viaLocation: LocationType?
    
    public init(fromLocation: LocationType,
                toLocation: LocationType,
                viaLocation: LocationType?) {
        self.fromLocation = fromLocation
        self.toLocation = toLocation
        self.viaLocation = viaLocation
    }
}
