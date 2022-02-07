import XCTest
import ComposableArchitecture
import Combine
import DataClients
import LiveArrivalsFeature
import Model

class ArrivalsBoardsListTests: XCTestCase {
    
    let scheduler = DispatchQueue.test
    
    func testAppearAndDisappear() throws {
        
        let station = Station.fake(ofType: .kingsCross)
        let initialState = ArrivalsBoardsList.State.fake(station: station,
                                                         arrivalsGroupIndex: 2,
                                                         boards: [],
                                                         errorMessage: nil)
        
        let store = TestStore(initialState: initialState,
                              reducer: ArrivalsBoardsList.reducer,
                              environment: .fake())
        
        let platform1Arrivals: [Arrival] = [
            .fake(ofType: .line(.northern, to: .mordenViaBank, arrivingIn: 30.seconds), on: .platform1),
            .fake(ofType: .line(.northern, to: .kenningtonViaCharingX, arrivingIn: 3.minutes), on: .platform1),
        ]
        
        let platform2Arrivals: [Arrival] = [
            .fake(ofType: .line(.northern, to: .highBarnet, arrivingIn: 30.seconds), on: .platform2),
            .fake(ofType: .line(.northern, to: .edgware, arrivingIn: 3.minutes), on: .platform2),
        ]
        
        let arrivals = platform1Arrivals + platform2Arrivals
        let simulatedNow = Date.UTC_1_JAN_2020_09H00
        
        func expectedBoard(with expectedArrivals: [Arrival],
                           animationState: ArrivalsBoard.State.AnimationState) -> ArrivalsBoard.State {
            .init(station: station,
                  arrivals: expectedArrivals,
                  time: simulatedNow,
                  isExpanded: false,
                  animationState: animationState,
                  manualRotationTimer: true)
        }
        
        store.environment.now = { simulatedNow }
        store.environment.transportAPI.arrivals = { _ in Result.successPublisher(arrivals) }
        store.environment.mainQueue = self.scheduler.eraseToAnyScheduler()
        
        // 1. Appear / start autorefresh
        store.send(.onAppear)
        store.receive(.setEachBoardAnimationState(to: .rotating))
        store.receive(.startAutoRefreshTimer) {
            $0.isAutoRefreshTimerActive = true
        }
        store.receive(.refresh) {
            $0.isRefreshing = true
        }
        store.receive(.setEachBoardAnimationState(to: .refreshing))
        scheduler.advance()
        
        store.receive(.arrivalsResponse(.success(arrivals))) {
            $0.isRefreshing = false
            $0.lastRefreshedAt = simulatedNow
            $0.boards = [
                expectedBoard(with: platform1Arrivals, animationState: .stopped),
                expectedBoard(with: platform2Arrivals, animationState: .stopped)
            ]
            let timestamp = Formatter.mediumRelativeDateTimeStyle.string(from: simulatedNow)
            $0.sectionTitle = "Northern (\(timestamp))"
        }
        store.receive(.setEachBoardAnimationState(to: .rotating))
        store.receive(.arrivalsBoard(id: "\(station.name)-Platform 1", action: .setAnimationState(to: .rotating))) {
            $0.boards = [
                expectedBoard(with: platform1Arrivals, animationState: .rotating),
                expectedBoard(with: platform2Arrivals, animationState: .stopped)
            ]
        }
        
        store.receive(.arrivalsBoard(id: "\(station.name)-Platform 2", action: .setAnimationState(to: .rotating))) {
            $0.boards = [
                expectedBoard(with: platform1Arrivals, animationState: .rotating),
                expectedBoard(with: platform2Arrivals, animationState: .rotating)
            ]
        }
        
        // 2. Disappear / cancel autoRefresh
        store.send(.onDisappear)
        store.receive(.cancelAutoRefreshTimer) {
            $0.isAutoRefreshTimerActive = false
        }
        store.receive(.setEachBoardAnimationState(to: .stopped))
        store.receive(.arrivalsBoard(id: "\(station.name)-Platform 1", action: .setAnimationState(to: .stopped))) {
            $0.boards = [
                expectedBoard(with: platform1Arrivals, animationState: .stopped),
                expectedBoard(with: platform2Arrivals, animationState: .rotating),
                
            ]
        }
        store.receive(.arrivalsBoard(id: "\(station.name)-Platform 2", action: .setAnimationState(to: .stopped))) {
            $0.boards = [
                expectedBoard(with: platform1Arrivals, animationState: .stopped),
                expectedBoard(with: platform2Arrivals, animationState: .stopped),
            ]
        }
        
    }
    
    func testRefreshFailure() throws {
        
        let station = Station.fake(ofType: .kingsCross)
        let initialState = ArrivalsBoardsList.State.fake(station: station,
                                                         arrivalsGroupIndex: 2,
                                                         boards: [],
                                                         errorMessage: nil)
        
        let store = TestStore(initialState: initialState,
                              reducer: ArrivalsBoardsList.reducer,
                              environment: .fake())
        
        let noInternet = TransportAPIClient.APIFailure(error: NSError.fake(ofType: .noInternet))
        
        store.environment.transportAPI.arrivals = { _ in Result.failurePublisher(noInternet) }
        store.environment.mainQueue = scheduler.eraseToAnyScheduler()
        
        // 1. Appear / refresh
        store.send(.onAppear)
        store.receive(.setEachBoardAnimationState(to: .rotating))
        store.receive(.startAutoRefreshTimer) {
            $0.isAutoRefreshTimerActive = true
        }
        store.receive(.refresh) {
            $0.isRefreshing = true
        }
        store.receive(.setEachBoardAnimationState(to: .refreshing))
        scheduler.advance()
        store.receive(.arrivalsResponse(.failure(noInternet))) {
            $0.isRefreshing = false
            $0.errorMessage = noInternet.localizedDescription
        }
        store.receive(.setEachBoardAnimationState(to: .rotating))
        
        // 2. Disappear / cancel autoRefresh
        store.send(.onDisappear)
        store.receive(.cancelAutoRefreshTimer) {
            $0.isAutoRefreshTimerActive = false
        }
        store.receive(.setEachBoardAnimationState(to: .stopped))
    }
    
    func testToggleFavourites() throws {

        let station = Station.fake(ofType: .kingsCross)
        let idx = 2
        let initialState = ArrivalsBoardsList.State.fake(station: station,
                                                         arrivalsGroupIndex: idx,
                                                         boards: [],
                                                         errorMessage: nil)
        let store = TestStore(initialState: initialState,
                              reducer: ArrivalsBoardsList.reducer,
                              environment: .fake())
      
        let simulatedNow = Date.UTC_1_JAN_2020_09H00
        
        store.environment.now = { simulatedNow }
        store.environment.transportAPI.arrivals = { _ in Result.successPublisher([]) }
        store.environment.mainQueue = self.scheduler.eraseToAnyScheduler()
        
        // 1. Add favourite
        store.send(.tapFavourite(true)) {
            $0.isFavourite = true
        }
        
        // 2. Remove favourite
        store.send(.tapFavourite(false)) {
            $0.isFavourite = false
        }
        
    }
}
