import ComposableArchitecture
import DataClients
import Model
import Shared

public enum ArrivalsBoardsList {
    
    public struct Id: Equatable, Hashable {
        public var station: Station
        public var arrivalsGroup: Station.ArrivalsGroup
        
        public init(station: Station,
                    arrivalsGroup: Station.ArrivalsGroup) {
            self.station = station
            self.arrivalsGroup = arrivalsGroup
        }
    }
    
    // MARK: - State
    public struct State: Identifiable, Equatable {
        public var id: Id
        public var isFavourite: Bool
        public var lastRefreshedAt: Date?
        public var isRefreshing: Bool = false
        public var isAutoRefreshTimerActive = false
        public var boards: IdentifiedArrayOf<ArrivalsBoard.State> = []
        public var errorMessage: String?
        
        public var boardDataUnavailable: Bool {
            lastRefreshedAt != nil && boards.isEmpty
        }
        
        public var station: Station { id.station }
        public var arrivalsGroup: Station.ArrivalsGroup { id.arrivalsGroup }
        
        public var sectionTitle: String = ""
        
        public init(
            id: ArrivalsBoardsList.Id,
            isFavourite: Bool,
            lastRefreshedAt: Date? = nil,
            isRefreshing: Bool = false,
            isAutoRefreshTimerActive: Bool = false,
            boards: IdentifiedArrayOf<ArrivalsBoard.State> = [],
            errorMessage: String? = nil,
            sectionTitle: String = ""
        ) {
            self.id = id
            self.isFavourite = isFavourite
            self.lastRefreshedAt = lastRefreshedAt
            self.isRefreshing = isRefreshing
            self.isAutoRefreshTimerActive = isAutoRefreshTimerActive
            self.boards = boards
            self.errorMessage = errorMessage
            self.sectionTitle = sectionTitle
        }
    }
    
    // MARK: - Action
    public enum Action: Equatable {
        case onAppear
        case onDisappear
        case startAutoRefreshTimer
        case cancelAutoRefreshTimer
        case refresh
        case arrivalsResponse(Result<[Arrival], TransportAPIClient.APIFailure>)
        case arrivalDeparturesResponse(Result<[ArrivalDeparture], TransportAPIClient.APIFailure>)
        case tapFavourite(Bool)
        case arrivalsBoard(id: ArrivalsBoard.State.ID, action: ArrivalsBoard.Action)
        case setEachBoardAnimationState(to: ArrivalsBoard.State.AnimationState)
        case rotateEachBoard
    }
    
    // MARK: - Environment
    public struct Environment {
        public var transportAPI: TransportAPIClient
        public var now: () -> Date
        public var mainQueue: AnySchedulerOf<DispatchQueue>
        
        public init(transportAPI: TransportAPIClient,
                    now: @escaping () -> Date,
                    mainQueue: AnySchedulerOf<DispatchQueue>) {
            self.transportAPI = transportAPI
            self.now = now
            self.mainQueue = mainQueue
        }
    }
     
    public static let reducer = Reducer<State, Action, Environment>.combine(
            
        ArrivalsBoard.reducer.forEach(
            state: \.boards,
            action: /Action.arrivalsBoard(id:action:),
            environment: {
                .init(mainQueue: $0.mainQueue)
            }
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
                let now = environment.now()
                
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
                
                let fetchData: Effect<Action, Never>
                
                switch state.arrivalsGroup.boardType {
                case .arrivalPredictions:
                    fetchData = environment.transportAPI
                        .arrivals(ArrivalsRequest(arrivalsGroup: state.arrivalsGroup))
                        .receive(on: environment.mainQueue)
                        .catchToEffect()
                        .map(Action.arrivalsResponse)
                case .arrivalDepartures:
                    fetchData = environment.transportAPI
                        .arrivalDepartures(ArrivalDeparturesRequest(arrivalsGroup: state.arrivalsGroup))
                        .receive(on: environment.mainQueue)
                        .catchToEffect()
                        .map(Action.arrivalDeparturesResponse)
                }
                
                
                return .concatenate(Effect(value: .setEachBoardAnimationState(to: .refreshing)),
                                    fetchData)
            case let .setEachBoardAnimationState(toState):
                let eachAnimationState = state.boards.map {
                    Effect<Action, Never>(value: Action.arrivalsBoard(id: $0.id, action: .setAnimationState(to: toState)))
                }
                
                let rotationTimerId = "RotationTimer-\(state.id)"
                switch toState {
                case .refreshing, .stopped:
                    let stopRotationTimer = Effect<Action, Never>.cancel(id: rotationTimerId)
                    return .concatenate([stopRotationTimer] + eachAnimationState)
                case .rotating:
                    let startRotationTimer = Effect.timer(id: rotationTimerId,
                                                          every: 3,
                                                          tolerance: .zero,
                                                          on: environment.mainQueue)
                                                    .map { _ in Action.rotateEachBoard }
                    return .concatenate(eachAnimationState + [startRotationTimer])
                }
            case .rotateEachBoard:
                let eachRotationAction = state.boards.map {
                    Effect<Action, Never>(value: Action.arrivalsBoard(id: $0.id, action: .rotateNextArrival))
                }
                return .concatenate(eachRotationAction)
            case let .arrivalsResponse(.success(arrivals)):
                let refreshTime = environment.now()
                state.lastRefreshedAt = refreshTime
                
                state.isRefreshing = false
                state.sectionTitle = state.arrivalsGroup.title
                if let refreshedAtText = Formatter.mediumRelativeDateTimeStyle.string(for: refreshTime) {
                    state.sectionTitle.append(" (\(refreshedAtText))")
                }
                state.errorMessage = nil
                state.boards = arrivals.asBoards(station: state.station,
                                                 oldValues: state.boards,
                                                 refreshTime: refreshTime)
                
                return Effect(value: .setEachBoardAnimationState(to: .rotating))
            case let .arrivalsResponse(.failure(error)):
                state.isRefreshing = false
                state.errorMessage = error.localizedDescription
                return Effect(value: .setEachBoardAnimationState(to: .rotating))
                
            case let .arrivalDeparturesResponse(.success(arrivalDepartures)):
                let refreshTime = environment.now()
                state.lastRefreshedAt = refreshTime
                
                state.isRefreshing = false
                state.sectionTitle = state.arrivalsGroup.title
                if let refreshedAtText = Formatter.mediumRelativeDateTimeStyle.string(for: refreshTime) {
                    state.sectionTitle.append(" (\(refreshedAtText))")
                }
                state.errorMessage = nil
                state.boards = arrivalDepartures.asBoards(station: state.station,
                                                          oldValues: state.boards,
                                                          refreshTime: refreshTime,
                                                          lineId: state.arrivalsGroup.arrivalDeparturesLineId)
                
                return Effect(value: .setEachBoardAnimationState(to: .rotating))
            case let .arrivalDeparturesResponse(.failure(error)):
                state.isRefreshing = false
                state.errorMessage = error.localizedDescription
                return Effect(value: .setEachBoardAnimationState(to: .rotating))
            case let .tapFavourite(isFavourite):
                let boardGroup = state.arrivalsGroup
                state.isFavourite = isFavourite
                return .none
            case .arrivalsBoard:
                return .none
            }
        }
    )
}

