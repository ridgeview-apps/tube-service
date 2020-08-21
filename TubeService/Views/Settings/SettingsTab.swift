import ComposableArchitecture

enum SettingsTab: Equatable {
    
    struct ViewState: Equatable {
        var settingsViewState: Settings.ViewState = .init()
    }
    
    typealias State = BaseState<ViewState>

    enum Action: Equatable {
        case settings(Settings.Action)
        case global(Global.Action)
    }
    
    typealias Environment = Root.Environment

    static let reducer = Reducer<State, Action, Environment>.combine(
        
        Global.reducer.pullback(state: \.globalState,
                                action: /Action.global,
                                environment: { $0 }),

        Settings.reducer.pullback(state: \.settingsState,
                                  action: /Action.settings,
                                  environment: { $0 })
    )
}

extension SettingsTab.State {
    
    var settingsState: Settings.State {
        get {
            .init(globalState: globalState, viewState: self.settingsViewState)
        }
        set {
            self.globalState = newValue.globalState
            self.settingsViewState = newValue.viewState
        }
    }
}
