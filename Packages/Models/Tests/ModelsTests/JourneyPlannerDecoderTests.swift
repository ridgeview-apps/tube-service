import Foundation
import Shared
import Testing

@testable import Models
@testable import ModelStubs

struct JourneyPlannerDecoderTests {

    // MARK: - Journey (tube)

    @Test
    func decodedTubeJourneyDuration() {
        #expect(ModelStubs.journeyByTube.duration == 23)
    }

    @Test
    func decodedTubeJourneyDates() {
        #expect(ModelStubs.journeyByTube.startDateTime == londonDatetime(12, 3, 2024, hour: 12, minute: 4))
        #expect(ModelStubs.journeyByTube.arrivalDateTime == londonDatetime(12, 3, 2024, hour: 12, minute: 27))
    }

    @Test
    func decodedTubeJourneyFirstLegIsWalking() {
        #expect(ModelStubs.journeyByTube.legs?[0].modeID == .walking)
    }

    @Test
    func decodedTubeJourneySecondLegLine() {
        #expect(ModelStubs.journeyByTube.legs?[1].trainLineID == .piccadilly)
        #expect(ModelStubs.journeyByTube.legs?[1].modeID == .tube)
    }

    @Test
    func decodedTubeJourneyStopPoints() {
        let stopPoints = ModelStubs.journeyByTube.legs?[1].stopPoints ?? []
        #expect(stopPoints[0].name == "Russell Square Underground Station")
        #expect(stopPoints[1].name == "Holborn Underground Station")
        #expect(stopPoints[2].name == "Covent Garden Underground Station")
    }

    @Test
    func decodedTubeJourneyEndpoints() {
        #expect(
            ModelStubs.journeyByTube.legs?[1].departurePoint?.commonName
                == "King's Cross St. Pancras Underground Station"
        )
        #expect(
            ModelStubs.journeyByTube.legs?[1].arrivalPoint?.commonName
                == "Leicester Square Underground Station"
        )
    }

    // MARK: - Journey (walking)

    @Test
    func decodedWalkingJourneyDuration() {
        #expect(ModelStubs.journeyByWalking.duration == 50)
    }

    @Test
    func decodedWalkingJourneyLegMode() {
        #expect(ModelStubs.journeyByWalking.legs?.first?.modeID == .walking)
    }

    @Test
    func decodedWalkingJourneyInstruction() {
        #expect(ModelStubs.journeyByWalking.legs?.first?.instruction?.summary == "Walk to Waterloo Station")
    }

    // MARK: - JourneyResults

    @Test
    func decodedJourneyResultsCount() {
        #expect(ModelStubs.journeyResultsKingsXToWaterlooNow.journeys?.count == 3)
        #expect(ModelStubs.journeyResultsKingsXToWaterlooEarlier.journeys?.count == 3)
        #expect(ModelStubs.journeyResultsKingsXToWaterlooLater.journeys?.count == 3)
    }

    @Test
    func decodedJourneyResultsSearchCriteria() {
        let criteria = ModelStubs.journeyResultsKingsXToWaterlooNow.searchCriteria
        #expect(criteria?.dateTime == londonDatetime(29, 5, 2026, hour: 14, minute: 40))
        #expect(criteria?.dateTimeType == "Departing")
    }

    @Test
    func decodedJourneyResultsTimeAdjustments() {
        let adjustments = ModelStubs.journeyResultsKingsXToWaterlooNow.searchCriteria?.timeAdjustments
        #expect(
            adjustments?.earlier == JourneyTimeAdjustment(date: "20260529", time: "1425", timeIs: "departing")
        )
        #expect(
            adjustments?.later == JourneyTimeAdjustment(date: "20260529", time: "1450", timeIs: "departing")
        )
    }

    // MARK: - Journey with disruptions

    @Test
    func decodedJourneyWithLongDisruptionMessageLegsNonEmpty() {
        #expect(ModelStubs.journeyWithLongDisruptionMessage.legs?.isEmpty == false)
    }
}

// MARK: - Private helpers

private extension JourneyPlannerDecoderTests {
    func londonDatetime(_ day: Int, _ month: Int, _ year: Int, hour: Int, minute: Int) -> Date {
        let components = DateComponents(
            calendar: .london,
            timeZone: .london,
            year: year,
            month: month,
            day: day,
            hour: hour,
            minute: minute
        )
        return Calendar.london.date(from: components)!
    }
}
