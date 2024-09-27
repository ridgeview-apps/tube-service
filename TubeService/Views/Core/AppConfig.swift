import Foundation

struct AppConfig {
    
    let contactUsEmail: String
    let appStoreProductURL: URL
    let transportAPI: TransportAPIConfig
    let systemStatusAPI: SystemStatusAPIConfig
    
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
                baseURL: config[url: "transportAPIBaseUrl"],
                appID: config["transportAPIAppId"],
                appKey: config["transportAPIAppKey"]
            ),
            systemStatusAPI: .init(
                baseURL: config[url: "systemStatusAPIBaseUrl"],
                fileName: config["systemStatusAPIFileName"]
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
    
    struct SystemStatusAPIConfig {
        let baseURL: URL
        let fileName: String
    }
}
