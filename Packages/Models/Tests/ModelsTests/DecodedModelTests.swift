import Foundation
import Testing
import Shared

@testable import Models
@testable import ModelStubs

struct ModelDecoderTests {

    @Test
    func decodedLineStatuses() throws {
        let lineStatusesToday = try decodeRawJSONString(lineStatusesTodayJSON, asType: [Line].self)
        let lineStatusesFuture = try decodeRawJSONString(lineStatusesFutureJSON, asType: [Line].self)
        let lineStatusGood = try decodeRawJSONString(lineStatusGoodServiceJSON, asType: Line.self)
        let lineStatusDisrupted = try decodeRawJSONString(lineStatusDisruptedJSON, asType: Line.self)

        #expect(!lineStatusesToday.isEmpty)
        #expect(!lineStatusesFuture.isEmpty)
        #expect(!lineStatusGood.isDisrupted)
        #expect(lineStatusDisrupted.isDisrupted)
    }

    @Test
    func decodedArrivalPredictions() throws {
        let singleLineArrivals = try decodeRawJSONString(northernLineArrivalsJSON, asType: [ArrivalPrediction].self)
        let multiLineArrivals = try decodeRawJSONString(hammerDistrictAndCircleArrivalsJSON, asType: [ArrivalPrediction].self)

        #expect(!singleLineArrivals.isEmpty)
        #expect(!multiLineArrivals.isEmpty)
    }

    @Test
    func decodedArrivalDepartures() throws {
        let elizabethLineArrivals = try decodeRawJSONString(elizabethLineArrivalsJSON, asType: [ArrivalDeparture].self)

        #expect(!elizabethLineArrivals.isEmpty)
    }

    @Test
    func decodedArrivalDeparturesWithUnsupportedStatusValues() throws {
        let arrivalDepartures = try decodeRawJSONString(
            elizabethLineArrivalsWithUnsupportedDepartureStatusJSON,
            asType: [ArrivalDeparture].self
        )

        #expect(!arrivalDepartures.isEmpty)
    }

    @Test
    func decodedArrivalDeparturesWithInvalidStatusTypes() throws {
        let arrivalDepartures = try decodeRawJSONString(
            elizabethLineArrivalsWithInvalidDepartureStatusTypeJSON,
            asType: [ArrivalDeparture].self
        )

        #expect(!arrivalDepartures.isEmpty)
    }

    @Test
    func decodedDisruptionPoints() throws {
        let disruptedPoints = try decodeRawJSONString(disruptedStationsJSON, asType: [DisruptedPoint].self)

        #expect(!disruptedPoints.isEmpty)
    }

    @Test
    func decodedTubeJourneyResult() throws {
        let journey = try decodeRawJSONString(journeyByTubeJSON, asType: Journey.self)

        #expect(journey.legs?[0].modeID == .walking)

        #expect(journey.legs?[1].trainLineID == .piccadilly)
        #expect(journey.legs?[1].modeID == .tube)
        #expect(journey.legs?[1].stopPoints[0].name == "Russell Square Underground Station")
        #expect(journey.legs?[1].stopPoints[1].name == "Holborn Underground Station")
        #expect(journey.legs?[1].stopPoints[2].name == "Covent Garden Underground Station")
        #expect(journey.legs?[1].departurePoint?.commonName == "King's Cross St. Pancras Underground Station")
        #expect(journey.legs?[1].arrivalPoint?.commonName == "Leicester Square Underground Station")
    }

    @Test(.disabled("Pending further investigation"))
    func decodedJourneyResults() async throws {
        let resultsNow = try decodeRawJSONString(journeyResultsKingsXToWaterlooNowJSON, asType: JourneyResults.self)
        let resultsEarlierJourneys = try decodeRawJSONString(journeyResultsKingsXToWaterlooEarlierJSON, asType: JourneyResults.self)
        let resultsLaterJourneys = try decodeRawJSONString(journeyResultsKingsXToWaterlooLaterJSON, asType: JourneyResults.self)
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
    func decodedSystemStatus() throws {
        let systemStatusOK = try decodeRawJSONString(systemStatusOKJSON, asType: SystemStatus.self)
        let systemStatusOutage = try decodeRawJSONString(systemStatusOutageJSON, asType: SystemStatus.self)
        let systemStatusResolved = try decodeRawJSONString(systemStatusResolvedJSON, asType: SystemStatus.self)

        #expect(systemStatusOK.status == .ok)
        #expect(systemStatusOutage.status == .outage)
        #expect(systemStatusResolved.status == .resolved)
    }
}


enum ModelDecoderTestError: Error {
    case invalidJSON
}

private extension ModelDecoderTests {

    private func decodeRawJSONString<D: Decodable>(_ rawJSON: String, asType type: D.Type) throws -> D {
        guard let jsonData = rawJSON.data(using: .utf8) else {
            throw ModelDecoderTestError.invalidJSON
        }

        return try JSONDecoder.defaultModelDecoder.decode(type, from: jsonData)
    }

    private func dayMonthYear(
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
