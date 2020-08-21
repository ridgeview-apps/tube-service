import ComposableArchitecture

enum ArrivalsTab {
    
    // State
    struct ViewState: Equatable {
        var arrivalsPickerViewState: ArrivalsPicker.ViewState = .init(selectedFilterOption: .all)
    }
    
    typealias State = BaseState<ViewState>
    
    // Action
    enum Action: Equatable {
        case global(Global.Action)
        case arrivalsPicker(ArrivalsPicker.Action)
    }
    
    typealias Environment = Root.Environment
    
    // Reducer
    static let reducer = Reducer<State, Action, Environment>.combine(
        
        Global.reducer.pullback(state: \.globalState,
                                action: /Action.global,
                                environment: { $0 }),
        
        ArrivalsPicker.reducer.pullback(state: \.arrivalsPickerState,
                                        action: /Action.arrivalsPicker,
                                        environment: { $0 })
    )
}


extension ArrivalsTab.State {
    
    var arrivalsPickerState: ArrivalsPicker.State {
        get {
            .init(globalState: globalState, viewState: self.arrivalsPickerViewState)
        }
        set {
            self.globalState = newValue.globalState
            self.arrivalsPickerViewState = newValue.viewState            
        }
    }

}
