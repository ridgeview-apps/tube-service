import ComposableArchitecture
import Model

enum ArrivalsPicker: Equatable {
    
    struct ViewState: Equatable {
        
        enum Filter: Int, Identifiable, CaseIterable, Codable {
            var id: Int { rawValue }
            case all, favourites
        }
        
        struct RowSelection: Equatable {
            var id: ArrivalsBoardsList.State.ID? = nil
            var navigationStates = IdentifiedArrayOf<ArrivalsBoardsList.State>()
            
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
        
        var rowSelection: RowSelection = .init()
        var selectedFilterOption: Filter = .all
        var navigationBarTitle: String = ""
        var stations: IdentifiedArrayOf<Station> = []
        var selectableStations: IdentifiedArrayOf<Station> = []
        var expandedRows: Set<Station> = []
        var searchText = ""
        var placeholderSearchText = ""
        var searchResultsCountText = ""
        var hasLoaded: Bool = false
        
        var filterOptions: [Filter] {
            Filter.allCases
        }
        
        var isSearching: Bool { !searchText.isEmpty }
        
        func isRowExpanded(for station: Station) -> Bool {
            expandedRows.contains(station)
        }
        
        var sectionHeaderShowsSearchResultsCount: Bool {
            isSearching && !selectableStations.isEmpty
        }
        
        var sectionHeaderShowsFilterOptions: Bool {
            !isSearching
        }
        
        var emptySearchResultsStringKey: String? {
            guard isSearching && selectableStations.isEmpty else {
                return nil
            }
            
            return searchText.isEmpty
                ? "arrivals.picker.search.text.empty"
                : "arrivals.picker.search.no.results"
        }
    }
    
    typealias State = BaseState<ViewState>
    
    enum Action: Equatable {
        case onAppear
        case search(text: String)
        case selectFilterOption(ViewState.Filter)
        case selectRow(ArrivalsBoardsList.State.ID?)
        case toggleExpandedRowState(for: Station)
        case setExpandedRowState(to: Bool, for: Station)
        case arrivalsBoardsList(id: ArrivalsBoardsList.State.ID, action: ArrivalsBoardsList.Action)
        case didLoadStations([Station])
        case refreshStations
        case global(Global.Action)
        
    }
    
    typealias Environment = Root.Environment
    
    static let reducer = Reducer<State, Action, Environment>.combine(
        
        Global.reducer.pullback(state: \.globalState,
                                action: /Action.global,
                                environment: { $0 }),
        
        ArrivalsBoardsList.reducer.forEach(state: \.rowSelection.navigationStates,
                                            action: /Action.arrivalsBoardsList,
                                            environment: { $0 }),
        
        Reducer<State, Action, Environment> { state, action, env in
            switch action {
            case .onAppear:
                state.navigationBarTitle = env.stringLocalizer.localized("arrivals.picker.navigation.title")
                state.placeholderSearchText = env.stringLocalizer.localized("arrivals.picker.search.placeholder")
                state.selectedFilterOption = state.userPreferences.lastUsedFilterOption
                
                if !state.hasLoaded {
                    return env.dataServices.stations.load()
                                .map(Action.didLoadStations)
                                .eraseToEffect()
                }
                return Effect(value: .refreshStations)
            case let .didLoadStations(stations):
                state.stations = IdentifiedArrayOf(uniqueElements: stations)
                state.hasLoaded = true
                return Effect(value: .refreshStations)
            case .refreshStations:
                switch (state.isSearching, state.selectedFilterOption) {
                case (true, _):
                    state.selectableStations = state.stations.filter {
                        $0.name.alphaNumerics.localizedStandardContains(state.searchText.alphaNumerics)
                    }
                    state.searchResultsCountText = String(format:
                                                            env.stringLocalizer.localized("arrivals.picker.search.results.count"),
                                                          state.selectableStations.count)
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
                guard state.rowSelection.id == nil else {
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
                    let navigationState = ArrivalsBoardsList.State(globalState: state.globalState,
                                                                   viewState: .init(id: rowId))
                    state.rowSelection.setNavigationState(to: navigationState)
                } else {
                    state.rowSelection.setNavigationState(to: nil)
                }
                return .none
            case let .selectFilterOption(filterOption):
                guard state.selectedFilterOption != filterOption else {
                    return .none
                }
                state.selectedFilterOption = filterOption
                var userPrefs = state.userPreferences
                userPrefs.lastUsedFilterOption = filterOption
                let updateUserPrefs = Effect<Action, Never>(value: .global(.updateUserPreferences(userPrefs)))
                let refreshStations = Effect<Action, Never>(value: .refreshStations)
                return .concatenate(updateUserPrefs, refreshStations)
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
            case let .arrivalsBoardsList(id, .global):
                if let updatedGlobalState = state.rowSelection.navigationStates[id: id]?.globalState {
                    state.globalState = updatedGlobalState
                    return Effect(value: .refreshStations)
                }
                return .none
            case .global:
                return .none
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
