import Models
import ModelStubs
import XCTest

@testable import PresentationViews

final class ArrivalPredictionViewStateTests: XCTestCase {
    
    func testTransformArrivalPredictionsToUIState() {
        // Given
        let northernLineBothPlatformArrivals = ModelStubs.northernLineBothPlatforms
        
        // When
        let boardStates = northernLineBothPlatformArrivals.toPlatformBoardStates()
        
        // Then
        XCTAssertEqual(
            ["Northbound - Platform 7", "Southbound - Platform 8"],
            boardStates.map(\.platformName)
        )
    }
}
