import ComposableArchitecture
import DataClients
import Model
import Shared
import Combine

public enum ArrivalsPicker: Equatable {
    
    // MARK: - State
    public struct State: Equatable {
        public struct RowSelection: Equatable {
            var id: ArrivalsBoardsList.State.ID? = nil
            var navigationStates = IdentifiedArrayOf<ArrivalsBoardsList.State>()
            
            public init() { }
            
            mutating func setNavigationState(to destinationViewState: ArrivalsBoardsList.State?) {
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
        
        public var rowSelection: RowSelection = .init()
        public var stations: IdentifiedArrayOf<Station> = []
        public var selectableStations: IdentifiedArrayOf<Station> = []
        public var userPreferences: UserPreferences = .empty
        public var expandedRows: Set<Station> = []
        public var searchText = ""
        public var hasLoaded: Bool = false
        
        public var filterOptions: [UserPreferences.ArrivalsPickerFilterOption] {
            UserPreferences.ArrivalsPickerFilterOption.allCases            
        }
        
        public var isSearching: Bool { !searchText.isEmpty }
        
        public func isRowExpanded(for station: Station) -> Bool {
            expandedRows.contains(station)
        }
        
        public var sectionHeaderShowsSearchResultsCount: Bool {
            isSearching && !selectableStations.isEmpty
        }
        
        public var sectionHeaderShowsFilterOptions: Bool {
            !isSearching
        }
        
        public var emptySearchResultsStringKey: String? {
            guard isSearching && selectableStations.isEmpty else {
                return nil
            }
            
            return searchText.isEmpty
                ? "arrivals.picker.search.text.empty"
                : "arrivals.picker.search.no.results"
        }
        
        public var searchResultsCount: Int {
            selectableStations.count
        }
        
        public init(rowSelection: ArrivalsPicker.State.RowSelection = .init(),
                    stations: IdentifiedArrayOf<Station> = [],
                    selectableStations: IdentifiedArrayOf<Station> = [],
                    userPreferences: UserPreferences = .empty,
                    expandedRows: Set<Station> = [],
                    searchText: String = "",
                    hasLoaded: Bool = false) {
            self.rowSelection = rowSelection
            self.stations = stations
            self.selectableStations = selectableStations
            self.userPreferences = userPreferences
            self.expandedRows = expandedRows
            self.searchText = searchText
            self.hasLoaded = hasLoaded
        }        
    }
    
    // MARK: - Action
    public enum Action: Equatable {
        case onAppear
        case search(text: String)
        case selectFilterOption(UserPreferences.ArrivalsPickerFilterOption)
        case selectRow(ArrivalsBoardsList.State.ID?)
        case toggleExpandedRowState(for: Station)
        case setExpandedRowState(to: Bool, for: Station)
        case arrivalsBoardsList(id: ArrivalsBoardsList.State.ID, action: ArrivalsBoardsList.Action)
        case didLoadData([Station], UserPreferences)
        case refreshStations
    }
    
    // MARK: - Environment
    public struct Environment {
        public var transportAPI: TransportAPIClient
        public var stationsClient: StationsClient
        public var userPreferencesClient: UserPreferencesClient
        public var now: () -> Date
        public var mainQueue: AnySchedulerOf<DispatchQueue>
        
        public init(transportAPI: TransportAPIClient,
                    stationsClient: StationsClient,
                    userPreferencesClient: UserPreferencesClient,
                    now: @escaping () -> Date,
                    mainQueue: AnySchedulerOf<DispatchQueue>) {
            self.transportAPI = transportAPI
            self.stationsClient = stationsClient
            self.userPreferencesClient = userPreferencesClient
            self.now = now
            self.mainQueue = mainQueue
        }
    }
    
