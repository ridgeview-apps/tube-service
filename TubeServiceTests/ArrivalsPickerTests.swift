import XCTest
import ComposableArchitecture
import Combine
import Model
import DataClients

@testable import Tube_Service

class ArrivalsPickerTests: XCTestCase {
    
    let scheduler = DispatchQueue.test
    
    func testAppear_filteredByAllStations() throws {
        
        var userPrefs = UserPreferences.fake()
        userPrefs.lastUsedFilterOption = .all
        
        let globalState = Global.State.fake(userPreferences: userPrefs)
        
        let stations: [Station] = .fakes().sortedByName()
        
        let store = TestStore(initialState: .fake(globalState: globalState),
                              reducer: ArrivalsPicker.reducer,
                              environment: .unitTest)
        
        store.send(.onAppear) {
            $0.navigationBarTitle = "arrivals.picker.navigation.title"
            $0.placeholderSearchText = "arrivals.picker.search.placeholder"
            $0.selectedFilterOption = .all
        }
        
        store.receive(.didLoadStations(stations)) {
            $0.hasLoaded = true
            $0.stations = IdentifiedArray(uniqueElements: stations)
        }
        
        store.receive(.refreshStations) {
            $0.selectableStations = $0.stations
        }
        
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
        
        let stations: [Station] = .fakes().sortedByName()
        
        let store = TestStore(initialState: .fake(globalState: globalState),
                              reducer: ArrivalsPicker.reducer,
                              environment: .unitTest)
        
        store.send(.onAppear) {
            $0.navigationBarTitle = "arrivals.picker.navigation.title"
            $0.placeholderSearchText = "arrivals.picker.search.placeholder"
            $0.selectedFilterOption = .favourites
        }
        
        store.receive(.didLoadStations(stations)) {
            $0.hasLoaded = true
            $0.stations = IdentifiedArray(uniqueElements: stations)
        }
        
        store.receive(.refreshStations) {
            $0.selectableStations = [boundsGreen, highBarnet]
        }
        
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
        viewState.stations = IdentifiedArrayOf(uniqueElements: Station.fakes().sortedByName())
        
        let store = TestStore(initialState: .fake(globalState: globalState, viewState: viewState),
                              reducer: ArrivalsPicker.reducer,
                              environment: .unitTest)

        var updatedUserPrefs = initialUserPrefs
        updatedUserPrefs.lastUsedFilterOption = .favourites
        
        // 1. Select "favourites" filter
        store.send(.selectFilterOption(.favourites)) {
            $0.selectedFilterOption = .favourites
        }
        
        store.receive(.global(.updateUserPreferences(updatedUserPrefs)))
        
        store.receive(.refreshStations) {
            $0.selectableStations = [boundsGreen, highBarnet]
        }
        
        store.receive(.global(.didUpdateUserPreferences(updatedUserPrefs))) {
            $0.userPreferences.lastUsedFilterOption = .favourites
        }
        
        // 2. Re-select same filter
        store.send(.selectFilterOption(.favourites)) // No changes
        
        updatedUserPrefs.lastUsedFilterOption = .all
        
        // 3. Select "All" again
        store.send(.selectFilterOption(.all)) {
            $0.selectedFilterOption = .all
        }
        
        store.receive(.global(.updateUserPreferences(updatedUserPrefs)))
        
        store.receive(.refreshStations) {
            $0.selectableStations = $0.stations
        }
        
        store.receive(.global(.didUpdateUserPreferences(updatedUserPrefs))) {
            $0.userPreferences.lastUsedFilterOption = .all
        }
    }
    
