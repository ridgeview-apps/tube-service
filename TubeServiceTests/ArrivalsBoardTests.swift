import XCTest
import ComposableArchitecture
import Combine
import Model

@testable import Tube_Service

class ArrivalsBoardTests: XCTestCase {
    
    let scheduler = DispatchQueue.test
    
    func testAnimationStates() {
        
        let arrivals: [Arrival] = [
            .fake(ofType: .line(.northern, to: .mordenViaBank, arrivingIn: 30.seconds), on: .platform1),
            .fake(ofType: .line(.northern, to: .kenningtonViaCharingX, arrivingIn: 3.minutes), on: .platform1),
            .fake(ofType: .line(.northern, to: .mordenViaBank, arrivingIn: 6.minutes), on: .platform1),
            .fake(ofType: .line(.northern, to: .kenningtonViaCharingX, arrivingIn: 9.minutes), on: .platform1),
            .fake(ofType: .line(.northern, to: .mordenViaBank, arrivingIn: 12.minutes), on: .platform1),
        ]

        let finchleyCentral = Station.fake(ofType: .finchleyCentral)
        let initialState = ArrivalsBoard.ViewState.fake(station: finchleyCentral,
                                                    arrivals: arrivals,
                                                    localizer: .fake)
        let store = TestStore(initialState: initialState,
                              reducer: ArrivalsBoard.reducer,
                              environment: .unitTest)
        
        store.assert(
            .environment {
                $0.mainQueue = self.scheduler.eraseToAnyScheduler()
            },
            
            // 1. Stopped
            .send(.setAnimationState(to: .stopped)),
            
            // 2. Refreshing
            .send(.setAnimationState(to: .refreshing)) {
                $0.animationState = .refreshing
            },
            
            // 3. Rotating
            .send(.setAnimationState(to: .rotating)) {
                $0.animationState = .rotating
            },
            
            // 1st rotation
            .do { self.scheduler.advance(by: 3) },
            .receive(.rotateNextArrival) {
                $0.rotatingRowIndex = 3
                $0.rotatingRow = .init(station: finchleyCentral,
                                       rowIndex: 3,
                                       arrival: arrivals[3],
                                       localizer: .fake)
            },
            
            // 2nd rotation
            .do { self.scheduler.advance(by: 3) },
            .receive(.rotateNextArrival) {
                $0.rotatingRowIndex = 4
                $0.rotatingRow = .init(station: finchleyCentral,
                                       rowIndex: 4,
                                       arrival: arrivals[4],
                                       localizer: .fake)
            },
            
            // 3rd rotation (wraps back to start)
            .do { self.scheduler.advance(by: 3) },
            .receive(.rotateNextArrival) {
                $0.rotatingRowIndex = 2
                $0.rotatingRow = .init(station: finchleyCentral,
                                       rowIndex: 2,
                                       arrival: arrivals[2],
                                       localizer: .fake)
            },

            .send(.setAnimationState(to: .stopped)) {
                $0.animationState = .stopped
            }
        )
    }
    
    func testExpandAndCollapse() {
        
        let arrivals: [Arrival] = [
            .fake(ofType: .line(.northern, to: .mordenViaBank, arrivingIn: 30.seconds), on: .platform1),
            .fake(ofType: .line(.northern, to: .kenningtonViaCharingX, arrivingIn: 3.minutes), on: .platform1),
            .fake(ofType: .line(.northern, to: .mordenViaBank, arrivingIn: 6.minutes), on: .platform1),
            .fake(ofType: .line(.northern, to: .kenningtonViaCharingX, arrivingIn: 9.minutes), on: .platform1),
            .fake(ofType: .line(.northern, to: .mordenViaBank, arrivingIn: 12.minutes), on: .platform1),
        ]
        
        let finchleyCentral = Station.fake(ofType: .finchleyCentral)
        let initialState = ArrivalsBoard.ViewState.fake(station: finchleyCentral,
                                                    arrivals: arrivals,
                                                    localizer: .fake)
        let store = TestStore(initialState: initialState,
                              reducer: ArrivalsBoard.reducer,
                              environment: .unitTest)
        
        let fullBoardRows: [ArrivalsBoard.ViewState.RowState] = [
            .init(station: finchleyCentral, rowIndex: 0, arrival: arrivals[0], localizer: .fake),
            .init(station: finchleyCentral, rowIndex: 1, arrival: arrivals[1], localizer: .fake),
            .init(station: finchleyCentral, rowIndex: 2, arrival: arrivals[2], localizer: .fake),
            .init(station: finchleyCentral, rowIndex: 3, arrival: arrivals[3], localizer: .fake),
            .init(station: finchleyCentral, rowIndex: 4, arrival: arrivals[4], localizer: .fake),
        ]
        
        store.assert(
            .environment {
                $0.mainQueue = self.scheduler.eraseToAnyScheduler()
            },
            
            // 1. Expand row (stops rotating)
            .send(.setExpanded(true)) {
                $0.isExpanded = true
                $0.fixedRows = fullBoardRows
                $0.rotatingRow = nil
            },
            
            // 2. Collapse row (starts rotating)
            .send(.setExpanded(false)) {
                $0.isExpanded = false
                $0.fixedRows = Array(fullBoardRows[0..<2])
                $0.rotatingRow = fullBoardRows[2]
            }
        )
    }
    
}
