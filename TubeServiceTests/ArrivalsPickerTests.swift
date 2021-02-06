import XCTest
import ComposableArchitecture
import Combine

@testable import Tube_Service

class ArrivalsPickerTests: XCTestCase {
    
    let scheduler = DispatchQueue.testScheduler
    
    func testAppear_filteredByAllStations() throws {
        
        var userPrefs = UserPreferences.fake()
        userPrefs.lastUsedFilterOption = .all
        
        let globalState = Global.State.fake(userPreferences: userPrefs)
        
        let stations: [Station] = .fakes()
        
        let store = TestStore(initialState: .fake(globalState: globalState),
                              reducer: ArrivalsPicker.reducer,
                              environment: .unitTest)
        
        store.assert(
            .send(.onAppear) {
                $0.navigationBarTitle = "arrivals.picker.navigation.title"
                $0.placeholderSearchText = "arrivals.picker.search.placeholder"
                $0.selectedFilterOption = .all
            },
            .receive(.didLoadStations(stations)) {
                $0.hasLoaded = true
                $0.stations = IdentifiedArray(stations)
            },
            .receive(.refreshStations) {
                $0.selectableStations = $0.stations
            }
        )
    }
    
    func testAppear_filteredByFavouriteStations() throws {
        
        let highBarnet = Station.fake(ofType: .highBarnet)
        let boundsGreen = Station.fake(ofType: .boundsGreen)
        
        let favouriteArrivalsGroupIds = Set([
            highBarnet.arrivalsGroups[0].id,
            boundsGreen.arrivalsGroups[0].id
        ])
        
        var userPrefs = UserPreferences.fake()
        userPrefs.lastUsedFilterOption = .favourites
        userPrefs.favourites = favouriteArrivalsGroupIds
        
        let globalState = Global.State.fake(userPreferences: userPrefs)
        
        let stations: [Station] = .fakes()
        
        let store = TestStore(initialState: .fake(globalState: globalState),
                              reducer: ArrivalsPicker.reducer,
                              environment: .unitTest)
        
        store.assert(
            
            .send(.onAppear) {
                $0.navigationBarTitle = "arrivals.picker.navigation.title"
                $0.placeholderSearchText = "arrivals.picker.search.placeholder"
                $0.selectedFilterOption = .favourites
            },
            .receive(.didLoadStations(stations)) {
                $0.hasLoaded = true
                $0.stations = IdentifiedArray(stations)
            },
            .receive(.refreshStations) {
                $0.selectableStations = [boundsGreen, highBarnet]
            }
        )
    }
    
    func testChangeFilterOption() {
        let highBarnet = Station.fake(ofType: .highBarnet)
        let boundsGreen = Station.fake(ofType: .boundsGreen)
        
        let favouriteArrivalsGroupIds = Set([
            boundsGreen.arrivalsGroups[0].id,
            highBarnet.arrivalsGroups[0].id
            
        ])
        
        var initialUserPrefs = UserPreferences.fake()
        initialUserPrefs.lastUsedFilterOption = .all
        initialUserPrefs.favourites = favouriteArrivalsGroupIds
        
        let globalState = Global.State.fake(userPreferences: initialUserPrefs)
        
        var viewState = ArrivalsPicker.ViewState.fake()
        viewState.stations = IdentifiedArrayOf(Station.fakes())
        
        let store = TestStore(initialState: .fake(globalState: globalState, viewState: viewState),
                              reducer: ArrivalsPicker.reducer,
                              environment: .unitTest)

        var updatedUserPrefs = initialUserPrefs
        updatedUserPrefs.lastUsedFilterOption = .favourites

        // 1. Select "favourites" filter
        store.assert(
            .send(.selectFilterOption(.favourites)) {
                $0.selectedFilterOption = .favourites
            },
            .receive(.global(.updateUserPreferences(updatedUserPrefs))),
            .receive(.refreshStations) {
                $0.selectableStations = [boundsGreen, highBarnet]
            },
            .receive(.global(.didUpdateUserPreferences(updatedUserPrefs))) {
                $0.userPreferences.lastUsedFilterOption = .favourites
            }
        )
        
        // 2. Re-select same filter
        store.assert(
            .send(.selectFilterOption(.favourites)) // No changes
        )
        
        updatedUserPrefs.lastUsedFilterOption = .all
        
        // 3. Select "All" again
        store.assert(
            .send(.selectFilterOption(.all)) {
                $0.selectedFilterOption = .all
            },
            .receive(.global(.updateUserPreferences(updatedUserPrefs))),
            .receive(.refreshStations) {
                $0.selectableStations = $0.stations
            },
            .receive(.global(.didUpdateUserPreferences(updatedUserPrefs))) {
                $0.userPreferences.lastUsedFilterOption = .all
            }
        )
    }
    
