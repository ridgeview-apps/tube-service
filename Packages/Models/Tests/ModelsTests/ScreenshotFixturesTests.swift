import Foundation
import Testing

@testable import ModelStubs
@testable import Models

struct ScreenshotFixturesTests {

    typealias Fixtures = ModelStubs.Screenshots

    // Friday 12 June 2026, 09:41 in London (`UITestScenario.Fixtures.now`): the time the fixtures are dated around.
    let now = Date(timeIntervalSince1970: 1_781_253_660)

    @Test
    func decodeEveryResponse() {
        #expect(!Fixtures.lineStatusesToday.isEmpty)
        #expect(!Fixtures.lineStatusesFuture.isEmpty)
        #expect(!Fixtures.kingsCrossArrivals.isEmpty)
        #expect(!Fixtures.abbeyWoodDepartures.isEmpty)
        #expect(!Fixtures.disruptedStations.isEmpty)
        #expect(!(Fixtures.journeyResults.journeys ?? []).isEmpty)
    }

    @Test
    func departuresAndJourneysStartJustAfterNow() throws {
        let firstDeparture = try #require(Fixtures.abbeyWoodDepartures.compactMap(\.scheduledTimeOfDeparture).min())
        let firstJourney = try #require(Fixtures.journeyResults.journeys?.compactMap(\.startDateTime).min())

        for start in [firstDeparture, firstJourney] {
            #expect(start >= now)
            #expect(start < now + 15 * 60)
        }
    }
}
