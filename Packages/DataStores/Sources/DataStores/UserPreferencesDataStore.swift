import Foundation
import Models
import Observation

@MainActor
@Observable
public final class UserPreferencesDataStore {
    

    // MARK: - Properties / outputs
    
    public let userDefaults: UserDefaults
    public let now: () -> Date
    
    public private(set) var value: UserPreferences = .default
    
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
        
        value.recentlySelectedStations = Array(updateValues.prefix(10)) // Save only the 10 most recent items
        persist()
    }
    
    
    // MARK: Recent journeys
    
    public func insertOrReplace(journey: SavedJourney) {
        var updatedValues = value.recentlySavedJourneys
        
        if let existingIndex = value.recentlySavedJourneys.firstIndex(where: {
            $0.isSameJourney(as: journey)
        }) {
            updatedValues[existingIndex] = journey
        } else {
            updatedValues.insert(journey, at: 0)
        }
        
        value.recentlySavedJourneys = updatedValues
        persist()
    }
    
    public func refreshAndRepairSavedJourneyData() {
        var sanitizedJourneys = [SavedJourney]()
        
        value
            .recentlySavedJourneys
            .sortedByLastUsedDateDescending() // Sort by last used dates BEFORE removing duplicates (i.e. old duplicates rejected)
            .forEach { recentJourney in
                if !sanitizedJourneys.contains(where: {
                    $0.isSameOrReverseJourney(of: recentJourney)
                }) {
                    sanitizedJourneys.append(recentJourney)
                }
            }
        
        value.recentlySavedJourneys = Array(sanitizedJourneys.prefix(10)) // Save only the 10 most recent journeys
        persist()
    }
    
    public func remove(recentJourneyID: SavedJourney.ID) {
        var updateValues = value.recentlySavedJourneys
        updateValues.removeAll { $0.id == recentJourneyID }
        
        value.recentlySavedJourneys = updateValues
        persist()
    }
    
    // MARK: Journey planner mode IDs
    
    public func save(journeyPlannerModeIDs: Set<ModeID>) {
        value.journeyPlannerModeIDs = journeyPlannerModeIDs
        persist()
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
                return .default
            }
            return decodedValue
        }
        set {
            guard let data = try? Self.jsonEncoder.encode(newValue) else {
                assertionFailure("Failed to encode user preferences")
                return
            }
            self.set(data, forKey: UserDefaultsKey.userPreferences.rawValue)
        }
    }
}
