import ComposableArchitecture
import AppCenterCrashes

enum Debug {
    struct State: Equatable {}
    
    enum Action {
        case testCrashReporting
    }
    
    typealias Environment = Root.Environment
    
    static let reducer = Reducer<State, Action, Environment> { state, action, environment in
        switch action {
        case .testCrashReporting:
            Crashes.generateTestCrash()
            return .none
        }
    }
}