    public static let reducer = Reducer<State, Action, Environment>.combine(
        
        ArrivalsBoardsList.reducer.forEach(state: \.rowSelection.navigationStates,
                                            action: /Action.arrivalsBoardsList,
                                            environment: {
                                                .init(transportAPI: $0.transportAPI,
                                                      now: $0.now,
                                                      mainQueue: $0.mainQueue)
                                            }),
        
        Reducer<State, Action, Environment> { state, action, env in
            switch action {
            case .onAppear:
                if !state.hasLoaded {
                    let loadedStations = env.stationsClient.load()
                                                           .map { $0.sortedByName() }
                                                     
                    
                    let loadedUserPreferences = env.userPreferencesClient.load()
                    
                    return Publishers
                            .Zip(loadedStations, loadedUserPreferences)
                            .eraseToEffect()
                            .map(Action.didLoadData)
                }
                return Effect(value: .refreshStations)
            case let .didLoadData(stations, userPreferences):
                state.userPreferences = userPreferences
                state.stations = IdentifiedArrayOf(uniqueElements: stations)
                state.hasLoaded = true
                return Effect(value: .refreshStations)
            case .refreshStations:
                switch (state.isSearching, state.userPreferences.lastUsedFilterOption) {
                case (true, _):
                    state.selectableStations = state.stations.filter {
                        $0.name.alphaNumerics.localizedStandardContains(state.searchText.alphaNumerics)
                    }
                case (false, .all):
                    state.selectableStations = state.stations
                case (false, .favourites):
                    let filteredStations = state.stations.map {
                        $0.withFavouritesOnly(favouriteBoards: state.userPreferences.favourites)
                    }.filter {
                        !$0.arrivalsGroups.isEmpty
                    }
                    state.selectableStations = IdentifiedArray(uniqueElements: filteredStations)
                }
                
                return .none
            case let .search(text):
                struct SearchTextId: Hashable {}
                guard state.searchText != text else {
                    return .none
                }
                state.searchText = text
                return Effect(value: .refreshStations)
                            .debounce(id: SearchTextId(), for: 0.3, scheduler: env.mainQueue)
            case let .selectRow(rowId):
                guard state.rowSelection.id != rowId else {
                    return .none
                }
                if let rowId = rowId {
                    let isFavourite = state.userPreferences.favourites.contains(rowId.arrivalsGroup.id)
                    let navigationState = ArrivalsBoardsList.State(id: rowId, isFavourite: isFavourite)
                    state.rowSelection.setNavigationState(to: navigationState)
                } else {
                    state.rowSelection.setNavigationState(to: nil)
                }
                return .none
            case let .selectFilterOption(filterOption):
                guard state.userPreferences.lastUsedFilterOption != filterOption else {
                    return .none
                }
                state.userPreferences.lastUsedFilterOption = filterOption

                return env.userPreferencesClient
                          .update(state.userPreferences)
                          .eraseToEffect()
                          .map { _ in Action.refreshStations }
            case let .toggleExpandedRowState(for: station):
                var isExpanded = state.expandedRows.contains(station)
                isExpanded.toggle()
                return Effect(value: .setExpandedRowState(to: isExpanded, for: station))
            case let .setExpandedRowState(to: isExpanded, for: station):
                if isExpanded {
                    state.expandedRows.insert(station)
                } else {
                    state.expandedRows.remove(station)
                }
                return .none
            case let .arrivalsBoardsList(rowId, action: .tapFavourite(isFavourite)):
                if isFavourite {
                    state.userPreferences.favourites.insert(rowId.arrivalsGroup.id)
                } else {
                    state.userPreferences.favourites.remove(rowId.arrivalsGroup.id)
                }
                
                return env.userPreferencesClient
                          .update(state.userPreferences)
                          .eraseToEffect()
                          .map { _ in Action.refreshStations }
            case .arrivalsBoardsList:
                return .none                
            }
    })
}

private extension String {
    var alphaNumerics: String {
        self.filter { $0.isLetter || $0.isNumber }
    }
}

private extension Station {
    func withFavouritesOnly(favouriteBoards: Set<Station.ArrivalsGroup.ID>) -> Station {
        let filteredBoards = self.arrivalsGroups.filter { favouriteBoards.contains($0.id) }
        return Station(id: self.id,
                       name: self.name,
                       arrivalsGroups: filteredBoards)
    }
}
