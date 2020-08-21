import ComposableArchitecture

enum ArrivalsBoardsList {
    
    struct Id: Equatable, Hashable {
        var station: Station
        var arrivalsGroup: Station.ArrivalsGroup
    }
    
    struct ViewState: Equatable {
        var id: Id
        var lastRefreshedAt: Date?
        var isRefreshing = false
        var isAutoRefreshTimerActive = false
        var boards: IdentifiedArrayOf<ArrivalsBoard.ViewState> = []
        var errorMessage: String?
        
        var boardDataUnavailable: Bool {
            lastRefreshedAt != nil && boards.isEmpty
        }
        
        var station: Station { id.station }
        var arrivalsGroup: Station.ArrivalsGroup { id.arrivalsGroup }
        
        var sectionTitle: String = ""
    }
    
    typealias State = BaseState<ViewState>

    enum Action: Equatable {
        case onAppear
        case onDisappear
        case startAutoRefreshTimer
        case cancelAutoRefreshTimer
        case refresh
        case arrivalsResponse(Result<[Arrival], TransportAPI.APIFailure>)
        case tapFavourite(Bool)
        case arrivalsBoard(id: ArrivalsBoard.ViewState.ID, action: ArrivalsBoard.Action)
        case setEachBoardAnimationState(to: ArrivalsBoard.ViewState.AnimationState)
        case global(Global.Action)
    }
    
    typealias Environment = Root.Environment
     
    static let reducer = Reducer<State, Action, Environment>.combine(
            
        Global.reducer.pullback(state: \.globalState,
                                action: /Action.global,
                                environment: { $0 }),

        
        ArrivalsBoard.reducer.forEach(
            state: \.boards,
            action: /Action.arrivalsBoard(id:action:),
            environment: { $0 }
        ),
            
        Reducer { state, action, environment in
            struct TimerId: Hashable {}
            
            switch action {
            case .onAppear:
                return Effect.merge(
                    Effect(value: .setEachBoardAnimationState(to: .rotating)),
                    Effect(value: .startAutoRefreshTimer)                    
                )
            case .onDisappear:
                return Effect.merge(
                    Effect(value: .cancelAutoRefreshTimer),
                    Effect(value: .setEachBoardAnimationState(to: .stopped))                    
                )
            case .startAutoRefreshTimer:
                state.isAutoRefreshTimerActive = true
                
                let autoRefreshTimer = Effect.timer(id: TimerId(),
                                                    every: 20,
                                                    tolerance: .zero,
                                                    on: environment.mainQueue)
                                             .map { _ in Action.refresh }
                
                let lastRefreshedAt = state.lastRefreshedAt ?? .distantPast
                let now = environment.date()
                
                if Date.timeDiff(between: now, and: lastRefreshedAt) > 20.seconds {
                    return .concatenate(Effect(value: .refresh), autoRefreshTimer)
                }
                return autoRefreshTimer
            case .cancelAutoRefreshTimer:
                state.isAutoRefreshTimerActive = false
                return Effect.cancel(id: TimerId())
            case .refresh:
                guard !state.isRefreshing else {
                    return .none
                }
                state.isRefreshing = true
                
                let fetchData = environment.dataServices.api
                    .arrivals(ArrivalsRequest(arrivalsGroup: state.arrivalsGroup))
                    .receive(on: environment.mainQueue)
                    .catchToEffect()
                    .map(Action.arrivalsResponse)
                
                return .concatenate(Effect(value: .setEachBoardAnimationState(to: .refreshing)), fetchData)
            case let .setEachBoardAnimationState(toState):
                let animationStates = state.boards.map {
                    Effect<Action, Never>(value: Action.arrivalsBoard(id: $0.id, action: .setAnimationState(to: toState)))
                }
                return .concatenate(animationStates)
            case var .arrivalsResponse(.success(arrivals)):
                let refreshTime = environment.date()
                state.lastRefreshedAt = refreshTime
                
                state.isRefreshing = false
                state.sectionTitle = state.arrivalsGroup.title
                if let refreshedAtText = Formatter.relativeDateTime.string(for: refreshTime) {
                    state.sectionTitle.append(" (\(refreshedAtText))")
                }
                state.errorMessage = nil
                state.boards = arrivals.asBoards(station: state.station,
                                                 oldValues: state.boards,
                                                 refreshTime: refreshTime,
                                                 localizer: environment.stringLocalizer)
                
                return Effect(value: .setEachBoardAnimationState(to: .rotating))
            case let .arrivalsResponse(.failure(error)):
                state.isRefreshing = false
                state.errorMessage = error.localizedDescription
                return Effect(value: .setEachBoardAnimationState(to: .rotating))
            case let .tapFavourite(isFavourite):
                let boardGroup = state.viewState.arrivalsGroup
                if isFavourite {
                    return Effect(value: .global(.addFavourite(boardGroup)))
                } else {
                    return Effect(value: .global(.removeFavourite(boardGroup)))
                }
            case .global, .arrivalsBoard:
                return .none
            }
        }
    )
}

extension ArrivalsBoardsList.State {
    var isFavourite: Bool {
        globalState.userPreferences.favourites.contains(viewState.arrivalsGroup.id)
    }
}

private extension Array where Element == Arrival {
    func asBoards(station: Station,
                  oldValues: IdentifiedArrayOf<ArrivalsBoard.ViewState>,
                  refreshTime: Date,
                  localizer: StringLocalizer) -> IdentifiedArrayOf<ArrivalsBoard.ViewState> {
        let sortedArrivals = self.sortedByArrivalTime()
        
        let platformGroups = Dictionary(grouping: sortedArrivals, by: { $0.platformName })
        
        let sortedBoards = platformGroups.map { platformName, arrivals -> ArrivalsBoard.ViewState in
            let boardId = "\(station.name)-\(platformName)"
            return ArrivalsBoard.ViewState(station: station,
                                       arrivals: arrivals,
                                       time: refreshTime,
                                       localizer: localizer,
                                       rotatingRowIndex: oldValues[id: boardId]?.rotatingRowIndex,
                                       isExpanded: oldValues[id: boardId]?.isExpanded ?? false)
        }.sorted {
            $0.platformTitleText < $1.platformTitleText
        }
        
        return IdentifiedArrayOf(sortedBoards)
    }
    
    func sortedByArrivalTime() -> [Arrival] {
        self.sorted { lhs, rhs in
            lhs.timeToStation ?? 0 < rhs.timeToStation ?? 0
        }
    }
}
