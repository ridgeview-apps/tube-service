import Foundation
import Testing

@testable import Models

struct ArrivalsDecoderTests {

    // MARK: - ArrivalPrediction

    @Test
    func decodedArrivalPrediction() throws {
        let json = """
            {
                "$type": "Tfl.Api.Presentation.Entities.Prediction, Tfl.Api.Presentation.Entities",
                "id": "-524999732",
                "naptanId": "940GZZLUKSX",
                "stationName": "King's Cross St. Pancras Underground Station",
                "lineId": "northern",
                "lineName": "Northern",
                "platformName": "Southbound - Platform 8",
                "destinationNaptanId": "940GZZLUMDN",
                "destinationName": "Morden Underground Station",
                "timeToStation": 1119,
                "currentLocation": "Between Hendon Central and Brent Cross",
                "towards": "Morden via Bank",
                "expectedArrival": "2020-08-05T16:34:11Z",
                "modeName": "tube"
            }
            """

        let arrival = try decode(ArrivalPrediction.self, from: json)

        #expect(
            arrival
                == ArrivalPrediction(
                    id: "-524999732",
                    currentLocation: "Between Hendon Central and Brent Cross",
                    destinationName: "Morden Underground Station",
                    destinationNaptanID: "940GZZLUMDN",
                    lineID: .northern,
                    naptanID: "940GZZLUKSX",
                    platformName: "Southbound - Platform 8",
                    timeToStation: 1119,
                    towards: "Morden via Bank"
                )
        )
    }

    // MARK: - ArrivalDeparture

    @Test
    func decodedDelayedArrivalDeparture() throws {
        let json = """
            {
                "$type": "Tfl.Api.Presentation.Entities.ArrivalDeparture, Tfl.Api.Presentation.Entities",
                "platformName": "Platform B",
                "destinationNaptanId": "910GHTRWTM4",
                "destinationName": "Heathrow Terminal 4 Rail Station",
                "naptanId": "910GTOTCTRD",
                "stationName": "Tottenham Court Road",
                "scheduledTimeOfArrival": "2025-11-07T18:59:00Z",
                "scheduledTimeOfDeparture": "2025-11-07T19:00:00Z",
                "minutesAndSecondsToArrival": "",
                "minutesAndSecondsToDeparture": "",
                "departureStatus": "Delayed"
            }
            """

        let arrival = try decode(ArrivalDeparture.self, from: json)

        #expect(
            arrival
                == ArrivalDeparture(
                    platformName: "Platform B",
                    destinationName: "Heathrow Terminal 4 Rail Station",
                    naptanId: "910GTOTCTRD",
                    stationName: "Tottenham Court Road",
                    estimatedTimeOfArrival: nil,
                    scheduledTimeOfArrival: iso8601("2025-11-07T18:59:00Z"),
                    estimatedTimeOfDeparture: nil,
                    scheduledTimeOfDeparture: iso8601("2025-11-07T19:00:00Z"),
                    minutesAndSecondsToArrival: "",
                    minutesAndSecondsToDeparture: "",
                    departureStatus: .delayed
                )
        )
    }

    @Test
    func decodedOnTimeArrivalDeparture() throws {
        let json = """
            {
                "platformName": "Platform B",
                "destinationName": "Heathrow Terminal 4 Rail Station",
                "naptanId": "910GTOTCTRD",
                "stationName": "Tottenham Court Road",
                "estimatedTimeOfArrival": "2025-11-07T19:17:00Z",
                "scheduledTimeOfArrival": "2025-11-07T19:16:00Z",
                "estimatedTimeOfDeparture": "2025-11-07T19:18:00Z",
                "scheduledTimeOfDeparture": "2025-11-07T19:17:00Z",
                "minutesAndSecondsToArrival": "13:17",
                "minutesAndSecondsToDeparture": "14:17",
                "departureStatus": "OnTime"
            }
            """

        let arrival = try decode(ArrivalDeparture.self, from: json)

        #expect(
            arrival
                == ArrivalDeparture(
                    platformName: "Platform B",
                    destinationName: "Heathrow Terminal 4 Rail Station",
                    naptanId: "910GTOTCTRD",
                    stationName: "Tottenham Court Road",
                    estimatedTimeOfArrival: iso8601("2025-11-07T19:17:00Z"),
                    scheduledTimeOfArrival: iso8601("2025-11-07T19:16:00Z"),
                    estimatedTimeOfDeparture: iso8601("2025-11-07T19:18:00Z"),
                    scheduledTimeOfDeparture: iso8601("2025-11-07T19:17:00Z"),
                    minutesAndSecondsToArrival: "13:17",
                    minutesAndSecondsToDeparture: "14:17",
                    departureStatus: .onTime
                )
        )
    }

    // MARK: - DepartureStatus

    @Test(
        arguments: zip(
            ["OnTime", "Delayed", "Cancelled", "NotStoppingAtStation"],
            [DepartureStatus.onTime, .delayed, .cancelled, .notStoppingAtStation]
        )
    )
    func decodedDepartureStatus(rawValue: String, expected: DepartureStatus) throws {
        let status = try decode(DepartureStatus.self, from: "\"\(rawValue)\"")

        #expect(status == expected)
    }

    // MARK: - Lenient decoding

    @Test(arguments: [#""BoardingSoon""#, "123"])
    func unrecognisedDepartureStatusDecodesAsNil(departureStatusJSON: String) throws {
        let json = #"{ "platformName": "Platform B", "departureStatus": \#(departureStatusJSON) }"#

        let arrival = try decode(ArrivalDeparture.self, from: json)

        #expect(arrival.departureStatus == nil)
        #expect(arrival.platformName == "Platform B")
    }

    @Test
    func malformedArrivalDepartureTimeDecodesAsNil() throws {
        let json = """
            {
                "platformName": "Platform A",
                "scheduledTimeOfArrival": "shortly",
                "scheduledTimeOfDeparture": "2025-11-07T19:00:00Z"
            }
            """

        let arrival = try decode(ArrivalDeparture.self, from: json)

        #expect(arrival.scheduledTimeOfArrival == nil)
        #expect(arrival.scheduledTimeOfDeparture == iso8601("2025-11-07T19:00:00Z"))
    }
}

// MARK: - Private helpers

private extension ArrivalsDecoderTests {

    func decode<T: Decodable>(_ type: T.Type, from json: String) throws -> T {
        try JSONDecoder.tflModelDecoder.decode(type, from: Data(json.utf8))
    }

    func iso8601(_ string: String) -> Date {
        try! Date(string, strategy: .iso8601)
    }
}
