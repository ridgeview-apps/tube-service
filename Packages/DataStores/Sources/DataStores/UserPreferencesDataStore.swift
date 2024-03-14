import Foundation
import Models

@MainActor
public final class UserPreferencesDataStore: ObservableObject {
    

    // MARK: - Properties / outputs
    
    public let userDefaults: UserDefaults
    public let now: () -> Date
    
    @Published public private(set) var value: UserPreferences = .empty
    
    public var favouriteLineGroupIDs: Set<Station.LineGroup.ID> { value.favouriteLineGroupIDs }
    public var recentlySelectedStations: [Station.ID] { value.recentlySelectedStations }
    public var favouriteLineIDs: Set<TrainLineID> { value.favouriteLineIDs }
    public var journeyPlannerModeIDs: Set<ModeID> { value.journeyPlannerModeIDs }
    public var recentlySavedJourneys: [SavedJourney] { value.recentlySavedJourneys }
    
    // MARK: - Init
    
    public init(userDefaults: UserDefaults,
                now: @escaping () -> Date = { Date() }) {
        self.userDefaults = userDefaults
        self.now = now
        self.value = userDefaults.userPreferences
    }
    
    
    private func persist() {
        userDefaults.userPreferences = value
    }
    
    
    // MARK: Favourite line groups
    
    public func isFavourite(lineGroupID: Station.LineGroup.ID) -> Bool {
        favouriteLineGroupIDs.contains(lineGroupID)
    }
    
    public func add(favouriteLineGroupID: Station.LineGroup.ID) {
        value.favouriteLineGroupIDs.insert(favouriteLineGroupID)
        persist()
    }
    
    public func remove(favouriteLineGroupID: Station.LineGroup.ID) {
        value.favouriteLineGroupIDs.remove(favouriteLineGroupID)
        persist()
    }
    
    
    // MARK: Favourite line IDs
    
    public func isFavourite(lineID: TrainLineID) -> Bool {
        favouriteLineIDs.contains(lineID)
    }
    
    public func add(favouriteLineID: TrainLineID) {
        var updatedLineIDs = value.favouriteLineIDs
        updatedLineIDs.insert(favouriteLineID)
        value.favouriteLineIDs = updatedLineIDs
        persist()
    }
    
    public func remove(favouriteLineID: TrainLineID) {
        var updatedLineIDs = value.favouriteLineIDs
        updatedLineIDs.remove(favouriteLineID)
        value.favouriteLineIDs = updatedLineIDs
        persist()
    }
    
    
    // MARK: Recently used stations
    
    public func save(recentlySelectedStationID: Station.ID) {
        var updateValues = value.recentlySelectedStations
        updateValues.removeAll { $0 == recentlySelectedStationID }
        updateValues.insert(recentlySelectedStationID, at: 0)
        
        value.recentlySelectedStations = Array(updateValues.prefix(10)) // Save only the 10 most-recent items
        persist()
    }
    
    
    // MARK: Recent journeys
    
    public func save(recentJourney: SavedJourney) {
        var updateValues = value.recentlySavedJourneys
        updateValues.removeAll { recentJourney.isSameOrReverseJourney(of: $0) }
        updateValues.insert(recentJourney, at: 0)
        
        value.recentlySavedJourneys = Array(updateValues.prefix(10)) // Save only the 10 most-recent items
        persist()
    }
    
    public func remove(recentJourney: SavedJourney) {
        var updateValues = value.recentlySavedJourneys
        updateValues.removeAll { $0 == recentJourney }
        
        value.recentlySavedJourneys = updateValues
        persist()
    }
    
    // MARK: Journey planner mode IDs
    
    public func save(journeyPlannerModeIDs: Set<ModeID>) {
        value.journeyPlannerModeIDs = journeyPlannerModeIDs
        persist()
    }
}

private extension SavedJourney {

    var reverseJourney: SavedJourney {
        .init(fromLocation: toLocation,
              toLocation: fromLocation,
              viaLocation: viaLocation)
    }

    func isSameOrReverseJourney(of otherJourney: SavedJourney) -> Bool {
        self == otherJourney || self == otherJourney.reverseJourney
    }
}


extension UserDefaults {
    
    private enum UserDefaultsKey: String {
        case userPreferences
    }
    
    private static let jsonDecoder = JSONDecoder()
    private static let jsonEncoder = JSONEncoder()
    
    var userPreferences: UserPreferences {
        get {
            guard let data = self.object(forKey: UserDefaultsKey.userPreferences.rawValue) as? Data,
                  let decodedValue = try? Self.jsonDecoder.decode(UserPreferences.self, from: data) else {
                return .empty
            }
            return decodedValue
        }
        set {
            guard let data = try? Self.jsonEncoder.encode(newValue) else {
                assertionFailure()
                return
            }
            self.set(data, forKey: UserDefaultsKey.userPreferences.rawValue)
        }
    }
}
