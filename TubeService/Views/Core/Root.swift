import Foundation
import ComposableArchitecture
import Combine

enum Root {
    
    struct State: Equatable {
        var hasLoaded = false
        
        var globalState: Global.State = .init()
        
        // Line status tab
        private var lineStatusTabViewState: LineStatusTab.ViewState = .init()
        var lineStatusTabState: LineStatusTab.State {
            get {
                .init(globalState: globalState, viewState: lineStatusTabViewState)
            }
            set {
                self.globalState = newValue.globalState
                self.lineStatusTabViewState = newValue.viewState
            }
        }
        
        // Arrivals tab
        private var arrivalsTabViewState: ArrivalsTab.ViewState = .init()
        var arrivalsTabState: ArrivalsTab.State {
            get {
                .init(globalState: globalState, viewState: arrivalsTabViewState)
            }
            set {
                self.globalState = newValue.globalState
                self.arrivalsTabViewState = newValue.viewState
            }
        }
        
        private var settingsTabViewState: SettingsTab.ViewState = .init()
        var settingsTabState: SettingsTab.State {
            get {
                .init(globalState: globalState, viewState: settingsTabViewState)
            }
            set {
                self.globalState = newValue.globalState
                self.settingsTabViewState = newValue.viewState
            }
        }
    }
    
    enum Action: Equatable {
        case onAppear
        case global(Global.Action)
        case lineStatusTab(LineStatusTab.Action)
        case arrivalsTab(ArrivalsTab.Action)
        case settingsTab(SettingsTab.Action)
    }
    
    typealias Environment = BaseEnvironment<Void>
    
    static let reducer = Reducer<State, Action, Root.Environment>.combine(
        
        Global.reducer.pullback(state: \.globalState,
                                action: /Action.global,
                                environment: { $0 }),
        
        LineStatusTab.reducer.pullback(state: \.lineStatusTabState,
                                       action: /Action.lineStatusTab,
                                       environment: { $0 }),
        
        ArrivalsTab.reducer.pullback(state: \.arrivalsTabState,
                                     action: /Action.arrivalsTab,
                                     environment: { $0 }),
        
        SettingsTab.reducer.pullback(state: \.settingsTabState,
                                     action: /Action.settingsTab,
                                     environment: { $0 }),
        
        Reducer { state, action, environment in
            switch action {
            case .onAppear:
                if !state.hasLoaded {
                    state.hasLoaded = true
                    return Effect(value: .global(.refreshData))
                }
                return .none
            case .global, .lineStatusTab, .arrivalsTab, .settingsTab:
                return .none
            }
        }
    )
}
