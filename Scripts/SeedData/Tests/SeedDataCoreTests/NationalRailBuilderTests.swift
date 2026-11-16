import Foundation
import Testing

@testable import SeedDataCore

struct NationalRailBuilderTests {

    @Test
    func decodesTfLStopPoints() throws {
        let json = """
            [
              {
                "naptanId": "910GABWDXR",
                "commonName": "Abbey Wood Rail Station",
                "icsCode": "1001001",
                "lat": 51.491225,
                "lon": 0.12084,
                "stopType": "NaptanRailStation",
                "modes": ["elizabeth-line", "national-rail"]
              },
              {
                "naptanId": "910GLWRNCHL",
                "commonName": "Lawrence Hill Rail Station"
              }
            ]
            """

        let stopPoints = try JSONDecoder().decode([TfLStopPoint].self, from: Data(json.utf8))

        #expect(
            stopPoints == [
                TfLStopPoint(naptanId: "910GABWDXR", commonName: "Abbey Wood Rail Station", icsCode: "1001001", lat: 51.491225, lon: 0.12084),
                TfLStopPoint(naptanId: "910GLWRNCHL", commonName: "Lawrence Hill Rail Station", icsCode: nil, lat: nil, lon: nil)
            ]
        )
    }

    @Test
    func cleansNamesAndSortsByName() {
        let result = NationalRailBuilder.build(from: [
            .stub(naptanId: "910GWATRLMN", name: "London Waterloo Rail Station", icsCode: "1000254"),
            .stub(naptanId: "910GABWDXR", name: "Abbey Wood Rail Station", icsCode: "1001001")
        ])

        #expect(result.stopPoints.map(\.commonName) == ["Abbey Wood", "London Waterloo"])
    }

    @Test
    func leavesOutIncompleteStopPoints() {
        let result = NationalRailBuilder.build(from: [
            .stub(naptanId: "910GABWDXR", name: "Abbey Wood Rail Station", icsCode: "1001001"),
            .stub(naptanId: "910GLWRNCHL", name: "Lawrence Hill Rail Station", icsCode: nil),
            TfLStopPoint(naptanId: "910GNOLOC", commonName: "No Location Rail Station", icsCode: "1", lat: nil, lon: nil)
        ])

        #expect(result.stopPoints.map(\.naptanId) == ["910GABWDXR"])
        #expect(result.incompleteStopPointNames == ["Lawrence Hill Rail Station", "No Location Rail Station"])
    }

    // TfL lists Farringdon's Thameslink and Elizabeth line stop points separately under one ICS code.
    @Test
    func keepsTheStopPointWhoseUncleanedNameSortsFirst() {
        let result = NationalRailBuilder.build(from: [
            .stub(naptanId: "910GFRNDNLT", name: "Farringdon Rail Station", icsCode: "1000080"),
            .stub(naptanId: "910GFRNDXR", name: "Farringdon", icsCode: "1000080")
        ])

        #expect(result.stopPoints.map(\.naptanId) == ["910GFRNDXR"])
    }

    @Test
    func breaksNameTiesByNaptanID() {
        let stopPoints: [TfLStopPoint] = [
            .stub(naptanId: "910GWIMBLDN", name: "Wimbledon Rail Station", icsCode: "1000272"),
            .stub(naptanId: "910GWDON", name: "Wimbledon Rail Station", icsCode: "1000272")
        ]

        let result = NationalRailBuilder.build(from: stopPoints)
        let reversedResult = NationalRailBuilder.build(from: stopPoints.reversed())

        #expect(result.stopPoints.map(\.naptanId) == ["910GWDON"])
        #expect(reversedResult == result)
    }
}

extension TfLStopPoint {
    static func stub(naptanId: String, name: String, icsCode: String?) -> TfLStopPoint {
        TfLStopPoint(naptanId: naptanId, commonName: name, icsCode: icsCode, lat: 51.5, lon: -0.1)
    }
}
