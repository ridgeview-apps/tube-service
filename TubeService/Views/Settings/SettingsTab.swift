import ComposableArchitecture
import SettingsFeature

enum SettingsTab: Equatable {
    
    // State
    struct State: Equatable {
        var settingsState: Settings.State = .init()
    }

    // Action
    enum Action: Equatable {
        case settings(Settings.Action)
    }
    
    typealias Environment = Root.Environment

    static let reducer = Reducer<State, Action, Environment>.combine(
        
        Settings.reducer.pullback(state: \.settingsState,
                                  action: /Action.settings,
                                  environment: {
                                      .init(mainBundle: $0.mainBundle,
                                            currentLocale: $0.currentLocale,
                                            currentDevice: $0.currentDevice,
                                            featureConfig: .init(contactUsEmail: $0.appConfig.contactUsEmail,
                                                                 appStoreProductUrl: $0.appConfig.appStoreProductUrl))
                                      
                                  })
    )
}
