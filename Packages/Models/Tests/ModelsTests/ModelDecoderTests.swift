import Foundation
import Testing
import Shared

@testable import Models
@testable import ModelStubs

struct ModelDecoderTests {

    @Test
    func decodedLineStatuses() {
        #expect(!ModelStubs.lineStatusesToday.isEmpty)
        #expect(!ModelStubs.lineStatusesFuture.isEmpty)
        #expect(!ModelStubs.lineStatusGoodService.isDisrupted)
        #expect(ModelStubs.lineStatusDisrupted.isDisrupted)
    }

    @Test
    func decodedArrivalPredictions() {
        #expect(!ModelStubs.northernLineBothPlatforms.isEmpty)
        #expect(!ModelStubs.hammerDistrictAndCircleBothPlatforms.isEmpty)
    }

    @Test
    func decodedArrivalDepartures() {
        #expect(!ModelStubs.elizabethLineBothPlatforms.isEmpty)
    }

    @Test
    func decodedArrivalDeparturesWithUnsupportedStatusValues() throws {
        let json = loadJSON(named: "elizabethLineArrivals")
            .replacingOccurrences(of: "\"departureStatus\": \"Delayed\"", with: "\"departureStatus\": \"BoardingSoon\"")
        let arrivals = try JSONDecoder.defaultModelDecoder.decode([ArrivalDeparture].self, from: Data(json.utf8))
        #expect(!arrivals.isEmpty)
    }

    @Test
    func decodedArrivalDeparturesWithInvalidStatusTypes() throws {
        let json = loadJSON(named: "elizabethLineArrivals")
            .replacingOccurrences(of: "\"departureStatus\": \"Delayed\"", with: "\"departureStatus\": 123")
        let arrivals = try JSONDecoder.defaultModelDecoder.decode([ArrivalDeparture].self, from: Data(json.utf8))
        #expect(!arrivals.isEmpty)
    }

    @Test
    func decodedDisruptionPoints() {
        #expect(!ModelStubs.disruptedStations.isEmpty)
    }

    @Test
    func decodedTubeJourneyResult() {
        let journey = ModelStubs.journeyByTube

        #expect(journey.legs?[0].modeID == .walking)

        #expect(journey.legs?[1].trainLineID == .piccadilly)
        #expect(journey.legs?[1].modeID == .tube)
        #expect(journey.legs?[1].stopPoints[0].name == "Russell Square Underground Station")
        #expect(journey.legs?[1].stopPoints[1].name == "Holborn Underground Station")
        #expect(journey.legs?[1].stopPoints[2].name == "Covent Garden Underground Station")
        #expect(journey.legs?[1].departurePoint?.commonName == "King's Cross St. Pancras Underground Station")
        #expect(journey.legs?[1].arrivalPoint?.commonName == "Leicester Square Underground Station")
    }

    @Test
    func decodedJourneyResults() {
        let resultsNow = ModelStubs.journeyResultsKingsXToWaterlooNow
        let resultsEarlierJourneys = ModelStubs.journeyResultsKingsXToWaterlooEarlier
        let resultsLaterJourneys = ModelStubs.journeyResultsKingsXToWaterlooLater
        let expectedEarlierJourney = JourneyTimeAdjustment(
            date: "20260529",
            time: "1425",
            timeIs: "departing"
        )
        let expectedLaterJourney = JourneyTimeAdjustment(
            date: "20260529",
            time: "1450",
            timeIs: "departing"
        )

        #expect(resultsNow.journeys?.count == 3)
        #expect(
            resultsNow.searchCriteria?.dateTime
                == dayMonthYear(
                    29,
                    5,
                    2026,
                    hour: 14,
                    minute: 40,
                    in: .london
                )
        )
        #expect(resultsNow.searchCriteria?.dateTimeType == "Departing")
        #expect(resultsNow.searchCriteria?.timeAdjustments?.earlier == expectedEarlierJourney)
        #expect(resultsNow.searchCriteria?.timeAdjustments?.later == expectedLaterJourney)
        #expect(resultsEarlierJourneys.journeys?.count == 3)
        #expect(resultsLaterJourneys.journeys?.count == 3)
    }

    @Test
    func decodedSystemStatus() {
        #expect(ModelStubs.systemStatusOK.status == .ok)
        #expect(ModelStubs.systemStatusOutage.status == .outage)
        #expect(ModelStubs.systemStatusResolved.status == .resolved)
    }
}

private extension ModelDecoderTests {

    func dayMonthYear(
        _ day: Int,
        _ month: Int,
        _ year: Int,
        hour: Int,
        minute: Int,
        in calendar: Calendar
    ) -> Date {
        let dateComponents = DateComponents(
            calendar: calendar,
            timeZone: calendar.timeZone,
            year: year,
            month: month,
            day: day,
            hour: hour,
            minute: minute
        )
        return calendar.date(from: dateComponents)!
    }
}
