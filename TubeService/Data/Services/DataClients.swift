import DataClients

struct DataClients {
    var userPreferences: UserPreferencesClientType
    var stations: StationsClientType
    var transportAPI: TransportAPIClientType
}

// MARK: - Real instance

extension DataClients {
    
    static let real = DataClients(
        userPreferences: UserPreferencesClient(),
        stations: StationsClient(),
        transportAPI: TransportAPIClient(baseURL: AppConfig.real.transportAPI.baseURL,
                                         appID: AppConfig.real.transportAPI.appID,
                                         appKey: AppConfig.real.transportAPI.appKey)
    )
}


// MARK: - Stubs

#if DEBUG
extension DataClients {
    
    static let stub = DataClients(
        userPreferences: DataClientStubs.userPreferences,
        stations: DataClientStubs.stations,
        transportAPI: DataClientStubs.transportAPI
    )
}
#endif
