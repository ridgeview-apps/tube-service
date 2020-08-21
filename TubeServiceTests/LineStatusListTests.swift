import XCTest
import ComposableArchitecture
import Combine

@testable import Tube_Service

class LineStatusListTest: XCTestCase {
    
    let scheduler = DispatchQueue.testScheduler
    
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
        store.assert(
            .environment {
                $0.date = { simulatedTimeNow }
                $0.dataServices.api.lineStatuses = { Effect(value: rows) }
                $0.mainQueue = self.scheduler.eraseToAnyScheduler()
            },
            .send(.onAppear) {
                $0.navigationBarTitle = "status.navigation.title"
            },
            .receive(.autoRefreshIfNeeded) { _ in },
            .receive(.refresh) { $0.isRefreshing = true },
            .do { self.scheduler.advance(by: 0.1) },
            .receive(.lineStatusesResponse(.success(rows))) {
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
        )
        
        // 2. Refresh < 5 mins later (no state changes)
        store.assert(
            .environment {
                $0.date = { fourMinsLater }
            },
            .send(.onAppear),
            .receive(.autoRefreshIfNeeded) { _ in }
        )
        
        // 3. Refresh > 5 mins later
        let updatedRows: [LineStatus] = [
            .fake(ofType: .lineId(.northern), serviceDetails: [.fake(ofType: .goodService)]),
            .fake(ofType: .lineId(.central), serviceDetails: [.fake(ofType: .goodService)]),
            .fake(ofType: .lineId(.metropolitan), serviceDetails: [.fake(ofType: .goodService)])
        ]

        store.assert(
            .environment {
                $0.date = { sixMinsLater }
                $0.dataServices.api.lineStatuses = { Effect(value: updatedRows) }
            },
            .send(.onAppear),
            .receive(.autoRefreshIfNeeded),
            .receive(.refresh) {
                $0.isRefreshing = true
            },
            .do { self.scheduler.advance(by: 0.1) },
            .receive(.lineStatusesResponse(.success(updatedRows))) {
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
        )
    }
    
    func testAutoRefresh_failure() throws {
        
        let store = TestStore(initialState: .fake(),
                              reducer: LineStatusList.reducer,
                              environment: .unitTest)
        
        let timeNow = Date.UTC_1_JAN_2020_09H00
        let noInternet = TransportAPI.APIFailure(error: NSError.fake(ofType: .noInternet))
        
        store.assert(
            .environment {
                $0.date = { timeNow }
                $0.dataServices.api.lineStatuses = { Effect(error: noInternet) }
                $0.mainQueue = self.scheduler.eraseToAnyScheduler()
            },
            .send(.onAppear) {
                $0.navigationBarTitle = "status.navigation.title"
            },
            .receive(.autoRefreshIfNeeded),
            .receive(.refresh) {
                $0.isRefreshing = true
            },
            .do { self.scheduler.advance(by: 1) },
            .receive(.lineStatusesResponse(.failure(noInternet))) {
                $0.isRefreshing = false
                $0.errorMessage = "No internet connection"
            }
        )
    }
    
    func testRowSelection() throws {
        
        let rows: [LineStatus] = [
            .fake(ofType: .lineId(.northern), serviceDetails: [.fake(ofType: .severeDelays)]),
            .fake(ofType: .lineId(.central), serviceDetails: [.fake(ofType: .severeDelays)]),
            .fake(ofType: .lineId(.northern), serviceDetails: [.fake(ofType: .severeDelays)])
        ]
        
        let initialState = LineStatusList.State.fake(
            viewState: .fake(statuses: rows)
        )
        
        let store = TestStore(initialState: initialState,
                              reducer: LineStatusList.reducer,
                              environment: .unitTest)
        
        // 1. Select a row
        store.assert(
            .environment {
                $0.dataServices.api.lineStatuses = { Effect(value: rows) }
            },
            .send(.selectRow(.northern)) {
                $0.rowSelection.id = .northern
                $0.rowSelection.lineStatusDetailViewState = .init(lineStatus: rows[0])
            }
        )
            
        // 2. Select same row (no changes)
        store.assert(
            .send(.selectRow(.northern))
        )

        // 3. Select a different row
        store.assert(
            .send(.selectRow(.central)) {
                $0.rowSelection.id = .central
                $0.rowSelection.lineStatusDetailViewState = .init(lineStatus: rows[1])
            }
        )
        
        // 4. Deselect the row
        store.assert(
            .send(.selectRow(nil)) {
                $0.rowSelection.id = nil
            }
        )
    }
    
}
