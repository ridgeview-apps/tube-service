import Models
import Testing

@testable import PresentationViews

struct ArrivalPredictionViewStateTests {

    @Test
    func transformArrivalPredictionsToUIState() {
        // Given
        let arrivals = [
            makeArrival("south-later", platform: "Southbound - Platform 8", timeToStation: 600),
            makeArrival("north-later", platform: "Northbound - Platform 7", timeToStation: 420),
            makeArrival("south-sooner", platform: "Southbound - Platform 8", timeToStation: 60),
            makeArrival("north-sooner", platform: "Northbound - Platform 7", timeToStation: 180)
        ]

        // When
        let boardStates = arrivals.toPlatformBoardStates()

        // Then
        #expect(boardStates.map(\.platformName) == ["Northbound - Platform 7", "Southbound - Platform 8"])
        #expect(boardStates.map { $0.cellItems.map(\.id) } == [["north-sooner-1", "north-later-2"], ["south-sooner-1", "south-later-2"]])
    }

    @Test
    func arrivalPredictionsWithoutALineAreLeftOffTheBoard() {
        let arrivals = [
            makeArrival("with-line", platform: "Northbound - Platform 7", timeToStation: 60),
            makeArrival("without-line", platform: "Northbound - Platform 7", timeToStation: 120, lineID: nil)
        ]

        let boardStates = arrivals.toPlatformBoardStates()

        #expect(boardStates.map { $0.cellItems.map(\.id) } == [["with-line-1"]])
    }
}

// MARK: - Private helpers

private extension ArrivalPredictionViewStateTests {

    func makeArrival(
        _ id: String,
        platform: String,
        timeToStation: Int,
        lineID: TrainLineID? = .northern
    ) -> ArrivalPrediction {
        ArrivalPrediction(
            id: id,
            currentLocation: nil,
            destinationName: "Morden Underground Station",
            destinationNaptanID: "940GZZLUMDN",
            lineID: lineID,
            naptanID: "940GZZLUKSX",
            platformName: platform,
            timeToStation: timeToStation,
            towards: "Morden via Bank"
        )
    }
}