    func testSearch() throws {
        
        var viewState = ArrivalsPicker.ViewState.fake()
        viewState.stations = IdentifiedArrayOf(Station.fakes())
        
        let initialState = ArrivalsPicker.State.fake(viewState: viewState)
        
        let store = TestStore(initialState: initialState,
                              reducer: ArrivalsPicker.reducer,
                              environment: .unitTest)
        
        // 1. Begin search
        store.assert(
            .send(.beginSearch) {
                $0.isSearching = true
            },
            .receive(.refreshStations) {
                $0.selectableStations = []
                $0.searchResultsCountText = "arrivals.picker.search.results.count"
            }
        )
        
        let kingsCross = Station.fake(ofType: .kingsCross)
        let barkingside = Station.fake(ofType: .barkingSide)
        let kingsbury = Station.fake(ofType: .kingsbury)
        
        // 2. Change search text
        store.assert(
            .environment {
                $0.mainQueue = self.scheduler.eraseToAnyScheduler()
            },
            .send(.search(text: "Kings")) {
                $0.isSearching = true
                $0.searchText = "Kings"
            },
            .do { self.scheduler.advance(by: 0.3) },
            .receive(.refreshStations) {
                $0.selectableStations = [barkingside, kingsCross, kingsbury]
                $0.searchResultsCountText = "arrivals.picker.search.results.count"
            },
            .send(.search(text: "Kings C")) {
                $0.isSearching = true
                $0.searchText = "Kings C"
            },
            .send(.search(text: "Kings Cr")) {
                $0.isSearching = true
                $0.searchText = "Kings Cr"
            },
            .do { self.scheduler.advance(by: 0.3) },
            .receive(.refreshStations) {
                $0.selectableStations = [kingsCross]
                $0.searchResultsCountText = "arrivals.picker.search.results.count"
            }
        )
        
        // 3. End search
        store.assert(
            .send(.endSearch) {
                $0.isSearching = false
                $0.searchText = ""
            },
            .receive(.refreshStations) {
                $0.selectableStations = initialState.selectableStations
            }
        )
    }
    
    func testRowSelection() {
        
        let highBarnet = Station.fake(ofType: .highBarnet)
        let highBarnetArrivalsListId = highBarnet.arrivalsBoardsListId(at: 0)
        
        let finchleyCentral = Station.fake(ofType: .finchleyCentral)
        let finchleyCentralArrivalsListId = finchleyCentral.arrivalsBoardsListId(at: 0)
        
        let boundsGreen = Station.fake(ofType: .boundsGreen)
        let boundsGreenArrivalsListId = boundsGreen.arrivalsBoardsListId(at: 0)
        
        let store = TestStore(initialState: .fake(),
                              reducer: ArrivalsPicker.reducer,
                              environment: .unitTest)
        
        // 1. Select arrivals group row
        store.assert(
            .send(.selectRow(highBarnetArrivalsListId)) {
                $0.rowSelection.id = highBarnetArrivalsListId
                $0.rowSelection.navigationStates = IdentifiedArrayOf(
                    [.init(globalState: $0.globalState, viewState: .init(id: highBarnetArrivalsListId))]
                )
            }
        )
        
        // 2. Select another...
        store.assert(
            .send(.selectRow(finchleyCentralArrivalsListId)) {
                $0.rowSelection.id = finchleyCentralArrivalsListId
                $0.rowSelection.navigationStates = IdentifiedArrayOf(
                    [.init(globalState: $0.globalState, viewState: .init(id: highBarnetArrivalsListId)),
                     .init(globalState: $0.globalState, viewState: .init(id: finchleyCentralArrivalsListId))]
                )
            }
        )
        
        // 2. ... and another
        store.assert(
            .send(.selectRow(boundsGreenArrivalsListId)) {
                $0.rowSelection.id = boundsGreenArrivalsListId
                $0.rowSelection.navigationStates = IdentifiedArrayOf(
                    [.init(globalState: $0.globalState, viewState: .init(id: highBarnetArrivalsListId)),
                     .init(globalState: $0.globalState, viewState: .init(id: finchleyCentralArrivalsListId)),
                     .init(globalState: $0.globalState, viewState: .init(id: boundsGreenArrivalsListId))]
                )
            }
        )
        
        // 2. Remove deselected row states
        store.assert(
            .send(.selectRow(nil)) {
                $0.rowSelection.id = nil
                $0.rowSelection.navigationStates = IdentifiedArrayOf(
                    [.init(globalState: $0.globalState, viewState: .init(id: boundsGreenArrivalsListId))]
                )
            }
        )
        
    }
    
    func testToggleRowState() {
        let kingsCross = Station.fake(ofType: .kingsCross)
        let paddington = Station.fake(ofType: .paddington)
        
        let store = TestStore(initialState: .fake(),
                              reducer: ArrivalsPicker.reducer,
                              environment: .unitTest)
        
        // 1. Expand "King's Cross", then "Paddington"
        store.assert(
            .send(.toggleExpandedRowState(for: kingsCross)),
            .receive(.setExpandedRowState(to: true, for: kingsCross)) {
                $0.expandedRows = Set([kingsCross])
            },
            .send(.toggleExpandedRowState(for: paddington)),
            .receive(.setExpandedRowState(to: true, for: paddington)) {
                $0.expandedRows = Set([kingsCross, paddington])
            }
        )
        
        // 2. Collapse King's Cross, then Paddington
        store.assert(
            .send(.toggleExpandedRowState(for: kingsCross)),
            .receive(.setExpandedRowState(to: false, for: kingsCross)) {
                $0.expandedRows = Set([paddington])
            },
            .send(.toggleExpandedRowState(for: paddington)),
            .receive(.setExpandedRowState(to: false, for: paddington)) {
                $0.expandedRows = Set()
            }
        )
    }
}
