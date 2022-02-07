import Foundation
import RidgeviewCore

struct AppConfig {
    
    let contactUsEmail: String
    let appStoreProductUrl: URL
    let appCenter: AppCenter
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
            appCenter: .init(
                appSecret: infoPlistValues["appCenterAppSecret"]
            ),
            transportAPI: .init(
                baseURL: infoPlistValues[url: "transportAPIURL"],
                appId: infoPlistValues["transportAPIAppId"],
                appKey: infoPlistValues["transportAPIAppKey"]
            )
        )
        
        return appConfig
    }()

}

// MARK: - Fake instance
#if DEBUG
extension AppConfig {
    
    static let fake = AppConfig(contactUsEmail: "test@notanemail.com",
                                appStoreProductUrl: .fake,
                                appCenter: .init(appSecret: "fakeAppCenterSecret"),
                                transportAPI: .init(baseURL: .fake,
                                                    appId: "fakeAPIAppId",
                                                    appKey: "fakeAPIAppKey"))
}
#endif

private extension URL {
    static let fake = URL(string: "https://fakeurl.com")!
}

extension AppConfig {
    
    struct AppCenter {
        let appSecret: String
    }
    
    struct TransportAPI {
        let baseURL: URL
        let appId: String
        let appKey: String
    }
}
