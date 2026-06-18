import Foundation
import Testing

@testable import Models
@testable import ModelStubs

struct ArrivalsDecoderTests {

    // MARK: - ArrivalPrediction

    @Test
    func decodedArrivalPredictionsIsNonEmpty() {
        #expect(!ModelStubs.northernLineBothPlatforms.isEmpty)
    }

    @Test
    func decodedSouthboundArrivalLineID() throws {
        let arrival = try #require(ModelStubs.northernLineSouthboundArrivals.first)
        #expect(arrival.lineID == .northern)
    }

    @Test
    func decodedSouthboundArrivalNaptanID() throws {
        let arrival = try #require(ModelStubs.northernLineSouthboundArrivals.first)
        #expect(arrival.naptanID == "940GZZLUKSX")
    }

    @Test
    func decodedSouthboundArrivalPlatformName() throws {
        let arrival = try #require(ModelStubs.northernLineSouthboundArrivals.first)
        #expect(arrival.platformName == "Southbound - Platform 8")
    }

    @Test
    func decodedSouthboundArrivalTimeToStation() throws {
        let arrival = try #require(ModelStubs.northernLineSouthboundArrivals.first)
        #expect(arrival.timeToStation == 1119)
    }

    @Test
    func decodedSouthboundArrivalTowards() throws {
        let arrival = try #require(ModelStubs.northernLineSouthboundArrivals.first)
        #expect(arrival.towards == "Morden via Bank")
    }

    @Test
    func decodedSouthboundArrivalCurrentLocation() throws {
        let arrival = try #require(ModelStubs.northernLineSouthboundArrivals.first)
        #expect(arrival.currentLocation == "Between Hendon Central and Brent Cross")
    }

    // MARK: - ArrivalDeparture

    @Test
    func decodedArrivalDeparturesIsNonEmpty() {
        #expect(!ModelStubs.elizabethLineBothPlatforms.isEmpty)
    }

    @Test
    func decodedDelayedArrivalDepartureFields() throws {
        let arrival = try #require(ModelStubs.elizabethLineArrivalsPlatformB.first)
        #expect(arrival.stationName == "Tottenham Court Road")
        #expect(arrival.naptanId == "910GTOTCTRD")
        #expect(arrival.destinationName == "Heathrow Terminal 4 Rail Station")
        #expect(arrival.platformName == "Platform B")
    }

    @Test
    func decodedDelayedArrivalScheduledTime() throws {
        let arrival = try #require(ModelStubs.elizabethLineArrivalsPlatformB.first)
        #expect(arrival.scheduledTimeOfArrival == iso8601("2025-11-07T18:59:00Z"))
    }

    @Test
    func decodedDelayedArrivalStatusAndEstimatedTime() throws {
        let arrival = try #require(ModelStubs.elizabethLineArrivalsPlatformB.first)
        #expect(arrival.departureStatus == .delayed)
        #expect(arrival.estimatedTimeOfArrival == nil)
    }

    @Test
    func decodedOnTimeArrivalHasEstimatedTimes() throws {
        let arrivals = ModelStubs.elizabethLineArrivalsPlatformB
        let onTime = try #require(arrivals.first { $0.departureStatus == .onTime })
        #expect(onTime.estimatedTimeOfArrival != nil)
        #expect(onTime.estimatedTimeOfDeparture != nil)
    }

    // MARK: - DepartureStatus

    @Test(
        arguments: zip(
            ["OnTime", "Delayed", "Cancelled", "NotStoppingAtStation"],
            [DepartureStatus.onTime, .delayed, .cancelled, .notStoppingAtStation]
        )
    )
    func decodedDepartureStatus(rawValue: String, expected: DepartureStatus) throws {
        let json = "\"\(rawValue)\""
        let status = try JSONDecoder.tflModelDecoder.decode(DepartureStatus.self, from: Data(json.utf8))
        #expect(status == expected)
    }

    @Test
    func decodedUnknownDepartureStatusIsNil() throws {
        let json = loadJSON(named: "elizabethLineArrivals")
            .replacingOccurrences(of: "\"departureStatus\": \"Delayed\"", with: "\"departureStatus\": \"BoardingSoon\"")
        let arrivals = try JSONDecoder.tflModelDecoder.decode([ArrivalDeparture].self, from: Data(json.utf8))
        #expect(!arrivals.isEmpty)
        #expect(arrivals.first?.departureStatus == nil)
    }

    @Test
    func decodedInvalidDepartureStatusTypeIsNil() throws {
        let json = loadJSON(named: "elizabethLineArrivals")
            .replacingOccurrences(of: "\"departureStatus\": \"Delayed\"", with: "\"departureStatus\": 123")
        let arrivals = try JSONDecoder.tflModelDecoder.decode([ArrivalDeparture].self, from: Data(json.utf8))
        #expect(!arrivals.isEmpty)
    }
}

// MARK: - Private helpers

private extension ArrivalsDecoderTests {
    func iso8601(_ string: String) -> Date {
        try! Date(string, strategy: .iso8601)
    }
}
