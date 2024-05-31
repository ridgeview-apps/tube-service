import Foundation
import Models

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

    // N.B. Codable conformance needs to be implemented manually to play nicely with `RawRepresentable`
    // and prevent infinite recursion. It also makes it easier to add new properties (with default values)
    // and prevents decoding errors of older data structures.
    //
    // See:
    // - https://stackoverflow.com/a/74191039
    // - https://antran.app/2024/appstorage_codable/
    //
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.favouriteLineGroupIDs = try container.decode(Set<Station.LineGroup.ID>.self, forKey: .favouriteLineGroupIDs)
        self.recentlySelectedStations = (try? container.decode([Station.ID].self, forKey: .recentlySelectedStations)) ?? []
        self.favouriteLineIDs = (try? container.decodeIfPresent(Set<Line.ID>.self, forKey: .favouriteLineIDs)) ?? []
        self.journeyPlannerModeIDs = (try? container.decode(Set<ModeID>.self, forKey: .journeyPlannerModeIDs)) ?? ModeID.defaultJourneyPlannerModeIDs
        self.recentlySavedJourneys = (try? container.decode([SavedJourney].self, forKey: .recentlySavedJourneys)) ?? []
    }
    
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.favouriteLineGroupIDs, forKey: .favouriteLineGroupIDs)
        try container.encode(self.recentlySelectedStations, forKey: .recentlySelectedStations)
        try container.encode(self.favouriteLineIDs, forKey: .favouriteLineIDs)
        try container.encode(self.journeyPlannerModeIDs, forKey: .journeyPlannerModeIDs)
        try container.encode(self.recentlySavedJourneys, forKey: .recentlySavedJourneys)
    }
    
    public static let `default`: UserPreferences = .init(favouriteLineGroupIDs: [],
                                                         favouriteLineIDs: [],
                                                         recentlySelectedStations: [],
                                                         journeyPlannerModeIDs: ModeID.defaultJourneyPlannerModeIDs,
                                                         recentlySavedJourneys: [])
    
    public init(
        favouriteLineGroupIDs: Set<Station.LineGroup.ID>,
        favouriteLineIDs: Set<Line.ID> = [],
        recentlySelectedStations: [Station.ID] = [],
        journeyPlannerModeIDs: Set<ModeID>,
        recentlySavedJourneys: [SavedJourney]
    ) {
        self.favouriteLineGroupIDs = favouriteLineGroupIDs
        self.favouriteLineIDs = favouriteLineIDs
        self.recentlySelectedStations = recentlySelectedStations
        self.journeyPlannerModeIDs = journeyPlannerModeIDs
        self.recentlySavedJourneys = recentlySavedJourneys
    }
}

// MARK: - RawRepresentable (@AppStorage)

extension UserPreferences: RawRepresentable {
    public typealias RawValue = String
    
    public init?(rawValue: RawValue) {
        guard
            let data = rawValue.data(using: .utf8),
            let decoded = try? JSONDecoder().decode(Self.self, from: data)
        else {
            return nil
        }
        self = decoded
    }
    
    public var rawValue: RawValue {
        guard
            let data = try? JSONEncoder().encode(self),
            let encodedValue = String(data: data, encoding: .utf8)
        else {
            return ""
        }
        return encodedValue
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


// MARK: - Public API

public extension UserPreferences {
    
    
    // MARK: - Favourite line groups
    
    func containsFavouriteLineGroup(_ lineGroupID: Station.LineGroup.ID) -> Bool {
        favouriteLineGroupIDs.contains(lineGroupID)
    }
    
    mutating func addFavouriteLineGroup(_ favouriteLineGroupID: Station.LineGroup.ID) {
        favouriteLineGroupIDs.insert(favouriteLineGroupID)
    }
    
    mutating func removeFavouriteLineGroup(_ favouriteLineGroupID: Station.LineGroup.ID) {
        favouriteLineGroupIDs.remove(favouriteLineGroupID)
    }

    
    // MARK: - Favourite line IDS
    
    func containsFavouriteLine(_ lineID: TrainLineID) -> Bool {
        favouriteLineIDs.contains(lineID)
    }
    
    mutating func addFavouriteLine(_ favouriteLineID: TrainLineID) {
        favouriteLineIDs.insert(favouriteLineID)
    }
    
    mutating func removeFavouriteLine(_ favouriteLineID: TrainLineID) {
        favouriteLineIDs.remove(favouriteLineID)
    }
    
    
    // MARK: Recently selected stations
    
    mutating func saveRecentlySelectedStation(_ stationID: Station.ID) {
        var updateValues = recentlySelectedStations
        updateValues.removeAll { $0 == stationID }
        updateValues.insert(stationID, at: 0)
        
        recentlySelectedStations = Array(updateValues.prefix(10)) // Save only the 10 most recent items
    }
    
    
    // MARK: Recent journeys
    
    mutating func saveRecentJourney(_ journey: SavedJourney) {
        var updatedValues = recentlySavedJourneys
        
        if let existingIndex = recentlySavedJourneys.firstIndex(where: {
            $0.isSameJourney(as: journey)
        }) {
            updatedValues[existingIndex] = journey
        } else {
            updatedValues.insert(journey, at: 0)
        }
        
        recentlySavedJourneys = updatedValues
    }
    
    mutating func cleanUpSavedJourneys() {
        var sanitizedJourneys = [SavedJourney]()
        
        recentlySavedJourneys
            .sortedByLastUsedDateDescending() // Sort by last used dates BEFORE removing duplicates (i.e. old duplicates rejected)
            .forEach { recentJourney in
                if !sanitizedJourneys.contains(where: {
                    $0.isSameOrReverseJourney(of: recentJourney)
                }) {
                    sanitizedJourneys.append(recentJourney)
                }
            }
        
        recentlySavedJourneys = Array(sanitizedJourneys.prefix(10)) // Save only the 10 most recent journeys
    }
    
    mutating func removeRecentJourney(_ journeyID: SavedJourney.ID) {
        recentlySavedJourneys.removeAll { $0.id == journeyID }
    }
    
    
    // MARK: Journey planner mode IDs
    
    mutating func saveJourneyPlannerModes(_ modeIDs: Set<ModeID>) {
        self.journeyPlannerModeIDs = modeIDs
    }
}


private extension Sequence where Element == SavedJourney {
    func sortedByLastUsedDateDescending() -> [SavedJourney] {
        sorted { $0.lastUsed > $1.lastUsed }
    }
}

private extension SavedJourney {

    func isSameOrReverseJourney(of otherJourney: SavedJourney) -> Bool {
        isSameJourney(as: otherJourney) || isReverseJourney(of: otherJourney)
    }
    
    private func reverseJourney() -> SavedJourney {
        .init(id: id,
              fromLocation: toLocation,
              toLocation: fromLocation,
              viaLocation: viaLocation,
              lastUsed: lastUsed)
    }
    
    func isSameJourney(as otherJourney: SavedJourney) -> Bool {
        fromLocation == otherJourney.fromLocation
            && toLocation == otherJourney.toLocation
            && viaLocation == otherJourney.viaLocation
    }
    
    private func isReverseJourney(of otherJourney: SavedJourney) -> Bool {
        return isSameJourney(as: otherJourney.reverseJourney())
    }
}
