import ComposableArchitecture
import LiveArrivalsFeature

enum ArrivalsTab {
    
    // State
    struct State: Equatable {
        var arrivalsPickerState: ArrivalsPicker.State = .init()
    }
    
    // Action
    enum Action: Equatable {
        case arrivalsPicker(ArrivalsPicker.Action)
    }
    
    typealias Environment = Root.Environment
    
    // Reducer
    static let reducer = Reducer<State, Action, Environment>.combine(
        
        ArrivalsPicker.reducer.pullback(state: \.arrivalsPickerState,
                                        action: /Action.arrivalsPicker,
                                        environment: {
                                            .init(transportAPI: $0.dataClients.api,
                                                  stationsClient: $0.dataClients.stations,
                                                  userPreferencesClient: $0.dataClients.userPreferences,
                                                  now: $0.date,
                                                  mainQueue: $0.mainQueue)
                                        })
    )
}
