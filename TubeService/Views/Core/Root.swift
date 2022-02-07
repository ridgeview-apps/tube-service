import Foundation
import ComposableArchitecture
import Combine
import LineStatusFeature

enum Root {
    
    struct State: Equatable {
        var hasLoaded = false
        
        var lineStatusTabState: LineStatusTab.State = .init()
        var arrivalsTabState: ArrivalsTab.State = .init()
        var settingsTabState: SettingsTab.State = .init()
    }
    
    enum Action: Equatable {
        case onAppear
        case lineStatusTab(LineStatusTab.Action)
        case arrivalsTab(ArrivalsTab.Action)
        case settingsTab(SettingsTab.Action)
    }
    
    typealias Environment = BaseEnvironment<Void>
    
    static let reducer = Reducer<State, Action, Root.Environment>.combine(
        
        LineStatusTab.reducer.pullback(state: \.lineStatusTabState,
                                       action: /Action.lineStatusTab,
                                       environment: { $0 }),
        
        ArrivalsTab.reducer.pullback(state: \.arrivalsTabState,
                                     action: /Action.arrivalsTab,
                                     environment: { $0 }),
        
        SettingsTab.reducer.pullback(state: \.settingsTabState,
                                     action: /Action.settingsTab,
                                     environment: { $0 })
    )
}
