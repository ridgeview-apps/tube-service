import ComposableArchitecture

extension Reducer {
//    func globalMutatingFeature<FeatureState: Equatable>(
//        action: CasePath<Action, GlobalAction>,
//        environment: @escaping (Environment) -> GlobalEnvironment
//    ) -> Reducer where State == Feature<FeatureState> {
//        .combine(
//            globalStateReducer
//                .pullback(state: \.globalState, action: action, environment: environment),
//            self
//        )
//    }
    
//    func sharedStateFeature<FeatureState: Equatable>(
//        mappedTo action: CasePath<Action, Shared.Action>
//    ) -> Reducer where State == BaseState<FeatureState>, Environment == CoreModelEnvironment {
//        .combine(
//            sharedStateReducer
//                .pullback(state: \.globalState,
//                          action: action,
//                          environment: { $0 }),
//            self
//        )
//    }
}
