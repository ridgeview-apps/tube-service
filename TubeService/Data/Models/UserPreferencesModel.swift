import DataClients
import Foundation
import Models

@MainActor
final class UserPreferencesModel: ObservableObject {
    
    // MARK: - Properties / outputs
    
    let userPreferencesClient: UserPreferencesClientType
    let now: () -> Date
    
    @Published private(set) var  data: UserPreferences = .empty
    
    var favourites: Set<Station.LineGroup.ID> { data.favourites }
    var lastUsedFilterOption: UserPreferences.ArrivalsPickerFilterOption { data.lastUsedFilterOption }
    var recentlySelectedStations: [Station.ID] { data.recentlySelectedStations ?? [] }
    
    
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
    
    
    // MARK: Favourites
    
    func isFavourite(lineGroupID: Station.LineGroup.ID) -> Bool {
        favourites.contains(lineGroupID)
    }
    
    func add(favouriteLineGroupID: Station.LineGroup.ID) {
        data.favourites.insert(favouriteLineGroupID)
        save()
    }
    
    func remove(favouriteLineGroupID: Station.LineGroup.ID) {
        data.favourites.remove(favouriteLineGroupID)
        save()
    }
    
    
    // MARK: Filter options
    
    func save(lastUserFilterOption: UserPreferences.ArrivalsPickerFilterOption) {
        data.lastUsedFilterOption = lastUserFilterOption
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
