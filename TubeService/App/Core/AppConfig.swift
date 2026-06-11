import Foundation

struct AppConfig {

    let contactUsEmail: String
    let appStoreProductURL: URL
    let tflAPI: TflAPIConfig
    let systemStatusAPI: SystemStatusAPIConfig

    var appReviewURL: URL {
        guard var urlComponents = URLComponents(string: appStoreProductURL.absoluteString) else {
            return appStoreProductURL
        }
        urlComponents.queryItems = [.init(name: "action", value: "write-review")]
        return urlComponents.url ?? appStoreProductURL
    }

    func validate() {
        #if !DEBUG
            if tflAPI.appKey.trimmed().isEmpty {
                fatalError("Tfl API key is mandatory on Release builds")
            }
        #endif
    }
}

// MARK: - Shared instance

extension AppConfig {

    // Load config from Main Info plist

    static let main: AppConfig = {
        let config = Bundle.main.loadInfoPlistConfig(forKey: "appConfig")

        let appConfig = AppConfig(
            contactUsEmail: config["contactUsEmail"],
            appStoreProductURL: config[url: "appStoreProductUrl"],
            tflAPI: .init(
                baseURL: config[url: "tflAPIBaseUrl"],
                appKey: config["tflAPIAppKey"]
            ),
            systemStatusAPI: .init(
                baseURL: config[url: "systemStatusAPIBaseUrl"],
                fileName: config["systemStatusAPIFileName"]
            )
        )

        appConfig.validate()

        return appConfig
    }()
}

extension AppConfig {

    struct TflAPIConfig {
        let baseURL: URL
        let appKey: String
    }

    struct SystemStatusAPIConfig {
        let baseURL: URL
        let fileName: String
    }
}
