import XCTest
import ComposableArchitecture
import Combine
import LiveArrivalsFeature
import Model

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
        let initialState = ArrivalsBoard.State.fake(station: finchleyCentral,
                                                    arrivals: arrivals)
        let store = TestStore(initialState: initialState,
                              reducer: ArrivalsBoard.reducer,
                              environment: .fake())
        
        store.environment.mainQueue = scheduler.eraseToAnyScheduler()
        
        // 1. Stopped
        store.send(.setAnimationState(to: .stopped))
        
        // 2. Refreshing
        store.send(.setAnimationState(to: .refreshing)) {
            $0.animationState = .refreshing
        }
        
        // 3. Rotating
        store.send(.setAnimationState(to: .rotating)) {
            $0.animationState = .rotating
        }
        
        // 1st rotation
        scheduler.advance(by: 3)
        store.receive(.rotateNextArrival) {
            $0.rotatingRowIndex = 3
            $0.rotatingRow = .init(station: finchleyCentral,
                                   rowIndex: 3,
                                   arrival: arrivals[3])
        }
        
        // 2nd rotation
        scheduler.advance(by: 3)
        store.receive(.rotateNextArrival) {
            $0.rotatingRowIndex = 4
            $0.rotatingRow = .init(station: finchleyCentral,
                                   rowIndex: 4,
                                   arrival: arrivals[4])
        }
        
        // 3rd rotation (wraps back to start)
        scheduler.advance(by: 3)
        store.receive(.rotateNextArrival) {
            $0.rotatingRowIndex = 2
            $0.rotatingRow = .init(station: finchleyCentral,
                                   rowIndex: 2,
                                   arrival: arrivals[2])
        }
        
        store.send(.setAnimationState(to: .stopped)) {
            $0.animationState = .stopped
        }
        
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
        let initialState = ArrivalsBoard.State.fake(station: finchleyCentral,
                                                    arrivals: arrivals)
        let store = TestStore(initialState: initialState,
                              reducer: ArrivalsBoard.reducer,
                              environment: .fake())
        
        let fullBoardRows: [ArrivalsBoard.State.RowState] = [
            .init(station: finchleyCentral, rowIndex: 0, arrival: arrivals[0]),
            .init(station: finchleyCentral, rowIndex: 1, arrival: arrivals[1]),
            .init(station: finchleyCentral, rowIndex: 2, arrival: arrivals[2]),
            .init(station: finchleyCentral, rowIndex: 3, arrival: arrivals[3]),
            .init(station: finchleyCentral, rowIndex: 4, arrival: arrivals[4]),
        ]
        
        store.environment.mainQueue = self.scheduler.eraseToAnyScheduler()
        
        // 1. Expand row (stops rotating)
        store.send(.setExpanded(true)) {
            $0.isExpanded = true
            $0.fixedRows = fullBoardRows
            $0.rotatingRow = nil
        }
        
        // 2. Collapse row (starts rotating)
        store.send(.setExpanded(false)) {
            $0.isExpanded = false
            $0.fixedRows = Array(fullBoardRows[0..<2])
            $0.rotatingRow = fullBoardRows[2]
        }

    }
    
}
