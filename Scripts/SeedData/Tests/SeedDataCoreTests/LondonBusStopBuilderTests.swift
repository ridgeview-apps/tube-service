import Foundation
import Testing

@testable import SeedDataCore

struct LondonBusStopBuilderTests {

    @Test
    func decodesABusStopPointsPage() throws {
        let json = """
            {
              "pageSize": 1000,
              "total": 32571,
              "page": 1,
              "stopPoints": [
                {
                  "naptanId": "490000129D",
                  "commonName": "King's Cross Station",
                  "stopType": "NaptanPublicBusCoachTram",
                  "stopLetter": "D",
                  "lat": 51.53045,
                  "lon": -0.12328,
                  "lines": [{ "id": "n63", "name": "N63", "type": "Line" }],
                  "lineModeGroups": [{ "modeName": "bus", "lineIdentifier": ["n63"] }],
                  "additionalProperties": [
                    { "category": "Direction", "key": "Towards", "sourceSystemKey": "CountDown", "value": "Farringdon" }
                  ]
                }
              ]
            }
            """

        let page = try JSONDecoder().decode(TfLStopPointsPage.self, from: Data(json.utf8))

        #expect(page.total == 32571)
        #expect(page.pageSize == 1000)
        #expect(
            page.stopPoints == [
                TfLStopPoint(
                    naptanId: "490000129D",
                    commonName: "King's Cross Station",
                    icsCode: nil,
                    lat: 51.53045,
                    lon: -0.12328,
                    stopType: "NaptanPublicBusCoachTram",
                    stopLetter: "D",
                    lines: [TfLIdentifier(id: "n63", name: "N63")],
                    lineModeGroups: [TfLLineModeGroup(modeName: "bus", lineIdentifier: ["n63"])],
                    additionalProperties: [TfLAdditionalProperty(category: "Direction", key: "Towards", value: "Farringdon")]
                )
            ]
        )
    }

    @Test
    func buildsAStopFromTfLAndNaptan() {
        let stopPoint = busStopPoint(
            id: "490000129D",
            name: "King's Cross Station",
            letter: "D",
            towards: "Farringdon Or Holborn Circus",
            compassPoint: "S",
            stopAreaID: "490G000479",
            routes: [("n63", "N63"), ("63", "63"), ("46", "46")]
        )
        let naptanStop = NaptanStop(atcoCode: "490000129D", naptanCode: "54174", localityName: "King's Cross", bearing: "SW", isHailAndRide: false)

        let result = LondonBusStopBuilder.build(stopPoints: [stopPoint], naptanStops: [naptanStop])

        #expect(
            result.stops == [
                LondonBusStop(
                    id: "490000129D",
                    name: "King's Cross Station",
                    locality: "King's Cross",
                    letter: "D",
                    towards: "Farringdon or Holborn Circus",
                    stopCode: "54174",
                    stopAreaID: "490G000479",
                    lat: 51.5,
                    lon: -0.1,
                    bearing: "S",
                    isHailAndRide: false,
                    routes: ["46", "63", "N63"]
                )
            ]
        )
    }

    @Test
    func takesHailAndRideAndTheBearingFromNaptanWhenTfLHasNone() {
        let stopPoint = busStopPoint(id: "490009313Z", name: "Longland Drive", letter: "->S", compassPoint: nil)
        let naptanStop = NaptanStop(atcoCode: "490009313Z", naptanCode: "95534", localityName: "Totteridge", bearing: "S", isHailAndRide: true)

        let stop = LondonBusStopBuilder.build(stopPoints: [stopPoint], naptanStops: [naptanStop]).stops.first

        #expect(stop?.isHailAndRide == true)
        #expect(stop?.bearing == "S")
        #expect(stop?.letter == nil)
    }

    @Test
    func countsStopsWithNoNaptanRow() {
        let result = LondonBusStopBuilder.build(stopPoints: [busStopPoint(id: "150042019001", name: "Alfred Road")], naptanStops: [])

        #expect(result.stops.map(\.stopCode) == [nil])
        #expect(result.stops.map(\.locality) == [nil])
        #expect(result.stopsNotInNaptanCount == 1)
    }

    @Test
    func keepsOnlyTopLevelBusStopsWithBusRoutes() {
        var stopPair = busStopPoint(id: "490G000479", name: "King's Cross")
        stopPair = TfLStopPoint(
            naptanId: stopPair.naptanId,
            commonName: stopPair.commonName,
            icsCode: nil,
            lat: stopPair.lat,
            lon: stopPair.lon,
            stopType: "NaptanOnstreetBusCoachStopPair",
            lines: stopPair.lines,
            lineModeGroups: stopPair.lineModeGroups
        )
        let tramOnly = busStopPoint(id: "490TRAM", name: "Tram Stop", routes: [("tram", "Tram")], mode: "tram")
        let noRoutes = busStopPoint(id: "4900002ZT", name: "Acton Town Station", routes: [])
        let noLocation = TfLStopPoint(naptanId: "490NOLOC", commonName: "Nowhere", icsCode: nil, lat: nil, lon: nil, stopType: "NaptanPublicBusCoachTram")

        let result = LondonBusStopBuilder.build(
            stopPoints: [stopPair, tramOnly, noRoutes, noLocation, busStopPoint(id: "490000129D", name: "King's Cross Station")],
            naptanStops: []
        )

        #expect(result.stops.map(\.id) == ["490000129D"])
        #expect(result.stopsWithoutRoutesCount == 2)
        #expect(result.incompleteStopPointNames == ["Nowhere"])
    }

    @Test
    func keepsTheFirstOfAStopListedTwice() {
        let result = LondonBusStopBuilder.build(
            stopPoints: [busStopPoint(id: "490000129D", name: "First"), busStopPoint(id: "490000129D", name: "Second")],
            naptanStops: []
        )

        #expect(result.stops.map(\.name) == ["First"])
    }

    @Test
    func sortsStopsByID() {
        let result = LondonBusStopBuilder.build(
            stopPoints: [busStopPoint(id: "490000129E", name: "B"), busStopPoint(id: "150042019001", name: "C"), busStopPoint(id: "490000129D", name: "A")],
            naptanStops: []
        )

        #expect(result.stops.map(\.id) == ["150042019001", "490000129D", "490000129E"])
    }

    @Test(arguments: [
        ("King's Cross Station   / York Way", "King's Cross Station / York Way"),
        (".Heathrow Central", "Heathrow Central"),
        (" Abbey Road ", "Abbey Road")
    ])
    func cleansNames(name: String, expected: String) {
        #expect(LondonBusStopBuilder.cleanedName(name) == expected)
    }

    static let towardsCases: [(String, String?)] = [
        ("Richmond Or  Barnes", "Richmond or Barnes"),
        ("Oxford Circus", "Oxford Circus"),
        ("  ", nil)
    ]

    @Test(arguments: towardsCases)
    func cleansTowards(towards: String, expected: String?) {
        #expect(LondonBusStopBuilder.cleanedTowards(towards) == expected)
    }

    static let letterCases: [(String, String?)] = [
        ("D", "D"),
        ("KX", "KX"),
        ("Z2", "Z2"),
        ("1-4", "1-4"),
        ("10A", "10A"),
        ("v", "V"),
        ("->N", nil),
        (">S", nil),
        ("E-bound", nil),
        ("", nil)
    ]

    @Test(arguments: letterCases)
    func cleansLetters(letter: String, expected: String?) {
        #expect(LondonBusStopBuilder.cleanedLetter(letter) == expected)
    }

    @Test
    func reportsTheLettersItDiscards() {
        let result = LondonBusStopBuilder.build(
            stopPoints: [
                busStopPoint(id: "490001", name: "A", letter: "->N"),
                busStopPoint(id: "490002", name: "B", letter: "->N"),
                busStopPoint(id: "490003", name: "C", letter: "E-bound"),
                busStopPoint(id: "490004", name: "D", letter: "H")
            ],
            naptanStops: []
        )

        #expect(result.discardedLetters == ["->N", "E-bound"])
    }

    @Test
    func sortsRoutesNumbersFirstThenByPrefix() {
        let routes = ["N9", "SL6", "205", "N63", "9", "EL1", "46", "N205"]

        #expect(routes.sorted(by: LondonBusStopBuilder.isRouteOrderedBefore) == ["9", "46", "205", "EL1", "N9", "N63", "N205", "SL6"])
    }

    @Test
    func namesRoutesAfterTheirLinesAndFallsBackToTheUppercasedID() {
        let stopPoint = TfLStopPoint(
            naptanId: "490000129D",
            commonName: "King's Cross Station",
            icsCode: nil,
            lat: 51.5,
            lon: -0.1,
            stopType: "NaptanPublicBusCoachTram",
            lines: [TfLIdentifier(id: "n63", name: "N63")],
            lineModeGroups: [TfLLineModeGroup(modeName: "bus", lineIdentifier: ["n63", "sl6", "n63"])]
        )

        #expect(LondonBusStopBuilder.busRoutes(of: stopPoint) == ["N63", "SL6"])
    }

    @Test
    func breakdownCountsUnusualStops() {
        let result = LondonBusStopBuilder.build(
            stopPoints: [
                busStopPoint(id: "490001", name: "Abbey Road", letter: "M", towards: "Notting Hill Gate"),
                busStopPoint(id: "490002", name: "Abbey Road", letter: "1-4"),
                busStopPoint(id: "490003", name: "No Routes", routes: [])
            ],
            naptanStops: [
                NaptanStop(atcoCode: "490001", naptanCode: "77751", localityName: "South Hampstead", bearing: "W", isHailAndRide: false),
                NaptanStop(atcoCode: "490002", naptanCode: nil, localityName: "Merton", bearing: nil, isHailAndRide: true)
            ]
        )

        #expect(
            result.breakdown == [
                "2 stops",
                "1 without a stop code",
                "1 without \"towards\"",
                "0 without a letter",
                "1 without a bearing",
                "1 hail and ride",
                "0 not in NaPTAN's London data",
                "1 names shared by stops in different localities",
                "Letters other than one or two letters: `1-4`",
                "Stop letters treated as none: none",
                "Left out 1 stops without bus routes",
                "Left out 0 stops missing an ID, name or location"
            ]
        )
    }

    private func busStopPoint(
        id: String,
        name: String,
        letter: String? = nil,
        towards: String? = nil,
        compassPoint: String? = nil,
        stopAreaID: String? = nil,
        routes: [(id: String, name: String)] = [("73", "73")],
        mode: String = "bus"
    ) -> TfLStopPoint {
        var properties: [TfLAdditionalProperty] = []
        if let towards {
            properties.append(TfLAdditionalProperty(category: "Direction", key: "Towards", value: towards))
        }
        if let compassPoint {
            properties.append(TfLAdditionalProperty(category: "Direction", key: "CompassPoint", value: compassPoint))
        }
        return TfLStopPoint(
            naptanId: id,
            commonName: name,
            icsCode: nil,
            lat: 51.5,
            lon: -0.1,
            stationNaptan: stopAreaID,
            stopType: "NaptanPublicBusCoachTram",
            stopLetter: letter,
            lines: routes.map { TfLIdentifier(id: $0.id, name: $0.name) },
            lineModeGroups: routes.isEmpty ? [] : [TfLLineModeGroup(modeName: mode, lineIdentifier: routes.map(\.id))],
            additionalProperties: properties
        )
    }
}

struct TfLStopPointsPageTests {

    private func page(stopCount: Int, pageSize: Int = 3, total: Int = 9) -> TfLStopPointsPage {
        let stopPoints = (0..<stopCount).map { TfLStopPoint(naptanId: "490\($0)", commonName: "Stop", icsCode: nil, lat: 51.5, lon: -0.1) }
        return TfLStopPointsPage(stopPoints: stopPoints, pageSize: pageSize, total: total, page: 1)
    }

    @Test
    func aFullPageIsNotTheLast() {
        #expect(!page(stopCount: 3).isLastPage)
    }

    @Test
    func aShortPageIsTheLast() {
        #expect(page(stopCount: 2).isLastPage)
    }

    @Test
    func anEmptyPageIsTheLast() {
        #expect(page(stopCount: 0).isLastPage)
        #expect(page(stopCount: 0, pageSize: 0).isLastPage)
    }

    // TfL reported a total of 32,571 on its first pages and about 58,000 on its 33rd in the same run.
    @Test
    func ignoresTheReportedTotal() {
        #expect(!page(stopCount: 3, total: 3).isLastPage)
        #expect(page(stopCount: 2, total: 58_000).isLastPage)
    }
}
