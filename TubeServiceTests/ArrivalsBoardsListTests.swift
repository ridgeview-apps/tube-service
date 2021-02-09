import XCTest
import ComposableArchitecture
import Combine

@testable import Tube_Service

class ArrivalsBoardsListTests: XCTestCase {
    
    let scheduler = DispatchQueue.testScheduler
    
    func testAppearAndDisappear() throws {

        let station = Station.fake(ofType: .kingsCross)
        let initialState = ArrivalsBoardsList.ViewState.fake(station: station,
                                                         arrivalsGroupIndex: 2,
                                                         boards: [],
                                                         errorMessage: nil)
        
        let store = TestStore(initialState: .fake(viewState: initialState),
                              reducer: ArrivalsBoardsList.reducer,
                              environment: .unitTest)
      
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
                           animationState: ArrivalsBoard.ViewState.AnimationState) -> ArrivalsBoard.ViewState {
                .init(station: station,
                      arrivals: expectedArrivals,
                      time: simulatedNow,
                      localizer: .fake,
                      isExpanded: false,
                      animationState: animationState,
                      manualRotationTimer: true)
        }

        store.assert(
            .environment {
                $0.date = { simulatedNow }
                $0.dataServices.api.arrivals = { _ in Effect(value: arrivals) }
                $0.mainQueue = self.scheduler.eraseToAnyScheduler()
            },
            
            // 1. Appear / start autorefresh
            .send(.onAppear),
            .receive(.setEachBoardAnimationState(to: .rotating)),
            .receive(.startAutoRefreshTimer) {
                $0.isAutoRefreshTimerActive = true
            },
            .receive(.refresh) {
                $0.isRefreshing = true
            },
            .receive(.setEachBoardAnimationState(to: .refreshing)),
            .do {
                self.scheduler.advance()
            },
            .receive(.arrivalsResponse(.success(arrivals))) {
                $0.isRefreshing = false
                $0.lastRefreshedAt = simulatedNow
                $0.boards = [
                    expectedBoard(with: platform1Arrivals, animationState: .stopped),
                    expectedBoard(with: platform2Arrivals, animationState: .stopped)
                ]
                let timestamp = Formatter.relativeDateTime.string(from: simulatedNow)
                $0.sectionTitle = "Northern (\(timestamp))"
            },
            .receive(.setEachBoardAnimationState(to: .rotating)),
            .receive(.arrivalsBoard(id: "\(station.name)-Platform 1", action: .setAnimationState(to: .rotating))) {
                $0.boards = [
                    expectedBoard(with: platform1Arrivals, animationState: .rotating),
                    expectedBoard(with: platform2Arrivals, animationState: .stopped)
                ]
            },

            .receive(.arrivalsBoard(id: "\(station.name)-Platform 2", action: .setAnimationState(to: .rotating))) {
                $0.boards = [
                    expectedBoard(with: platform1Arrivals, animationState: .rotating),
                    expectedBoard(with: platform2Arrivals, animationState: .rotating)
                ]
            },

            // 2. Disappear / cancel autoRefresh
            .send(.onDisappear),
            .receive(.cancelAutoRefreshTimer) {
                $0.isAutoRefreshTimerActive = false
            },
            .receive(.setEachBoardAnimationState(to: .stopped)),
            .receive(.arrivalsBoard(id: "\(station.name)-Platform 1", action: .setAnimationState(to: .stopped))) {
                $0.boards = [
                    expectedBoard(with: platform1Arrivals, animationState: .stopped),
                    expectedBoard(with: platform2Arrivals, animationState: .rotating),
                    
                ]
            },
            .receive(.arrivalsBoard(id: "\(station.name)-Platform 2", action: .setAnimationState(to: .stopped))) {
                $0.boards = [
                    expectedBoard(with: platform1Arrivals, animationState: .stopped),
                    expectedBoard(with: platform2Arrivals, animationState: .stopped),
                ]
            }
        )
    }
    
    func testRefreshFailure() throws {
        
        let station = Station.fake(ofType: .kingsCross)
        let initialState = ArrivalsBoardsList.ViewState.fake(station: station,
                                                         arrivalsGroupIndex: 2,
                                                         boards: [],
                                                         errorMessage: nil)
        
        let store = TestStore(initialState: .fake(viewState: initialState),
                              reducer: ArrivalsBoardsList.reducer,
                              environment: .unitTest)
        
        let noInternet = TransportAPI.APIFailure(error: NSError.fake(ofType: .noInternet))
        
        store.assert(
            .environment {
                $0.dataServices.api.arrivals = { _ in Effect(error: noInternet) }
                $0.mainQueue = self.scheduler.eraseToAnyScheduler()
            },
            
            // 1. Appear / refresh
            .send(.onAppear),
            .receive(.setEachBoardAnimationState(to: .rotating)),
            .receive(.startAutoRefreshTimer) {
                $0.isAutoRefreshTimerActive = true
            },
            .receive(.refresh) {
                $0.isRefreshing = true
            },
            .receive(.setEachBoardAnimationState(to: .refreshing)),
            .do {
                self.scheduler.advance()
            },
            .receive(.arrivalsResponse(.failure(noInternet))) {
                $0.isRefreshing = false
                $0.errorMessage = noInternet.localizedDescription
            },
            .receive(.setEachBoardAnimationState(to: .rotating)),

            // 2. Disappear / cancel autoRefresh
            .send(.onDisappear),
            .receive(.cancelAutoRefreshTimer) {
                $0.isAutoRefreshTimerActive = false
            },
            .receive(.setEachBoardAnimationState(to: .stopped))
        )
    }
    
    func testToggleFavourites() throws {

        let station = Station.fake(ofType: .kingsCross)
        let idx = 2
        let arrivalsGroup = station.arrivalsGroups[idx]
        let initialState = ArrivalsBoardsList.ViewState.fake(station: station,
                                                         arrivalsGroupIndex: idx,
                                                         boards: [],
                                                         errorMessage: nil)
        let store = TestStore(initialState: .fake(viewState: initialState),
                              reducer: ArrivalsBoardsList.reducer,
                              environment: .unitTest)
      
        let simulatedNow = Date.UTC_1_JAN_2020_09H00
        
        let favouriteAddedPrefs = UserPreferences.fake(favourites: Set([arrivalsGroup.id]))
        let favouriteRemovedPrefs = UserPreferences.fake(favourites: Set())

        store.assert(
            .environment {
                $0.date = { simulatedNow }
                $0.dataServices.api.arrivals = { _ in Effect(value: []) }
                $0.mainQueue = self.scheduler.eraseToAnyScheduler()
            },
            
            // 1. Add favourite
            .send(.tapFavourite(true)),
            .receive(.global(.addFavourite(arrivalsGroup))),
            .receive(.global(.updateUserPreferences(favouriteAddedPrefs))),
            .receive(.global(.didUpdateUserPreferences(favouriteAddedPrefs))) {
                $0.userPreferences = favouriteAddedPrefs
            },
            
            // 2. Remove favourite
            .send(.tapFavourite(false)),
            .receive(.global(.removeFavourite(arrivalsGroup))),
            .receive(.global(.updateUserPreferences(favouriteRemovedPrefs))),
            .receive(.global(.didUpdateUserPreferences(favouriteRemovedPrefs))) {
                $0.userPreferences = favouriteRemovedPrefs
            }
            
        )
    }
}
