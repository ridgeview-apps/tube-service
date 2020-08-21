import ComposableArchitecture

struct DataServices {
    var userPreferences: UserPreferencesDataService
    var stations: StationsDataService
    var api: TransportAPI
}

// MARK: - Real instance
extension DataServices {
    
    static let real = DataServices(
        userPreferences: .real,
        stations: .real,
        api: .real
    )
}

// MARK: - Fake instance
#if DEBUG
extension DataServices {
    
    static let fake = DataServices(
        userPreferences: .fake,
        stations: .fake,
        api: .fake
    )
}
#endif
