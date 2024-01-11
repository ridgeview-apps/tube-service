import Foundation
import Models

@MainActor
@Observable
public final class UserPreferencesDataStore {
    

    // MARK: - Properties / outputs
    
    public let userDefaults: UserDefaults
    public let now: () -> Date
    
    public private(set) var value: UserPreferences = .empty
    
    public var favouriteLineGroupIDs: Set<Station.LineGroup.ID> { value.favouriteLineGroupIDs }
    public var recentlySelectedStations: [Station.ID] { value.recentlySelectedStations ?? [] }
    public var favouriteLineIDs: Set<LineID> { value.favouriteLineIDs ?? [] }
    
    
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
    
    public func isFavourite(lineID: LineID) -> Bool {
        favouriteLineIDs.contains(lineID)
    }
    
    public func add(favouriteLineID: LineID) {
        var updatedLineIDs = value.favouriteLineIDs ?? Set([])
        updatedLineIDs.insert(favouriteLineID)
        value.favouriteLineIDs = updatedLineIDs
        persist()
    }
    
    public func remove(favouriteLineID: LineID) {
        var updatedLineIDs = value.favouriteLineIDs ?? Set([])
        updatedLineIDs.remove(favouriteLineID)
        value.favouriteLineIDs = updatedLineIDs
        persist()
    }
    
    
    // MARK: Recently used line groups
    
    public func save(recentlySelectedStationID: Station.ID) {
        var updateValues = (value.recentlySelectedStations ?? [])
        updateValues.removeAll { $0 == recentlySelectedStationID }
        updateValues.insert(recentlySelectedStationID, at: 0)
        
        value.recentlySelectedStations = Array(updateValues.prefix(10)) // Save only the 10 most-recent items
        persist()
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
