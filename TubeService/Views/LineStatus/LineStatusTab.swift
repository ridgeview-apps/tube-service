import ComposableArchitecture

enum LineStatusTab: Equatable {
    
    // State
    struct ViewState: Equatable {
        var lineStatusListViewState: LineStatusList.ViewState = .init()
    }
    
    typealias State = BaseState<ViewState>

    // Action
    enum Action: Equatable {
        case lineStatusList(LineStatusList.Action)
        case global(Global.Action)
    }
    
    // Environment
    typealias Environment = Root.Environment

    static let reducer = Reducer<State, Action, Environment>.combine(
        
        Global.reducer.pullback(state: \.globalState,
                                action: /Action.global,
                                environment: { $0 }),

        LineStatusList.reducer.pullback(state: \.lineStatusListState,
                                        action: /Action.lineStatusList,
                                        environment: { $0 })
    )
}

extension LineStatusTab.State {
    
    var lineStatusListState: LineStatusList.State {
        get {
            .init(globalState: globalState, viewState: self.lineStatusListViewState)
        }
        set {
            self.globalState = newValue.globalState
            self.lineStatusListViewState = newValue.viewState            
        }
    }
}
