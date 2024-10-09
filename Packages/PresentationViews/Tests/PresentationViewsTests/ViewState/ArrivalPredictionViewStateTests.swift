import Models
import ModelStubs
import Testing

@testable import PresentationViews

struct ArrivalPredictionViewStateTests {
    
    @Test
    func transformArrivalPredictionsToUIState() {
        // Given
        let northernLineBothPlatformArrivals = ModelStubs.northernLineBothPlatforms
        
        // When
        let boardStates = northernLineBothPlatformArrivals.toPlatformBoardStates()
        
        // Then
        #expect(boardStates.map(\.platformName) == ["Northbound - Platform 7",
                                                    "Southbound - Platform 8"])
    }
}
