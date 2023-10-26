import Foundation

public struct UserPreferences: Equatable, Codable {
    
    enum CodingKeys: String, CodingKey {
        case favouriteLineGroupIDs = "favourites"
        case recentlySelectedStations
        case favouriteLineIDs
    }
    
    public var favouriteLineGroupIDs: Set<Station.LineGroup.ID>
    public var favouriteLineIDs: Set<Line.ID>?
    public var recentlySelectedStations: [Station.ID]?
    
    public static let empty: UserPreferences = .init(favouriteLineGroupIDs: [],
                                                     favouriteLineIDs: [],
                                                     recentlySelectedStations: []
)
    
    public init(
        favouriteLineGroupIDs: Set<Station.LineGroup.ID>,
        favouriteLineIDs: Set<Line.ID>?,
        recentlySelectedStations: [Station.LineGroup.ID]
    ) {
        self.favouriteLineGroupIDs = favouriteLineGroupIDs
        self.favouriteLineIDs = favouriteLineIDs
        self.recentlySelectedStations = recentlySelectedStations
    }
}
