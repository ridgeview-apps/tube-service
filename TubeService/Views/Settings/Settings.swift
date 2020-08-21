import ComposableArchitecture
import DeviceKit

enum Settings {
    
    // State
    struct ViewState: Equatable {
        
        enum BrowserType: Int, Identifiable, CaseIterable, Codable {
            var id: Int { rawValue }
            case external, inApp
        }
        
        var hasLoaded = false
        var selectedBrowserType: BrowserType = .inApp
        var contactUs: ContactUs = .empty
        var appVersionNumber: String = ""
        var submitAppReviewUrl: URL? = nil
        var debug: Debug.State = .init()
    }
    
    typealias State = BaseState<ViewState>
    
    // Action
    enum Action: Equatable {
        case onAppear
        case done
        case select(browserType: ViewState.BrowserType)
        case global(Global.Action)
        case debug(Debug.Action)
    }
    
    // Environment
    typealias Environment = Root.Environment

    static let reducer = Reducer<State, Action, Environment>.combine(
        
        Debug.reducer.pullback(state: \.debug,
                               action: /Action.debug,
                               environment: { $0 }),
        
        Global.reducer.pullback(state: \.globalState,
                                action: /Action.global,
                                environment: { $0 }),
        
        Reducer { state, action, env in
            switch action {
            case .global:
                return .none
            case .onAppear:
                if !state.hasLoaded {
                    state.selectedBrowserType = state.userPreferences.preferredBrowserType
                    state.appVersionNumber = env.mainBundle.appVersionNumber
                    state.contactUs = .init(email: env.appConfig.contactUsEmail,
                                            bundle: env.mainBundle,
                                            device: env.currentDevice,
                                            locale: env.currentLocale,
                                            localizer: env.stringLocalizer)
                    state.submitAppReviewUrl = env.appConfig.submitAppReviewUrl
                    state.hasLoaded = true
                }
                return .none
            case let .select(browserType):
                state.selectedBrowserType = browserType
                var userPrefs = state.userPreferences
                guard userPrefs.preferredBrowserType != browserType else {
                    return .none
                }
                userPrefs.preferredBrowserType = browserType
                return Effect(value: .global(.updateUserPreferences(userPrefs)))
            case .done, .debug:
                return .none
            }
        }
    )
}

extension Settings.ViewState {
 
    struct ContactUs: Equatable {
        let email: String
        let subject: String
        let body: String
        
        static let empty: ContactUs = .init(email: "", subject: "", body: "")
    }
}

private extension AppConfig {
    
    var submitAppReviewUrl: URL {
        var urlComponents = URLComponents(string: appStoreProductUrl.absoluteString)!
        urlComponents.queryItems = [.init(name: "action", value: "write-review")]
        return urlComponents.url!
    }
    
}


private extension Settings.ViewState.ContactUs {
    
    init(email: String,
         bundle: Bundle,
         device: Device,
         locale: Locale,
         localizer: StringLocalizer) {
        self.email = email
        
        self.subject = "\(String(format: localizer.localized("contact.us.subject %@"), bundle.appName))"
        
        self.body =
        """


        \(localizer.localized("contact.us.body.diagnostic.info"))

        \(localizer.localized("contact.us.body.app.version")): \(bundle.appVersionNumber)
        \(localizer.localized("contact.us.body.device.info")): \(device)
        \(localizer.localized("contact.us.body.locale.info")): \(locale.identifier) - \(locale.languageCode ?? "")
        """
    }
}
