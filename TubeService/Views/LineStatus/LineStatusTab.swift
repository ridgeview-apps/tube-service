import ComposableArchitecture
import LineStatusFeature

enum LineStatusTab: Equatable {
    
    // State
    struct State: Equatable {
        var lineStatusListState: LineStatusList.State  = .init()
    }

    // Action
    enum Action: Equatable {
        case lineStatusList(LineStatusList.Action)
    }
    
    // Environment
    typealias Environment = Root.Environment

    static let reducer = Reducer<State, Action, Environment>.combine(
        
        LineStatusList.reducer.pullback(
            state: \.lineStatusListState,
            action: /Action.lineStatusList,
            environment: {
                .init(transportAPI: $0.dataClients.api,
                      now: $0.date,
                      mainQueue: $0.mainQueue)
            }
        )
    )
}
