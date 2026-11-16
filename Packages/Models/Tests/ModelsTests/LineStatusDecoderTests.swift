import Foundation
import Testing

@testable import Models

struct LineStatusDecoderTests {

    // MARK: - Line

    @Test
    func decodedGoodServiceLine() throws {
        let json = """
            {
                "$type": "Tfl.Api.Presentation.Entities.Line, Tfl.Api.Presentation.Entities",
                "id": "bakerloo",
                "name": "Bakerloo",
                "modeName": "tube",
                "lineStatuses": [
                    {
                        "$type": "Tfl.Api.Presentation.Entities.LineStatus, Tfl.Api.Presentation.Entities",
                        "id": 0,
                        "statusSeverity": 10,
                        "statusSeverityDescription": "Good Service",
                        "created": "0001-01-01T00:00:00",
                        "validityPeriods": []
                    }
                ]
            }
            """

        let line = try decode(Line.self, from: json)

        #expect(line == Line(id: .bakerloo, lineStatuses: [.goodService]))
    }

    @Test
    func decodedDisruptedLine() throws {
        let json = """
            {
                "id": "weaver",
                "name": "Weaver",
                "modeName": "overground",
                "lineStatuses": [
                    {
                        "statusSeverity": 5,
                        "statusSeverityDescription": "Part Closure",
                        "reason": "WEAVER: No service between Liverpool Street and Cheshunt.",
                        "disruption": {
                            "category": "PlannedWork",
                            "categoryDescription": "PlannedWork",
                            "description": "WEAVER: No service between Liverpool Street and Cheshunt.",
                            "additionalInfo": "Replacement buses operate."
                        }
                    },
                    {
                        "statusSeverity": 9,
                        "statusSeverityDescription": "Minor Delays",
                        "reason": "WEAVER: Minor delays between Hackney Downs and Chingford."
                    }
                ]
            }
            """

        let line = try decode(Line.self, from: json)

        #expect(line.id == .weaver)
        let statuses = try #require(line.lineStatuses)
        #expect(statuses.map(\.statusSeverity) == [.partClosure, .minorDelays])
        #expect(statuses.map(\.statusSeverityDescription) == ["Part Closure", "Minor Delays"])
        #expect(
            statuses.map(\.reason) == [
                "WEAVER: No service between Liverpool Street and Cheshunt.",
                "WEAVER: Minor delays between Hackney Downs and Chingford."
            ]
        )

        let disruption = try #require(statuses[0].disruption)
        #expect(disruption.category == .plannedWork)
        #expect(disruption.description == "WEAVER: No service between Liverpool Street and Cheshunt.")
        #expect(disruption.additionalInfo == "Replacement buses operate.")
        #expect(statuses[1].disruption == nil)
    }

    // MARK: - Lenient decoding

    @Test
    func unknownStatusSeverityDecodesAsNil() throws {
        let json = #"{ "statusSeverity": 99, "statusSeverityDescription": "Something New" }"#

        let status = try decode(LineStatus.self, from: json)

        #expect(status.statusSeverity == nil)
        #expect(status.statusSeverityDescription == "Something New")
    }

    @Test
    func unknownDisruptionCategoryDecodesAsNil() throws {
        let json = #"{ "category": "Roadworks", "description": "Roadworks outside the station." }"#

        let disruption = try decode(Disruption.self, from: json)

        #expect(disruption.category == nil)
        #expect(disruption.description == "Roadworks outside the station.")
    }

    @Test
    func malformedDisruptionDecodesAsNil() throws {
        let json = #"{ "statusSeverity": 6, "reason": "Severe delays.", "disruption": "not an object" }"#

        let status = try decode(LineStatus.self, from: json)

        #expect(status.disruption == nil)
        #expect(status.statusSeverity == .severeDelays)
        #expect(status.reason == "Severe delays.")
    }

    // MARK: - DisruptedPoint

    @Test
    func decodedDisruptedPoint() throws {
        let json = """
            {
                "$type": "Tfl.Api.Presentation.Entities.DisruptedPoint, Tfl.Api.Presentation.Entities",
                "atcoCode": "940GZZLUKSH",
                "description": "KENTISH TOWN UNDERGROUND STATION: The station will close from Monday 26 June.",
                "commonName": "Kentish Town Underground Station",
                "type": "Closure",
                "appearance": "PlannedWork"
            }
            """

        let point = try decode(DisruptedPoint.self, from: json)

        #expect(point.atcoCode == "940GZZLUKSH")
        #expect(point.description == "KENTISH TOWN UNDERGROUND STATION: The station will close from Monday 26 June.")
        #expect(point.type == "Closure")
        #expect(point.appearance == .plannedWork)
    }

    @Test
    func unknownDisruptedPointAppearanceDecodesAsNil() throws {
        let json = #"{ "atcoCode": "940GZZLULNB", "description": "Lifts are out of service.", "appearance": "Whatever" }"#

        let point = try decode(DisruptedPoint.self, from: json)

        #expect(point.appearance == nil)
        #expect(point.atcoCode == "940GZZLULNB")
        #expect(point.description == "Lifts are out of service.")
    }
}

// MARK: - Private helpers

private extension LineStatusDecoderTests {

    func decode<T: Decodable>(_ type: T.Type, from json: String) throws -> T {
        try JSONDecoder.tflModelDecoder.decode(type, from: Data(json.utf8))
    }
}
