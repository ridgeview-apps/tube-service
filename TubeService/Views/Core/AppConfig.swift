import Foundation

struct AppConfig {
    
    let contactUsEmail: String
    let appStoreProductURL: URL
    let transportAPI: TransportAPIConfig
    
    public var appReviewURL: URL {
        guard var urlComponents = URLComponents(string: appStoreProductURL.absoluteString) else {
            return appStoreProductURL
        }
        urlComponents.queryItems = [.init(name: "action", value: "write-review")]
        return urlComponents.url ?? appStoreProductURL
    }
}

// MARK: - Shared instance

extension AppConfig {
    
    // Load config from Main Info plist
    
    static let shared: AppConfig = {
        let config = Bundle.main.loadInfoPlistConfig(forKey: "appConfig")
        
        let appConfig = AppConfig(
            contactUsEmail: config["contactUsEmail"],
            appStoreProductURL: config[url: "appStoreProductUrl"],
            transportAPI: .init(
                baseURL: config[url: "transportAPIUrl"],
                appID: config["transportAPIAppId"],
                appKey: config["transportAPIAppKey"]
            )
        )
        
        return appConfig
    }()

}

extension AppConfig {
    
    struct TransportAPIConfig {
        let baseURL: URL
        let appID: String
        let appKey: String
    }
}
