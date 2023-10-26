import DataClients
import Foundation
import Models

@MainActor
final class UserPreferencesModel: ObservableObject {
    
    // MARK: - Properties / outputs
    
    let userPreferencesClient: UserPreferencesClientType
    let now: () -> Date
    
    @Published private(set) var data: UserPreferences = .empty
    
    var favouriteLineGroupIDs: Set<Station.LineGroup.ID> { data.favouriteLineGroupIDs }
    var recentlySelectedStations: [Station.ID] { data.recentlySelectedStations ?? [] }
    var favouriteLineIDs: Set<LineID> { data.favouriteLineIDs ?? [] }
    
    
    // MARK: - Init
    
    init(userPreferencesClient: UserPreferencesClientType,
         now: @escaping () -> Date = { Date() }) {
        self.userPreferencesClient = userPreferencesClient
        self.now = now
        load()
    }
    
    // MARK: - Actions
    
    private func load() {
        self.data = userPreferencesClient.load()
    }
    
    private func save() {
        userPreferencesClient.save(data)
        load()
    }
    
    
    // MARK: Favourite line groups
    
    func isFavourite(lineGroupID: Station.LineGroup.ID) -> Bool {
        favouriteLineGroupIDs.contains(lineGroupID)
    }
    
    func add(favouriteLineGroupID: Station.LineGroup.ID) {
        data.favouriteLineGroupIDs.insert(favouriteLineGroupID)
        save()
    }
    
    func remove(favouriteLineGroupID: Station.LineGroup.ID) {
        data.favouriteLineGroupIDs.remove(favouriteLineGroupID)
        save()
    }
    
    
    // MARK: Favourite line IDs
    
    func isFavourite(lineID: LineID) -> Bool {
        favouriteLineIDs.contains(lineID)
    }
    
    func add(favouriteLineID: LineID) {
        var updatedValues = data.favouriteLineIDs ?? Set([])
        updatedValues.insert(favouriteLineID)
        data.favouriteLineIDs = updatedValues
        save()
    }
    
    func remove(favouriteLineID: LineID) {
        var updatedValues = data.favouriteLineIDs ?? Set([])
        updatedValues.remove(favouriteLineID)
        data.favouriteLineIDs = updatedValues
        save()
    }
    
    
    // MARK: Recently used line groups
    
    func save(recentlySelectedStationID: Station.ID) {
        var updateValues = (data.recentlySelectedStations ?? [])
        updateValues.removeAll { $0 == recentlySelectedStationID }
        updateValues.insert(recentlySelectedStationID, at: 0)
        
        data.recentlySelectedStations = Array(updateValues.prefix(10)) // Save only the 10 most-recent items
        save()
    }
}
