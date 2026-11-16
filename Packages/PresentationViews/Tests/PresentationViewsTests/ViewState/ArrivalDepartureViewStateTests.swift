import Foundation
import Models
import Testing

@testable import PresentationViews

struct ArrivalDepartureViewStateTests {

    @Test
    func transformArrivalDeparturesToUIState() {
        // Given
        let departures = [
            makeDeparture(platform: "Platform B", destination: "Reading", departingAt: "2025-11-07T19:20:00Z"),
            makeDeparture(platform: "Platform A", destination: "Abbey Wood", departingAt: "2025-11-07T19:15:00Z"),
            makeDeparture(platform: "Platform B", destination: "Heathrow T4", departingAt: "2025-11-07T19:05:00Z"),
            makeDeparture(platform: "Platform A", destination: "Shenfield", departingAt: "2025-11-07T19:10:00Z")
        ]

        // When
        let boardStates = departures.toPlatformBoardStates(forLineID: .elizabeth)

        // Then
        #expect(boardStates.map(\.platformName) == ["Platform A", "Platform B"])
        #expect(
            boardStates.map { $0.cellItems.map(\.id) } == [
                ["Platform A-Shenfield-1", "Platform A-Abbey Wood-2"],
                ["Platform B-Heathrow T4-1", "Platform B-Reading-2"]
            ]
        )
    }

    @Test
    func estimatedDepartureTimeTakesPriorityOverTheScheduledOne() {
        let departures = [
            makeDeparture(platform: "Platform A", destination: "Abbey Wood", departingAt: "2025-11-07T19:05:00Z", estimatedAt: "2025-11-07T19:12:00Z"),
            makeDeparture(platform: "Platform A", destination: "Shenfield", departingAt: "2025-11-07T19:10:00Z")
        ]

        let boardStates = departures.toPlatformBoardStates(forLineID: .elizabeth)

        #expect(boardStates.map { $0.cellItems.map(\.id) } == [["Platform A-Shenfield-1", "Platform A-Abbey Wood-2"]])
    }
}

// MARK: - Private helpers

private extension ArrivalDepartureViewStateTests {

    func makeDeparture(
        platform: String,
        destination: String,
        departingAt scheduled: String,
        estimatedAt estimated: String? = nil
    ) -> ArrivalDeparture {
        ArrivalDeparture(
            platformName: platform,
            destinationName: destination,
            naptanId: "910GTOTCTRD",
            stationName: "Tottenham Court Road",
            estimatedTimeOfArrival: nil,
            scheduledTimeOfArrival: nil,
            estimatedTimeOfDeparture: estimated.map(iso8601),
            scheduledTimeOfDeparture: iso8601(scheduled),
            minutesAndSecondsToArrival: nil,
            minutesAndSecondsToDeparture: nil,
            departureStatus: .onTime
        )
    }

    func iso8601(_ string: String) -> Date {
        try! Date(string, strategy: .iso8601)
    }
}
