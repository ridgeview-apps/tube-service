import Foundation

struct AppConfig {
    
    let contactUsEmail: String
    let appStoreProductUrl: URL
    let appCenter: AppCenter
    let transportAPI: TransportAPI
}

// MARK: - Real instance
extension AppConfig {
    
    // Load config from build settings
    static let real = AppConfig(contactUsEmail: BuildSettings.CONTACT_US_EMAIL,
                                appStoreProductUrl: BuildSettings.APP_STORE_PRODUCT_URL,
                                appCenter: .init(appSecret: BuildSettings.APPCENTER_APP_SECRET),
                                transportAPI: .init(baseURL: BuildSettings.TRANSPORT_API_URL,
                                                    appId: BuildSettings.TRANSPORT_API_APP_ID,
                                                    appKey: BuildSettings.TRANSPORT_API_APP_KEY))

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
    static let fake = URL(string: "https://httpbin.org")!
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
