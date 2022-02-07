import XCTest
import ComposableArchitecture
import Combine
import Model
import DataClients

@testable import LiveArrivalsFeature

class ArrivalsPickerTests: XCTestCase {
    
    let scheduler = DispatchQueue.test
    
    func testAppear_filteredByAllStations() throws {
        
        var userPrefs = UserPreferences.fake()
        userPrefs.lastUsedFilterOption = .all
        
        let stations: [Station] = .fakes().sortedByName()
        
        let store = TestStore(initialState: .fake(),
                              reducer: ArrivalsPicker.reducer,
                              environment: .fake())
        
        store.send(.onAppear)
        
        store.receive(.didLoadData(stations, userPrefs)) {
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

        let stations: [Station] = .fakes().sortedByName()

        let store = TestStore(initialState: .fake(),
                              reducer: ArrivalsPicker.reducer,
                              environment: .fake())
        
        store.environment.userPreferencesClient.load = {
            Just(userPrefs).eraseToAnyPublisher()
        }
        
        store.send(.onAppear)

        store.receive(.didLoadData(stations, userPrefs)) {
            $0.hasLoaded = true
            $0.stations = IdentifiedArray(uniqueElements: stations)
            $0.userPreferences = userPrefs
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

        var userPrefs = UserPreferences.fake()
        userPrefs.lastUsedFilterOption = .all
        userPrefs.favourites = favouriteArrivalsGroupIds
                
        let allStations = IdentifiedArrayOf(uniqueElements: Station.fakes().sortedByName())

        var state = ArrivalsPicker.State.fake()
        state.userPreferences = userPrefs
        state.stations = allStations

        let store = TestStore(initialState: state,
                              reducer: ArrivalsPicker.reducer,
                              environment: .fake())
        
        store.environment.userPreferencesClient.load = {
            Just(userPrefs).eraseToAnyPublisher()
        }

        // 1. Select "favourites" filter
        store.send(.selectFilterOption(.favourites)) {
            $0.userPreferences.lastUsedFilterOption = .favourites
        }
        
        store.receive(.refreshStations) {
            $0.selectableStations = [boundsGreen, highBarnet]
        }

        // 2. Re-select same filter
        store.send(.selectFilterOption(.favourites)) // No changes

        userPrefs.lastUsedFilterOption = .favourites
        
        // 3. Select "All" again
        store.send(.selectFilterOption(.all)) {
            $0.userPreferences.lastUsedFilterOption = .all
        }

        store.receive(.refreshStations) {
            $0.selectableStations = allStations
        }

    }

    func testSearch() throws {

        var initialState = ArrivalsPicker.State.fake()
        initialState.stations = IdentifiedArrayOf(uniqueElements: Station.fakes().sortedByName())

        let store = TestStore(initialState: initialState,
                              reducer: ArrivalsPicker.reducer,
                              environment: .fake())
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
                              environment: .fake())

        // 1. Select arrivals group row
        store.send(.selectRow(highBarnetArrivalsListId)) {
                $0.rowSelection.id = highBarnetArrivalsListId
                $0.rowSelection.navigationStates = IdentifiedArrayOf(uniqueElements: [
                    .init(id: highBarnetArrivalsListId, isFavourite: false)
                ])
            }


        // 2. Select another...
        store.send(.selectRow(finchleyCentralArrivalsListId)) {
            $0.rowSelection.id = finchleyCentralArrivalsListId
            $0.rowSelection.navigationStates = IdentifiedArrayOf(uniqueElements: [
                .init(id: highBarnetArrivalsListId, isFavourite: false),
                .init(id: finchleyCentralArrivalsListId, isFavourite: false)
            ])
        }


        // 3. ... and another
        store.send(.selectRow(boundsGreenArrivalsListId)) {
            $0.rowSelection.id = boundsGreenArrivalsListId
            $0.rowSelection.navigationStates = IdentifiedArrayOf(uniqueElements: [
                .init(id: highBarnetArrivalsListId, isFavourite: false),
                .init(id: finchleyCentralArrivalsListId, isFavourite: false),
                .init(id: boundsGreenArrivalsListId, isFavourite: false)
            ])
        }


        // 4. Remove deselected row states
        store.send(.selectRow(nil)) {
            $0.rowSelection.id = nil
            $0.rowSelection.navigationStates = IdentifiedArrayOf(uniqueElements: [
                .init(id: boundsGreenArrivalsListId, isFavourite: false)
            ])
        }


    }

    func testToggleRowState() {
        let kingsCross = Station.fake(ofType: .kingsCross)
        let paddington = Station.fake(ofType: .paddington)

        let store = TestStore(initialState: .fake(),
                              reducer: ArrivalsPicker.reducer,
                              environment: .fake())

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