private extension Array where Element == Arrival {
    func asBoards(station: Station,
                  oldValues: IdentifiedArrayOf<ArrivalsBoard.State>,
                  refreshTime: Date) -> IdentifiedArrayOf<ArrivalsBoard.State> {
        let sortedArrivals = self.sortedByArrivalTime()
        
        let platformGroups = Dictionary(grouping: sortedArrivals, by: { $0.platformName })
        
        let sortedBoards = platformGroups.map { platformName, arrivals -> ArrivalsBoard.State in
            let boardId = "\(station.name)-\(platformName)"
            return ArrivalsBoard.State(station: station,
                                       rowTypes: arrivals.map { .prediction($0) },
                                       time: refreshTime,
                                       rotatingRowIndex: oldValues[id: boardId]?.rotatingRowIndex,
                                       isExpanded: oldValues[id: boardId]?.isExpanded ?? false,
                                       manualRotationTimer: true)
        }.sorted {
            $0.platformTitleText < $1.platformTitleText
        }
        
        return IdentifiedArrayOf(uniqueElements: sortedBoards)
    }
    
    func sortedByArrivalTime() -> [Arrival] {
        self.sorted { lhs, rhs in
            lhs.timeToStation ?? 0 < rhs.timeToStation ?? 0
        }
    }
}

private extension Array where Element == ArrivalDeparture {
    
    func asBoards(station: Station,
                  oldValues: IdentifiedArrayOf<ArrivalsBoard.State>,
                  refreshTime: Date,
                  lineId: TrainLine?) -> IdentifiedArrayOf<ArrivalsBoard.State> {
        guard let lineId = lineId else {
            assertionFailure()
            return []
        }
        
        let sortedArrivals = self.filter { $0.isValidDeparture }
                                 .sortedByArrivalTime()
        
        let platformGroups = Dictionary(grouping: sortedArrivals, by: { $0.platformName })
        
        let sortedBoards = platformGroups.map { platformName, arrivals -> ArrivalsBoard.State in
            let boardId = "\(station.name)-\(platformName ?? "")"
            return ArrivalsBoard.State(station: station,
                                       rowTypes: arrivals.map { .arrivalDeparture($0, lineId: lineId) },
                                       time: refreshTime,
                                       rotatingRowIndex: oldValues[id: boardId]?.rotatingRowIndex,
                                       isExpanded: oldValues[id: boardId]?.isExpanded ?? false,
                                       manualRotationTimer: true)
        }.sorted {
            $0.platformTitleText < $1.platformTitleText
        }
        
        return IdentifiedArrayOf(uniqueElements: sortedBoards)
    }
    
    func sortedByArrivalTime() -> [ArrivalDeparture] {
        self.sorted { lhs, rhs in
            lhs.scheduledTimeOfDeparture ?? .distantPast < lhs.scheduledTimeOfDeparture ?? .distantPast
        }
    }
}

extension Station.ArrivalsGroup {
    
    enum BoardType {
        case arrivalPredictions
        case arrivalDepartures(TrainLine)
    }
    
    var boardType: BoardType {
        // For now, only the Elizabeth Line supports "ArrivalDeparture" data.
        // Everything else (i.e. tube, dlr etc) is "Arrival" predictions data only.
        if lineIds == [.elizabeth] {
            return .arrivalDepartures(.elizabeth)
        }
        return .arrivalPredictions
    }
    
    var arrivalDeparturesLineId: TrainLine? {
        switch boardType {
        case .arrivalPredictions:
            return nil
        case let .arrivalDepartures(lineId):
            return lineId
        }
    }
}
