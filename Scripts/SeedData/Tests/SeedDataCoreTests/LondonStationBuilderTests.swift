import Foundation
import Testing

@testable import SeedDataCore

struct LondonStationBuilderTests {

    @Test
    func decodesTfLLineGroups() throws {
        let json = """
            [
              {
                "naptanId": "940GZZLUBST",
                "hubNaptanCode": null,
                "stationNaptan": "940GZZLUBST",
                "commonName": "Baker Street Underground Station",
                "icsCode": "1000011",
                "lat": 51.522883,
                "lon": -0.15713,
                "lineGroup": [
                  {
                    "$type": "Tfl.Api.Presentation.Entities.LineGroup, Tfl.Api.Presentation.Entities",
                    "stationAtcoCode": "940GZZLUBST",
                    "lineIdentifier": ["circle", "hammersmith-city"]
                  }
                ]
              }
            ]
            """

        let stopPoints = try JSONDecoder().decode([TfLStopPoint].self, from: Data(json.utf8))

        #expect(
            stopPoints == [
                TfLStopPoint(
                    naptanId: "940GZZLUBST",
                    commonName: "Baker Street Underground Station",
                    icsCode: "1000011",
                    lat: 51.522883,
                    lon: -0.15713,
                    stationNaptan: "940GZZLUBST",
                    lineGroup: [TfLLineGroup(stationAtcoCode: "940GZZLUBST", lineIdentifier: ["circle", "hammersmith-city"])]
                )
            ]
        )
    }

    @Test
    func groupsStopPointsByHubUnderTheHubsName() {
        let result = LondonStationBuilder.build(
            stopPointsByLine: [
                [stopPoint("940GZZLUPAC", "Paddington Underground Station", hub: "HUBPAD", lat: 51.5, groups: [("940GZZLUPAC", ["bakerloo"])])],
                [stopPoint("910GPADTON", "Paddington Rail Station", hub: "HUBPAD", lat: 51.6, groups: [("910GPADTON", ["elizabeth"])])]
            ],
            hubs: [stopPoint("HUBPAD", "Paddington", icsCode: "1000174")],
            patches: []
        )

        #expect(
            result.stations == [
                LondonStation(
                    icsCode: "1000174",
                    id: "HUBPAD",
                    lineGroups: [lineGroup("940GZZLUPAC", ["bakerloo"]), lineGroup("910GPADTON", ["elizabeth"])],
                    location: LondonStation.Location(lat: 51.5, lon: -0.1),
                    name: "Paddington"
                )
            ]
        )
        #expect(result.issues.isEmpty)
    }

    @Test
    func usesTheStationNaptanForTramStopsWithOneNaptanPerPlatform() {
        let result = LondonStationBuilder.build(
            stopPointsByLine: [
                [
                    stopPoint("940GZZCRWAN1", "Wandle Park Tram Stop", stationNaptan: "940GZZCRWAN", groups: [("940GZZCRWAN", ["tram"])]),
                    stopPoint("940GZZCRWAN2", "Wandle Park Tram Stop", stationNaptan: "940GZZCRWAN", groups: [("940GZZCRWAN", ["tram"])])
                ]
            ],
            hubs: [],
            patches: []
        )

        #expect(result.stations.map(\.id) == ["940GZZCRWAN"])
        #expect(result.stations.map(\.name) == ["Wandle Park"])
    }

    @Test
    func leavesOutLinesTheAppDoesntShow() {
        let result = LondonStationBuilder.build(
            stopPointsByLine: [
                [
                    stopPoint("910GLIVST", "London Liverpool Street Rail Station", groups: [("910GLIVST", ["elizabeth", "greater-anglia", "weaver"])]),
                    stopPoint("490000138X", "Liverpool Street Bus Station", groups: [("490000138X", ["11", "23"])])
                ]
            ],
            hubs: [],
            patches: []
        )

        #expect(result.stations.map(\.lineGroups) == [[lineGroup("910GLIVST", ["elizabeth", "weaver"])]])
    }

    @Test
    func sortsLineGroupsByLinesThenAtcoCode() {
        let result = LondonStationBuilder.build(
            stopPointsByLine: [
                [
                    stopPoint(
                        "940GZZLUERC",
                        "Edgware Road Underground Station",
                        groups: [("940GZZLUERC", ["district", "circle"]), ("940GZZLUERB", ["circle", "district"]), ("940GZZLUERC", ["bakerloo"])]
                    )
                ]
            ],
            hubs: [],
            patches: []
        )

        #expect(
            result.stations.first?.lineGroups == [
                lineGroup("940GZZLUERC", ["bakerloo"]),
                lineGroup("940GZZLUERB", ["circle", "district"]),
                lineGroup("940GZZLUERC", ["district", "circle"])
            ]
        )
    }

    @Test
    func takesTheLocationOfTheFirstStopPointSeen() {
        let result = LondonStationBuilder.build(
            stopPointsByLine: [
                [stopPoint("940GZZLUAGL", "Angel Underground Station", lat: 51.53, groups: [("940GZZLUAGL", ["northern"])])],
                [stopPoint("940GZZLUAGL", "Angel Underground Station", lat: 51.99, groups: [("940GZZLUAGL", ["northern"])])]
            ],
            hubs: [],
            patches: []
        )

        #expect(result.stations.map(\.location) == [LondonStation.Location(lat: 51.53, lon: -0.1)])
    }

    @Test
    func sortsStationsByNameThenID() {
        let result = LondonStationBuilder.build(
            stopPointsByLine: [
                [
                    stopPoint("940GZZLUBLG", "Bethnal Green Underground Station", groups: [("940GZZLUBLG", ["central"])]),
                    stopPoint("910GBTHNLGR", "Bethnal Green Rail Station", groups: [("910GBTHNLGR", ["weaver"])]),
                    stopPoint("940GZZLUAGL", "Angel Underground Station", groups: [("940GZZLUAGL", ["northern"])])
                ]
            ],
            hubs: [],
            patches: []
        )

        #expect(result.stations.map(\.id) == ["940GZZLUAGL", "910GBTHNLGR", "940GZZLUBLG"])
    }

    @Test
    func appliesPatches() {
        let result = LondonStationBuilder.build(
            stopPointsByLine: [
                [
                    stopPoint(
                        "910GHGHI",
                        "Highbury & Islington Rail Station",
                        hub: "HUBHHY",
                        groups: [("910GHGHI", ["mildmay"]), ("910GHGHI", ["mildmay", "windrush"]), ("910GHGHI", ["windrush"])]
                    )
                ]
            ],
            hubs: [stopPoint("HUBHHY", "Highbury & Islington")]
        )

        #expect(result.stations.first?.lineGroups == [lineGroup("910GHGHI", ["mildmay"]), lineGroup("910GHGHI", ["windrush"])])
        #expect(result.issues == [.warning("stale patch: no station HUBPAD (\(reason(of: "HUBPAD")))"), .warning("stale patch: no station HUBLST (\(reason(of: "HUBLST")))")])
    }

    @Test
    func warnsWhenAPatchRemovesNothing() {
        let patch = LondonStationPatch(stationID: "940GZZLUAGL", reason: "test") { $0.lineIds == ["victoria"] }

        let result = LondonStationBuilder.build(
            stopPointsByLine: [[stopPoint("940GZZLUAGL", "Angel Underground Station", groups: [("940GZZLUAGL", ["northern"])])]],
            hubs: [],
            patches: [patch]
        )

        #expect(result.issues == [.warning("stale patch: removed nothing from 940GZZLUAGL (test)")])
    }

    @Test
    func failsOnAnUnknownHub() {
        let result = LondonStationBuilder.build(
            stopPointsByLine: [[stopPoint("940GZZLUPAC", "Paddington Underground Station", hub: "HUBPAD", groups: [("940GZZLUPAC", ["bakerloo"])])]],
            hubs: [],
            patches: []
        )

        #expect(result.stations.isEmpty)
        #expect(result.issues == [.error("no TransportInterchange stop point for hub HUBPAD")])
    }

    @Test
    func leavesOutIncompleteStopPoints() {
        let angelWithoutICSCode = TfLStopPoint(
            naptanId: "940GZZLUAGL",
            commonName: "Angel Underground Station",
            icsCode: nil,
            lat: 51.53,
            lon: -0.1,
            lineGroup: [TfLLineGroup(stationAtcoCode: "940GZZLUAGL", lineIdentifier: ["northern"])]
        )

        let result = LondonStationBuilder.build(
            stopPointsByLine: [[angelWithoutICSCode]],
            hubs: [],
            patches: []
        )

        #expect(result.stations.isEmpty)
        #expect(result.incompleteStopPointNames == ["Angel Underground Station"])
    }

    // MARK: - Helpers

    private func stopPoint(
        _ naptanID: String,
        _ commonName: String,
        icsCode: String = "1000000",
        hub: String? = nil,
        stationNaptan: String? = nil,
        lat: Double = 51.5,
        groups: [(atcoCode: String, lineIDs: [String])] = []
    ) -> TfLStopPoint {
        TfLStopPoint(
            naptanId: naptanID,
            commonName: commonName,
            icsCode: icsCode,
            lat: lat,
            lon: -0.1,
            hubNaptanCode: hub,
            stationNaptan: stationNaptan,
            lineGroup: groups.map { TfLLineGroup(stationAtcoCode: $0.atcoCode, lineIdentifier: $0.lineIDs) }
        )
    }

    private func lineGroup(_ atcoCode: String, _ lineIDs: [String]) -> LondonStation.LineGroup {
        LondonStation.LineGroup(atcoCode: atcoCode, lineIds: lineIDs)
    }

    private func reason(of stationID: String) -> String {
        LondonStationPatch.all.first { $0.stationID == stationID }?.reason ?? ""
    }
}
