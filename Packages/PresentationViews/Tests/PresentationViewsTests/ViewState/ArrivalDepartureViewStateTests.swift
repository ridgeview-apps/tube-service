import Models
import ModelStubs
import XCTest

@testable import PresentationViews

final class ArrivalDepartureViewStateTests: XCTestCase {
    
    func testTransformDeparturesToUIState() {
        // Given
        let elizabethLineBothPlatforms = ModelStubs.elizabethLineBothPlatforms
        
        // When
        let boardStates = elizabethLineBothPlatforms.toPlatformBoardStates(forLineID: .elizabeth)
        
        // Then
        XCTAssertEqual(
            ["Platform A", "Platform B"], 
            boardStates.map(\.platformName)
        )
    }
}
