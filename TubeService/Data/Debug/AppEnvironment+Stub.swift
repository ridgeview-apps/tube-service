import Foundation

#if DEBUG
extension AppEnvironment {
    
    static let stub = AppEnvironment(
        contactUsEmail: "test@notanemail.com",
        appStoreProductUrl: .stub,
        transportAPI: .init(baseURL: .stub,
                            appID: "fakeAPIAppId",
                            appKey: "fakeAPIAppKey"),
        userDefaults: .standard
    )
}

private extension URL {
    static let stub = URL(string: "https://fakeurl.com")!
}
#endif
