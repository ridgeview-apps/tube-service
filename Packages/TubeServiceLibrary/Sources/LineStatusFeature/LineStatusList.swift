import ComposableArchitecture
import Model
import Shared
import DataClients

public enum LineStatusList: Equatable {
    
    // State
    public struct State: Equatable {
        
        public struct RowSelection: Equatable {
            public var id: LineStatusDetail.State.ID?
            public var navigationStates = IdentifiedArrayOf<LineStatusDetail.State>()
            
            public init() {}

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
        
        public var lastRefreshedAt: Date?
        public var isRefreshing: Bool
        public var navigationBarTitleKey: String
        public var statuses: IdentifiedArrayOf<LineStatus>
        public var errorMessage: String?
        public var lastRefreshedAtText: String
        public var rowSelection: RowSelection
        
        public var disruptions: IdentifiedArrayOf<LineStatus> {
            statuses.filter { $0.isDisrupted }
        }
        
        public var goodService: IdentifiedArrayOf<LineStatus> {
            statuses.filter { !$0.isDisrupted }
        }
        
        public init(
            lastRefreshedAt: Date? = nil,
            isRefreshing: Bool = false,
            navigationBarTitleKey: String = "",
            statuses: IdentifiedArrayOf<LineStatus> = [],
            errorMessage: String? = nil,
            lastRefreshedAtText: String = "",
            rowSelection: LineStatusList.State.RowSelection = .init()
        ) {
            self.lastRefreshedAt = lastRefreshedAt
            self.isRefreshing = isRefreshing
            self.navigationBarTitleKey = navigationBarTitleKey
            self.statuses = statuses
            self.errorMessage = errorMessage
            self.lastRefreshedAtText = lastRefreshedAtText
            self.rowSelection = rowSelection
        }
    }
        
    // Action
    public enum Action: Equatable {
        case onAppear
        case autoRefreshIfNeeded
        case refresh
        case setRefreshing(Bool)
        case selectRow(LineStatusDetail.State.ID?)
        case lineStatusesResponse(Result<[LineStatus], TransportAPIClient.APIFailure>)
        case lineStatusDetail(id: LineStatusDetail.State.ID, action: LineStatusDetail.Action)
    }
    
    // Environment
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
        
        LineStatusDetail.reducer.forEach(
            state: \.rowSelection.navigationStates,
            action: /Action.lineStatusDetail,
            environment: { _ in Void() }
        ),
        
        Reducer { state, action, environment in
            switch action {
            case .onAppear:
                state.navigationBarTitleKey = "status.navigation.title"
                return Effect(value: .autoRefreshIfNeeded)
            case .autoRefreshIfNeeded:
                guard !state.isRefreshing else {
                    return .none
                }
                let lastRefreshedAt = state.lastRefreshedAt ?? Date.distantPast
                let now = environment.now()
                guard Date.timeDiff(between: now, and: lastRefreshedAt) > 5.minutes else {
                    return .none
                }
                return Effect(value: .refresh)
            case .refresh:
                state.isRefreshing = true
                return environment.transportAPI.lineStatuses()
                    .receive(on: environment.mainQueue)
                    .catchToEffect()
                    .map(Action.lineStatusesResponse)
            case let .lineStatusesResponse(.success(lineStatuses)):
                state.isRefreshing = false
                let refreshTime = environment.now()
                state.lastRefreshedAt = refreshTime
                state.lastRefreshedAtText = Formatter.mediumRelativeDateTimeStyle.string(for: refreshTime) ?? ""
                state.statuses = IdentifiedArrayOf(uniqueElements: lineStatuses.sortedByStatusSeverity())
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
                    let navigationState = LineStatusDetail.State(lineStatus: lineStatus)
                    state.rowSelection.setNavigationState(to: navigationState)
                } else {
                    state.rowSelection.setNavigationState(to: nil)
                }
                return .none
            case .lineStatusDetail:
                return .none
            }
        })
}
