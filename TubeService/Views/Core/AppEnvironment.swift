import Foundation

struct AppEnvironment {
    
    let contactUsEmail: String
    let appStoreProductUrl: URL
    let transportAPI: TransportAPI
    
    public var appReviewURL: URL {
        guard var urlComponents = URLComponents(string: appStoreProductUrl.absoluteString) else {
            return appStoreProductUrl
        }
        urlComponents.queryItems = [.init(name: "action", value: "write-review")]
        return urlComponents.url ?? appStoreProductUrl
    }
}

// MARK: - Real instance
extension AppEnvironment {
    
    // Load config from Main Info plist
    
    static let shared: AppEnvironment = {
        let config = Bundle.main.loadInfoPlistConfig(forKey: "appEnvironment")
        
        let appEnvironment = AppEnvironment(
            contactUsEmail: config["contactUsEmail"],
            appStoreProductUrl: config[url: "appStoreProductUrl"],
            transportAPI: .init(
                baseURL: config[url: "transportAPIURL"],
                appID: config["transportAPIAppId"],
                appKey: config["transportAPIAppKey"]
            )
        )
        
        return appEnvironment
    }()

}


extension AppEnvironment {
    
    struct TransportAPI {
        let baseURL: URL
        let appID: String
        let appKey: String
    }
}
