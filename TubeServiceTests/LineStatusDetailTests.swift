import XCTest
import ComposableArchitecture
import Combine

@testable import Tube_Service

class LineStatusDetailTest: XCTestCase {
    
    let scheduler = DispatchQueue.test
    
    func testOnAppear() throws {
        
        let store = TestStore(initialState: .fake(),
                              reducer: LineStatusDetail.reducer,
                              environment: .unitTest)
        
        // 1. Appearing for first time (load triggered)
        store.assert(
            .send(.onAppear) {
                
                $0.allTweetsLink = .init(
                    title: "status.tfl.twitter.handle (status.tfl.twitter.allTweets)",
                    url: URL(string: "https://twitter.com/TfL/with_replies")!
                )
                    
                $0.filteredTweetsLink = .init(
                    title: "status.tfl.twitter.handle (Northern line)",
                    url: URL(string: "https://twitter.com/search?q=(from:TfL%20OR%20to:TfL)%20northern%20line&f=live")!
                )
                
                $0.hasLoaded = true
            }
        )
        
        // 2. Re-appearing (load not triggered)
        store.assert(
            .send(.onAppear) { _ in /* No state changes */ }
        )
    }
    
    func testTapTwitterLinks() throws {
        
        var northernLine  = LineStatusDetail.State.fake(for: .northern)
        
        let twitterLink = LineStatusDetail.ViewState.TwitterLink.fake()
        northernLine.allTweetsLink = twitterLink
        
        let store = TestStore(initialState: northernLine,
                              reducer: LineStatusDetail.reducer,
                              environment: .unitTest)
        
        
        // 1. Activate twitter link
        store.assert(
            .send(.set(twitterLink: twitterLink, isActive: true)) {
                $0.activeTwitterLink = twitterLink
            }
        )
        
        // 2. Deactivate twitter link
        store.assert(
            .send(.set(twitterLink: twitterLink, isActive: false)) {
                $0.activeTwitterLink = nil
            }
        )
    }
    
}
