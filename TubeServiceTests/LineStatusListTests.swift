import XCTest
import ComposableArchitecture
import Combine
import Model
import DataClients

@testable import Tube_Service

class LineStatusListTest: XCTestCase {
    
    let scheduler = DispatchQueue.test
    
    func testAutoRefresh_success() throws {
        
        let store = TestStore(initialState: .fake(),
                              reducer: LineStatusList.reducer,
                              environment: .unitTest)
        
        let rows: [LineStatus] = [
            .fake(ofType: .lineId(.northern), serviceDetails: [.fake(ofType: .severeDelays)]),
            .fake(ofType: .lineId(.central), serviceDetails: [.fake(ofType: .severeDelays)]),
            .fake(ofType: .lineId(.metropolitan), serviceDetails: [.fake(ofType: .goodService)])
        ]

        let simulatedTimeNow = Date.UTC_1_JAN_2020_09H00
        let fourMinsLater = simulatedTimeNow.minutesLater(4)
        let sixMinsLater = simulatedTimeNow.minutesLater(6)
        
        // 1. First refresh - success
        store.environment.date = { simulatedTimeNow }
        store.environment.dataClients.api.lineStatuses = { Result.successPublisher(rows) }
        store.environment.mainQueue = self.scheduler.eraseToAnyScheduler()
        
        store.send(.onAppear) {
            $0.navigationBarTitle = "status.navigation.title"
        }
        store.receive(.autoRefreshIfNeeded) { _ in }
        store.receive(.refresh) { $0.isRefreshing = true }
        
        scheduler.advance(by: 0.1)
        store.receive(.lineStatusesResponse(.success(rows))) {
            $0.isRefreshing = false
            $0.lastRefreshedAt = simulatedTimeNow
            $0.lastRefreshedAtText = Formatter.relativeDateTime.string(for: simulatedTimeNow)!
            $0.statuses = [
                .fake(ofType: .lineId(.central), serviceDetails: [.fake(ofType: .severeDelays)]),
                .fake(ofType: .lineId(.northern), serviceDetails: [.fake(ofType: .severeDelays)]),
                .fake(ofType: .lineId(.metropolitan), serviceDetails: [.fake(ofType: .goodService)])
            ]
            $0.errorMessage = nil
        }
        
        // 2. Refresh < 5 mins later (no state changes)
        store.environment.date = { fourMinsLater }
        
        store.send(.onAppear)
        store.receive(.autoRefreshIfNeeded) { _ in }
        
        // 3. Refresh > 5 mins later
        let updatedRows: [LineStatus] = [
            .fake(ofType: .lineId(.northern), serviceDetails: [.fake(ofType: .goodService)]),
            .fake(ofType: .lineId(.central), serviceDetails: [.fake(ofType: .goodService)]),
            .fake(ofType: .lineId(.metropolitan), serviceDetails: [.fake(ofType: .goodService)])
        ]
        
        store.environment.date = { sixMinsLater }
        store.environment.dataClients.api.lineStatuses = { Result.successPublisher(updatedRows) }
        
        store.send(.onAppear)
        store.receive(.autoRefreshIfNeeded)
        store.receive(.refresh) {
            $0.isRefreshing = true
        }
        
        scheduler.advance(by: 0.1)
        store.receive(.lineStatusesResponse(.success(updatedRows))) {
            $0.isRefreshing = false
            $0.lastRefreshedAt = sixMinsLater
            $0.lastRefreshedAtText = Formatter.relativeDateTime.string(for: sixMinsLater)!
            $0.statuses = [
                .fake(ofType: .lineId(.central), serviceDetails: [.fake(ofType: .goodService)]),
                .fake(ofType: .lineId(.metropolitan), serviceDetails: [.fake(ofType: .goodService)]),
                .fake(ofType: .lineId(.northern), serviceDetails: [.fake(ofType: .goodService)])
            ]
            $0.errorMessage = nil
        }
    }
    
    func testAutoRefresh_failure() throws {
        
        let store = TestStore(initialState: .fake(),
                              reducer: LineStatusList.reducer,
                              environment: .unitTest)
        
        let timeNow = Date.UTC_1_JAN_2020_09H00
        let noInternet = TransportAPIClient.APIFailure(error: NSError.fake(ofType: .noInternet))
        
        store.environment.date = { timeNow }
        store.environment.dataClients.api.lineStatuses = { Result.failurePublisher(noInternet) }
        store.environment.mainQueue = self.scheduler.eraseToAnyScheduler()
        
        store.send(.onAppear) {
            $0.navigationBarTitle = "status.navigation.title"
        }
        store.receive(.autoRefreshIfNeeded)
        store.receive(.refresh) {
            $0.isRefreshing = true
        }
        
        scheduler.advance(by: 1)
        store.receive(.lineStatusesResponse(.failure(noInternet))) {
            $0.isRefreshing = false
            $0.errorMessage = "No internet connection"
        }
        
    }
    
    func testRowSelection() throws {
        
        let rows: [LineStatus] = [
            .fake(ofType: .lineId(.northern), serviceDetails: [.fake(ofType: .severeDelays)]),
            .fake(ofType: .lineId(.central), serviceDetails: [.fake(ofType: .severeDelays)]),
            .fake(ofType: .lineId(.bakerloo), serviceDetails: [.fake(ofType: .severeDelays)])
        ]
        
        let initialState = LineStatusList.State.fake(
            viewState: .fake(statuses: rows)
        )
        
        let store = TestStore(initialState: initialState,
                              reducer: LineStatusList.reducer,
                              environment: .unitTest)
        
        // 1. Select a row
        store.environment.dataClients.api.lineStatuses = { Result.successPublisher(rows) }
        
        store.send(.selectRow(.northern)) {
            $0.rowSelection.id = .northern
            $0.rowSelection.navigationStates = IdentifiedArrayOf(uniqueElements: [
                .init(globalState: $0.globalState, viewState: .init(lineStatus: rows[0]))
            ])
        }
            
        // 2. Select same row (no changes)
        store.send(.selectRow(.northern))

        // 3. Select a different row
        store.send(.selectRow(.central)) {
            $0.rowSelection.id = .central
            $0.rowSelection.navigationStates = IdentifiedArrayOf(uniqueElements: [
                        .init(globalState: $0.globalState, viewState: .init(lineStatus: rows[0])),
                        .init(globalState: $0.globalState, viewState: .init(lineStatus: rows[1]))
                ])
        }
        
        
        // 4. Deselect the row
        store.send(.selectRow(nil)) {
            $0.rowSelection.id = nil
            $0.rowSelection.navigationStates = IdentifiedArrayOf(uniqueElements: [
                .init(globalState: $0.globalState, viewState: .init(lineStatus: rows[1]))
            ])
        }
        
    }
    
}

extension Publisher {
    
    func todo() {
        
    }
}
