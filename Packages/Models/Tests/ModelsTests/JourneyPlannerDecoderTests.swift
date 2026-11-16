import Foundation
import Testing

@testable import Models

struct JourneyPlannerDecoderTests {

    // MARK: - Journey

    @Test
    func decodedTubeJourney() throws {
        let json = """
            {
                "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.Journey, Tfl.Api.Presentation.Entities",
                "startDateTime": "2024-03-12T12:04:00",
                "duration": 23,
                "arrivalDateTime": "2024-03-12T12:27:00",
                "legs": [
                    {
                        "duration": 4,
                        "instruction": { "summary": "Walk to King's Cross St. Pancras" },
                        "mode": { "id": "walking", "name": "walking" }
                    },
                    {
                        "duration": 9,
                        "instruction": { "summary": "Piccadilly line to Leicester Square" },
                        "departureTime": "2024-03-12T12:10:00",
                        "arrivalTime": "2024-03-12T12:19:00",
                        "departurePoint": { "commonName": "King's Cross St. Pancras Underground Station" },
                        "arrivalPoint": { "commonName": "Leicester Square Underground Station" },
                        "routeOptions": [{ "name": "Piccadilly", "lineIdentifier": { "id": "piccadilly", "name": "Piccadilly" } }],
                        "mode": { "id": "tube", "name": "tube" },
                        "path": {
                            "stopPoints": [
                                { "id": "940GZZLURSQ", "name": "Russell Square Underground Station" },
                                { "id": "940GZZLUHBN", "name": "Holborn Underground Station" },
                                { "id": "940GZZLUCGN", "name": "Covent Garden Underground Station" },
                                { "id": "940GZZLULSQ", "name": "Leicester Square Underground Station" }
                            ]
                        }
                    }
                ]
            }
            """

        let journey = try decode(Journey.self, from: json)

        #expect(journey.duration == 23)
        #expect(journey.startDateTime == iso8601("2024-03-12T12:04:00Z"))
        #expect(journey.arrivalDateTime == iso8601("2024-03-12T12:27:00Z"))

        let legs = try #require(journey.legs)
        #expect(legs.map(\.modeID) == [.walking, .tube])
        #expect(legs.map(\.duration) == [4, 9])

        let tubeLeg = legs[1]
        #expect(tubeLeg.trainLineID == .piccadilly)
        #expect(tubeLeg.instruction?.summary == "Piccadilly line to Leicester Square")
        #expect(tubeLeg.departureTime == iso8601("2024-03-12T12:10:00Z"))
        #expect(tubeLeg.arrivalTime == iso8601("2024-03-12T12:19:00Z"))
        #expect(tubeLeg.departurePoint?.commonName == "King's Cross St. Pancras Underground Station")
        #expect(tubeLeg.arrivalPoint?.commonName == "Leicester Square Underground Station")
        #expect(
            tubeLeg.stopPoints.map(\.name) == [
                "Russell Square Underground Station",
                "Holborn Underground Station",
                "Covent Garden Underground Station",
                "Leicester Square Underground Station"
            ]
        )
    }

    @Test
    func decodedJourneyLegDisruptions() throws {
        let json = """
            {
                "legs": [
                    { "mode": { "id": "walking" }, "disruptions": [] },
                    {
                        "mode": { "id": "tube" },
                        "disruptions": [
                            { "category": "RealTime", "description": "Bakerloo Line: Minor delays due to train cancellations." }
                        ]
                    }
                ]
            }
            """

        let journey = try decode(Journey.self, from: json)

        #expect(journey.legs?[0].disruptions?.isEmpty == true)
        let disruption = try #require(journey.legs?[1].disruptions?.first)
        #expect(disruption.category == .realTime)
        #expect(disruption.description == "Bakerloo Line: Minor delays due to train cancellations.")
    }

    // MARK: - JourneyResults

    @Test
    func decodedJourneyResults() throws {
        let json = """
            {
                "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.ItineraryResult, Tfl.Api.Presentation.Entities",
                "journeys": [
                    { "startDateTime": "2026-05-29T14:42:00", "duration": 21, "arrivalDateTime": "2026-05-29T15:03:00" },
                    { "startDateTime": "2026-05-29T14:45:00", "duration": 24, "arrivalDateTime": "2026-05-29T15:09:00" }
                ],
                "searchCriteria": {
                    "dateTime": "2026-05-29T14:40:00",
                    "dateTimeType": "Departing",
                    "timeAdjustments": {
                        "earliest": { "date": "20260529", "time": "0300", "timeIs": "departing" },
                        "earlier": { "date": "20260529", "time": "1425", "timeIs": "departing" },
                        "later": { "date": "20260529", "time": "1450", "timeIs": "departing" },
                        "latest": { "date": "20260530", "time": "0300", "timeIs": "departing" }
                    }
                }
            }
            """

        let results = try decode(JourneyResults.self, from: json)

        #expect(results.journeys?.map(\.duration) == [21, 24])

        let criteria = try #require(results.searchCriteria)
        #expect(criteria.dateTime == iso8601("2026-05-29T13:40:00Z"))
        #expect(criteria.dateTimeType == "Departing")
        #expect(criteria.timeAdjustments?.earlier == JourneyTimeAdjustment(date: "20260529", time: "1425", timeIs: "departing"))
        #expect(criteria.timeAdjustments?.later == JourneyTimeAdjustment(date: "20260529", time: "1450", timeIs: "departing"))
    }

    // MARK: - Lenient decoding

    @Test
    func malformedLegFieldsDecodeAsNil() throws {
        let json = """
            {
                "duration": 9,
                "instruction": "not an object",
                "departureTime": "shortly",
                "mode": { "id": "tube" },
                "disruptions": "not an array"
            }
            """

        let leg = try decode(JourneyLeg.self, from: json)

        #expect(leg.instruction == nil)
        #expect(leg.departureTime == nil)
        #expect(leg.disruptions == nil)
        #expect(leg.duration == 9)
        #expect(leg.modeID == .tube)
    }

    @Test
    func unknownLegModeHasNoModeID() throws {
        let leg = try decode(JourneyLeg.self, from: #"{ "mode": { "id": "hoverboard", "name": "hoverboard" } }"#)

        #expect(leg.mode?.id == "hoverboard")
        #expect(leg.modeID == nil)
    }
}

// MARK: - Private helpers

private extension JourneyPlannerDecoderTests {

    func decode<T: Decodable>(_ type: T.Type, from json: String) throws -> T {
        try JSONDecoder.tflModelDecoder.decode(type, from: Data(json.utf8))
    }

    func iso8601(_ string: String) -> Date {
        try! Date(string, strategy: .iso8601)
    }
}
