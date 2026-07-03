import DataStores
import Foundation

struct AppConfig {

    let contactUsEmail: String
    let appStoreProductURL: URL
    let tflAPI: TflAPIConfig
    let tubeServiceAPI: TubeServiceAPIConfig
    let systemStatusAPI: SystemStatusAPIConfig
    let purchaseProductIDs: PurchaseStore.ProductIDs

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
            if tubeServiceAPI.apiKey.trimmed().isEmpty {
                fatalError("TubeService API key is mandatory on Release builds")
            }
            if purchaseProductIDs.tubeServicePlus.trimmed().isEmpty {
                fatalError("Tube Service Plus product ID is mandatory on Release builds")
            }
            if purchaseProductIDs.tubeServicePlusMonthly.trimmed().isEmpty {
                fatalError("Tube Service Plus monthly product ID is mandatory on Release builds")
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
            tubeServiceAPI: .init(
                baseURL: config[url: "tubeServiceAPIBaseUrl"],
                apiKey: config["tubeServiceAPIKey"],
                appVariant: config["tubeServiceAPIAppVariant"]
            ),
            systemStatusAPI: .init(
                baseURL: config[url: "systemStatusAPIBaseUrl"],
                fileName: config["systemStatusAPIFileName"]
            ),
            purchaseProductIDs: .init(
                tubeServicePlus: config["tubeServicePlusProductID"],
                tubeServicePlusMonthly: config["tubeServicePlusMonthlyProductID"]
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

    struct TubeServiceAPIConfig {
        let baseURL: URL
        let apiKey: String
        let appVariant: String
    }

    struct SystemStatusAPIConfig {
        let baseURL: URL
        let fileName: String
    }
}
