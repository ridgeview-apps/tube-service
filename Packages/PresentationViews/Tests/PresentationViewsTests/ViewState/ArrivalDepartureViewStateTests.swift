import Models
import ModelStubs
import Testing

@testable import PresentationViews

struct ArrivalDepartureViewStateTests {
    
    @Test
    func transformArrivalDeparturesToUIState() {
        // Given
        let elizabethLineBothPlatforms = ModelStubs.elizabethLineBothPlatforms
        
        // When
        let boardStates = elizabethLineBothPlatforms.toPlatformBoardStates(forLineID: .elizabeth)
        
        // Then
        #expect(boardStates.map(\.platformName) == ["Platform A",
                                                    "Platform B"])
    }
}
