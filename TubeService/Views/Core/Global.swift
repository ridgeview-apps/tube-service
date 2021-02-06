import ComposableArchitecture
import Combine

enum Global {
    
    struct State: Equatable {
        var userPreferences: UserPreferences = .empty
    }
    
    enum Action: Equatable {
        case refreshData
        case didRefreshData(UserPreferences)
        case addFavourite(Station.ArrivalsGroup)
        case removeFavourite(Station.ArrivalsGroup)
        case updateUserPreferences(UserPreferences)
        case didUpdateUserPreferences(UserPreferences)
    }
    
    typealias Environment = Root.Environment
    
    static let reducer = Reducer<State, Action, Environment> { state, action, environment in
        switch action {
        case .refreshData:
            let userPreferences = environment.dataServices.userPreferences.load()
            
            return userPreferences
                    .map(Action.didRefreshData)
                    .eraseToEffect()
        case let .didRefreshData(userPreferences):
            state.userPreferences = userPreferences
            return .none
        case let .addFavourite(favourite):
            var userPreferences = state.userPreferences
            userPreferences.favourites.insert(favourite.id)
            return Effect(value: .updateUserPreferences(userPreferences))
        case let .removeFavourite(favourite):
            var userPreferences = state.userPreferences
            userPreferences.favourites.remove(favourite.id)
            return Effect(value: .updateUserPreferences(userPreferences))
        case let .updateUserPreferences(userPreferences):
            return environment.dataServices.userPreferences
                    .update(userPreferences: userPreferences)
                    .map(Action.didUpdateUserPreferences)
        case let .didUpdateUserPreferences(userPreferences):
            state.userPreferences = userPreferences
            return .none
        }
    }
}

@dynamicMemberLookup
struct BaseState<State: Equatable>: Equatable {
    var globalState: Global.State // Global state shared across the whole app
    var viewState: State // State specific to the current view
    
    subscript<Value>(dynamicMember keyPath: KeyPath<Global.State, Value>) -> Value {
        get { self.globalState[keyPath: keyPath] }
    }
    
    subscript<Value>(dynamicMember keyPath: WritableKeyPath<Global.State, Value>) -> Value {
        get { self.globalState[keyPath: keyPath] }
        set { self.globalState[keyPath: keyPath] = newValue }
    }
    
    subscript<Value>(dynamicMember keyPath: KeyPath<State, Value>) -> Value {
        get { self.viewState[keyPath: keyPath] }
    }
    
    subscript<Value>(dynamicMember keyPath: WritableKeyPath<State, Value>) -> Value {
        get { self.viewState[keyPath: keyPath] }
        set { self.viewState[keyPath: keyPath] = newValue }
    }
}

@dynamicMemberLookup
struct IdentifiableState<ViewState: Equatable>: Equatable, Identifiable where ViewState: Identifiable {

    var id: ViewState.ID { baseState.viewState.id }
    var baseState: BaseState<ViewState>
    
    init(globalState: Global.State, viewState: ViewState) {
        baseState = .init(globalState: globalState, viewState: viewState)
    }
    
    subscript<Value>(dynamicMember keyPath: KeyPath<BaseState<ViewState>, Value>) -> Value {
        get { self.baseState[keyPath: keyPath] }
    }
    
    subscript<Value>(dynamicMember keyPath: WritableKeyPath<BaseState<ViewState>, Value>) -> Value {
        get { self.baseState[keyPath: keyPath] }
        set { self.baseState[keyPath: keyPath] = newValue }
    }
}
