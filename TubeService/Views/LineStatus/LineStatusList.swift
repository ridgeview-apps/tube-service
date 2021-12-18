import ComposableArchitecture
import Model

enum LineStatusList: Equatable {
    
    // State
    struct ViewState: Equatable {
        
        struct RowSelection: Equatable {
            var id: LineStatusDetail.State.ID?
            var navigationStates = IdentifiedArrayOf<LineStatusDetail.State>()

            mutating func setNavigationState(to destinationViewState: LineStatusDetail.State?) {
                if let destinationViewState = destinationViewState {
                    id = destinationViewState.id
                    if navigationStates[id: destinationViewState.id] != nil {
                        navigationStates.remove(id: destinationViewState.id)
                    }
                    navigationStates.append(destinationViewState)
                } else {
                    self.navigationStates = navigationStates.filter { $0.id == self.id }
                    id = nil
                }
            }
        }
        
        var lastRefreshedAt: Date?
        var isRefreshing: Bool = false
        var navigationBarTitle = ""
        var statuses: IdentifiedArrayOf<LineStatus> = []
        var errorMessage: String?
        var isShowingSettings: Bool = false
        var lastRefreshedAtText: String = ""
        var rowSelection: RowSelection = .init()
    }
    
    typealias State = BaseState<ViewState>
    
    // Action
    enum Action: Equatable {
        case onAppear
        case autoRefreshIfNeeded
        case refresh
        case setRefreshing(Bool)
        case selectRow(LineStatusDetail.State.ID?)
        case lineStatusesResponse(Result<[LineStatus], TransportAPI.APIFailure>)
        case lineStatusDetail(id: LineStatusDetail.State.ID, action: LineStatusDetail.Action)
        case global(Global.Action)
    }
    
    // Environment
    typealias Environment = Root.Environment

    static let reducer = Reducer<State, Action, Environment>.combine(
        
        Global.reducer.pullback(state: \.globalState,
                                action: /Action.global,
                                environment: { $0 }),
        
        LineStatusDetail.reducer.forEach(state: \.rowSelection.navigationStates,
                                         action: /Action.lineStatusDetail,
                                         environment: { $0 }),
        
        Reducer { state, action, environment in
            switch action {
            case .onAppear:
                state.navigationBarTitle = environment.stringLocalizer.localized("status.navigation.title")
                return Effect(value: .autoRefreshIfNeeded)
            case .autoRefreshIfNeeded:
                guard !state.isRefreshing else {
                    return .none
                }
                let lastRefreshedAt = state.lastRefreshedAt ?? Date.distantPast
                let now = environment.date()
                guard Date.timeDiff(between: now, and: lastRefreshedAt) > 5.minutes else {
                    return .none
                }
                return Effect(value: .refresh)
            case .refresh:
                state.isRefreshing = true
                return environment.dataServices.api.lineStatuses()
                    .receive(on: environment.mainQueue)
                    .catchToEffect()
                    .map(Action.lineStatusesResponse)
            case let .lineStatusesResponse(.success(lineStatuses)):
                state.isRefreshing = false
                let refreshTime = environment.date()
                state.lastRefreshedAt = refreshTime
                state.lastRefreshedAtText = Formatter.relativeDateTime.string(for: refreshTime) ?? ""
                state.statuses = IdentifiedArrayOf(uniqueElements: lineStatuses.sortedByStatusThenName())
                state.errorMessage = nil
                return .none
            case let .lineStatusesResponse(.failure(error)):
                state.errorMessage = error.localizedDescription
                state.isRefreshing = false
                return .none
            case let .setRefreshing(isRefreshing):
                state.isRefreshing = isRefreshing
                return .none
            case let .selectRow(rowId):
                guard state.rowSelection.id != rowId else {
                    return .none
                }
                if let rowId = rowId, let lineStatus = state.statuses[id: rowId] {
                    let navigationState = LineStatusDetail.State(globalState: state.globalState,
                                                                 viewState: .init(lineStatus: lineStatus))
                    state.rowSelection.setNavigationState(to: navigationState)
                } else {
                    state.rowSelection.setNavigationState(to: nil)
                }
                return .none
            case .global, .lineStatusDetail:
                return .none
            }
        })
}
