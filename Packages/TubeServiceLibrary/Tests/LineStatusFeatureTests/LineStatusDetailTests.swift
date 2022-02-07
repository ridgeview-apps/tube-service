import XCTest
import ComposableArchitecture
import Combine
import LineStatusFeature

class LineStatusDetailTest: XCTestCase {
    
    let scheduler = DispatchQueue.test
    
    func testOnAppear() throws {
        
        let store = TestStore(initialState: .fake(),
                              reducer: LineStatusDetail.reducer,
                              environment: ())
        
        // 1. Appearing for first time (load triggered)
        store.send(.onAppear) {
            $0.twitterLinks = [
                .init(style: .tflAllTweets,
                      url: URL(string: "https://twitter.com/TfL/with_replies")!),
                .init(style: .lineTweets(lineId: .northern),
                      url: URL(string: "https://twitter.com/search?q=(from:TfL%20OR%20to:TfL)%20northern%20line&f=live")!)
            ]
            $0.hasLoaded = true
        }
        
        // 2. Re-appearing (load not triggered)
        store.send(.onAppear) { _ in /* No state changes */ }
    }
    
    func testTapTwitterLinks() throws {
        
        var northernLine  = LineStatusDetail.State.fake(for: .northern)
        
        let twitterLink = LineStatusDetail.TwitterLink.fake()
        northernLine.twitterLinks = [twitterLink]
        
        let store = TestStore(initialState: northernLine,
                              reducer: LineStatusDetail.reducer,
                              environment: ())
        
        
        // 1. Activate twitter link
        store.send(.setActiveTwitterLink(to: twitterLink)) {
            $0.activeTwitterLink = twitterLink
        }
        
        // 2. Deactivate twitter link
        store.send(.setActiveTwitterLink(to: nil)) {
            $0.activeTwitterLink = nil
        }
    }
    
}
