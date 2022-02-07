import ComposableArchitecture
import Model
import DeviceKit

public enum Settings {

    // State
    public struct State: Equatable {

        public var hasLoaded = false
        public var contactUs: ContactUs
        public var appVersionNumber: String = ""
        public var submitAppReviewUrl: URL? = nil
        
        public init(
            contactUs: ContactUs = .empty,
            appVersionNumber: String = "",
            submitAppReviewUrl: URL? = nil
        ) {
            self.contactUs = contactUs
            self.appVersionNumber = appVersionNumber
            self.submitAppReviewUrl = submitAppReviewUrl
        }
    }

    // Action
    public enum Action: Equatable {
        case onAppear
        case testCrashReporting
    }

    // Environment
    public struct Environment {
        public struct FeatureConfig {
            public var contactUsEmail: String
            public var appStoreProductUrl: URL
            
            public init(contactUsEmail: String,
                        appStoreProductUrl: URL) {
                self.contactUsEmail = contactUsEmail
                self.appStoreProductUrl = appStoreProductUrl
            }
        }
        
        var mainBundle: Bundle
        var currentLocale: Locale
        var currentDevice: Device
        var featureConfig: FeatureConfig
        
        public init(mainBundle: Bundle,
                    currentLocale: Locale,
                    currentDevice: Device,
                    featureConfig: Settings.Environment.FeatureConfig) {
            self.mainBundle = mainBundle
            self.currentLocale = currentLocale
            self.currentDevice = currentDevice
            self.featureConfig = featureConfig
        }
    }

    public static let reducer = Reducer<State, Action, Environment>.combine(

        Reducer { state, action, env in
            switch action {
            case .onAppear:
                if !state.hasLoaded {
                    state.appVersionNumber = env.mainBundle.appVersionNumber
                    state.contactUs = .init(emailAddress: env.featureConfig.contactUsEmail,
                                            appVersion: env.mainBundle.appVersionNumber,
                                            appName: env.mainBundle.appName,
                                            deviceInfo: env.currentDevice,
                                            localeInfo: "\(env.currentLocale.identifier) - \(env.currentLocale.languageCode ?? ""))")
                    state.submitAppReviewUrl = env.featureConfig.submitAppReviewUrl
                    state.hasLoaded = true
                }
                return .none
            case .testCrashReporting:
                fatalError("Crash report test - please ignore.")                
            }
        }
    )
}

public extension Settings.State {

    struct ContactUs: Equatable {
        public let emailAddress: String
        public let appVersion: String
        public let appName: String
        public let deviceInfo: Device
        public let localeInfo: String

        public static let empty: ContactUs = .init(emailAddress: "",
                                                   appVersion: "",
                                                   appName: "",
                                                   deviceInfo: .iPhone13Pro,
                                                   localeInfo: "")
    }
}

private extension Settings.Environment.FeatureConfig {

    var submitAppReviewUrl: URL {
        var urlComponents = URLComponents(string: appStoreProductUrl.absoluteString)!
        urlComponents.queryItems = [.init(name: "action", value: "write-review")]
        return urlComponents.url!
    }

}
