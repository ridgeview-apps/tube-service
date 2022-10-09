import Foundation

public struct UserPreferences: Equatable, Codable {
    
    public enum ArrivalsPickerFilterOption: Int, Identifiable, CaseIterable, Codable {
        public var id: Int { rawValue }
        case all, favourites
    }
    
    public var favourites: Set<Station.LineGroup.ID>
    public var lastUsedFilterOption: ArrivalsPickerFilterOption
    public var recentlySelectedStations: [Station.ID]?
    
    public static let empty: UserPreferences = .init(favourites: [],
                                                     lastUsedFilterOption: .all,
                                                     recentlySelectedStations: [])
    
    public init(
        favourites: Set<Station.LineGroup.ID>,
        lastUsedFilterOption: UserPreferences.ArrivalsPickerFilterOption,
        recentlySelectedStations: [Station.LineGroup.ID]
    ) {
        self.favourites = favourites
        self.lastUsedFilterOption = lastUsedFilterOption
        self.recentlySelectedStations = recentlySelectedStations
    }
}
