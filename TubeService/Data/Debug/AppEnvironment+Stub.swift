import Foundation

#if DEBUG
extension AppConfig {
    
    static let stub = AppConfig(
        contactUsEmail: "test@notanemail.com",
        appStoreProductURL: .stub,
        transportAPI: .init(baseURL: .stub,
                            appID: "fakeAPIAppId",
                            appKey: "fakeAPIAppKey"),
        systemStatusAPI: .init(baseURL: .stub,
                               fileName: "dummy.json")
    )
}

private extension URL {
    static let stub = URL(string: "https://fakeurl.com")!
}
#endif
