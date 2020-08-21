import ComposableArchitecture

enum LineStatusList: Equatable {
    
    // State
    struct ViewState: Equatable {
        
        struct RowSelection: Equatable {
            var id: LineStatus.ID? = nil
            var lineStatusDetailViewState: LineStatusDetail.ViewState = .placeholder
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
        case selectRow(LineStatus.ID?)
        case lineStatusesResponse(Result<[LineStatus], TransportAPI.APIFailure>)
        case lineStatusDetail(LineStatusDetail.Action)
        case global(Global.Action)
    }
    
    // Environment
    typealias Environment = Root.Environment

    static let reducer = Reducer<State, Action, Environment>.combine(
        
        Global.reducer.pullback(state: \.globalState,
                                action: /Action.global,
                                environment: { $0 }),
        
        LineStatusDetail.reducer.pullback(state: \.lineStatusDetailState,
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
                state.statuses = IdentifiedArrayOf(lineStatuses.sortedByStatusThenName())
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
                state.rowSelection.id = rowId
                if let rowId = rowId, let lineStatus = state.statuses[id: rowId] {
                    state.rowSelection.lineStatusDetailViewState = .init(lineStatus: lineStatus)
                }
                return .none
            case .global, .lineStatusDetail:
                return .none
            }
        })
}

extension LineStatusList.State {
    
    var lineStatusDetailState: LineStatusDetail.State {
        get {
            .init(globalState: globalState, viewState: self.rowSelection.lineStatusDetailViewState)
        }
        set {
            self.globalState = newValue.globalState
            self.rowSelection.lineStatusDetailViewState = newValue.viewState
        }
    }
}
