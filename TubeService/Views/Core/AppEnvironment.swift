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
    
    static let real: AppEnvironment = {
        let infoPlistValues = Bundle.main.infoPlistValues(forKey: "appEnvironment")
        
        let appEnvironment = AppEnvironment(
            contactUsEmail: infoPlistValues["contactUsEmail"],
            appStoreProductUrl: infoPlistValues[url: "appStoreProductUrl"],
            transportAPI: .init(
                baseURL: infoPlistValues[url: "transportAPIURL"],
                appID: infoPlistValues["transportAPIAppId"],
                appKey: infoPlistValues["transportAPIAppKey"]
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
