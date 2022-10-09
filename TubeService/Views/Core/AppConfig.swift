import Foundation

struct AppConfig {
    
    let contactUsEmail: String
    let appStoreProductUrl: URL
    let transportAPI: TransportAPI
}

// MARK: - Real instance
extension AppConfig {
    
    // Load config from Main Info plist
    
    static let real: AppConfig = {
        let infoPlistValues = Bundle.main.infoPlistValues(forKey: "appConfig")
        
        let appConfig = AppConfig(
            contactUsEmail: infoPlistValues["contactUsEmail"],
            appStoreProductUrl: infoPlistValues[url: "appStoreProductUrl"],
            transportAPI: .init(
                baseURL: infoPlistValues[url: "transportAPIURL"],
                appID: infoPlistValues["transportAPIAppId"],
                appKey: infoPlistValues["transportAPIAppKey"]
            )
        )
        
        return appConfig
    }()

}


extension AppConfig {
    
    struct TransportAPI {
        let baseURL: URL
        let appID: String
        let appKey: String
    }
}
