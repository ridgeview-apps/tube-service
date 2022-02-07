import ComposableArchitecture
import DataClients

struct DataClients {
    var userPreferences: UserPreferencesClient
    var stations: StationsClient
    var api: TransportAPIClient
}

// MARK: - Real instance
extension DataClients {
    
    static let real = DataClients(
        userPreferences: .real,
        stations: .real(),
        api: .real(appConfig: .real)
    )
}

private extension TransportAPIClient {
    static func real(appConfig: AppConfig) -> TransportAPIClient {
        .real(baseURL: appConfig.transportAPI.baseURL,
              appId: appConfig.transportAPI.appId,
              appKey: appConfig.transportAPI.appKey)
    }
}

// MARK: - Fake instance
#if DEBUG
extension DataClients {
    
    static let fake = DataClients(
        userPreferences: .fake,
        stations: .fake,
        api: .fake
    )
}
#endif