    func testSearch() throws {
        
        var viewState = ArrivalsPicker.ViewState.fake()
        viewState.stations = IdentifiedArrayOf(uniqueElements: Station.fakes().sortedByName())
        
        let initialState = ArrivalsPicker.State.fake(viewState: viewState)
        
        let store = TestStore(initialState: initialState,
                              reducer: ArrivalsPicker.reducer,
                              environment: .unitTest)
        let kingsCross = Station.fake(ofType: .kingsCross)
        let barkingside = Station.fake(ofType: .barkingSide)
        let kingsbury = Station.fake(ofType: .kingsbury)
        
        // 1. Begin search
        store.environment.mainQueue = scheduler.eraseToAnyScheduler()
        
        store.send(.search(text: "Kings")) {
            $0.searchText = "Kings"
        }
        
        scheduler.advance(by: 0.3)
        store.receive(.refreshStations) {
            $0.selectableStations = [barkingside, kingsCross, kingsbury]
            $0.searchResultsCountText = "arrivals.picker.search.results.count"
        }
        
        store.send(.search(text: "Kings C")) {
            $0.searchText = "Kings C"
        }
        
        store.send(.search(text: "Kings Cr")) {
            $0.searchText = "Kings Cr"
        }
        
        scheduler.advance(by: 0.3)
        store.receive(.refreshStations) {
            $0.selectableStations = [kingsCross]
            $0.searchResultsCountText = "arrivals.picker.search.results.count"
        }
        
        
        // 2. End search
        store.send(.search(text: "")) {
            $0.searchText = ""
        }
        scheduler.advance(by: 0.3)
        store.receive(.refreshStations) {
            $0.selectableStations = initialState.selectableStations
        }
        
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
        store.send(.selectRow(highBarnetArrivalsListId)) {
                $0.rowSelection.id = highBarnetArrivalsListId
                $0.rowSelection.navigationStates = IdentifiedArrayOf(uniqueElements: [
                    .init(globalState: $0.globalState, viewState: .init(id: highBarnetArrivalsListId))
                ])
            }
        
        
        // 2. Select another...
        store.send(.selectRow(finchleyCentralArrivalsListId)) {
            $0.rowSelection.id = finchleyCentralArrivalsListId
            $0.rowSelection.navigationStates = IdentifiedArrayOf(uniqueElements: [
                .init(globalState: $0.globalState, viewState: .init(id: highBarnetArrivalsListId)),
                .init(globalState: $0.globalState, viewState: .init(id: finchleyCentralArrivalsListId))
            ])
        }
        
        
        // 2. ... and another
        store.send(.selectRow(boundsGreenArrivalsListId)) {
            $0.rowSelection.id = boundsGreenArrivalsListId
            $0.rowSelection.navigationStates = IdentifiedArrayOf(uniqueElements: [
                .init(globalState: $0.globalState, viewState: .init(id: highBarnetArrivalsListId)),
                .init(globalState: $0.globalState, viewState: .init(id: finchleyCentralArrivalsListId)),
                .init(globalState: $0.globalState, viewState: .init(id: boundsGreenArrivalsListId))
            ])
        }
        
        
        // 2. Remove deselected row states
        store.send(.selectRow(nil)) {
            $0.rowSelection.id = nil
            $0.rowSelection.navigationStates = IdentifiedArrayOf(uniqueElements: [
                .init(globalState: $0.globalState, viewState: .init(id: boundsGreenArrivalsListId))
            ])
        }
        
        
    }
    
    func testToggleRowState() {
        let kingsCross = Station.fake(ofType: .kingsCross)
        let paddington = Station.fake(ofType: .paddington)
        
        let store = TestStore(initialState: .fake(),
                              reducer: ArrivalsPicker.reducer,
                              environment: .unitTest)
        
        // 1. Expand "King's Cross", then "Paddington"
        store.send(.toggleExpandedRowState(for: kingsCross))
        store.receive(.setExpandedRowState(to: true, for: kingsCross)) {
            $0.expandedRows = Set([kingsCross])
        }
        store.send(.toggleExpandedRowState(for: paddington))
        store.receive(.setExpandedRowState(to: true, for: paddington)) {
            $0.expandedRows = Set([kingsCross, paddington])
        }
        
        // 2. Collapse King's Cross, then Paddington
        store.send(.toggleExpandedRowState(for: kingsCross))
        store.receive(.setExpandedRowState(to: false, for: kingsCross)) {
            $0.expandedRows = Set([paddington])
        }
        store.send(.toggleExpandedRowState(for: paddington))
        store.receive(.setExpandedRowState(to: false, for: paddington)) {
            $0.expandedRows = Set()
        }
        
    }
}
