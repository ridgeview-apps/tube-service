import Foundation
import Models
import Testing

@testable import DataStores

@MainActor
struct StationsDataStoreTests {

    private let kingsCross = Station(
        id: "HUBKGX",
        icsCode: "1000129",
        name: "King's Cross & St Pancras International",
        location: LocationCoordinate(lat: 51.530663, lon: -0.123194),
        lineGroups: [
            .init(atcoCode: "940GZZLUKSX", lineIds: [.circle, .hammersmithAndCity, .metropolitan]),
            .init(atcoCode: "940GZZLUKSX", lineIds: [.victoria])
        ]
    )
    private let paddington = Station(
        id: "HUBPAD",
        icsCode: "1000174",
        name: "Paddington",
        location: LocationCoordinate(lat: 51.516581, lon: -0.175689),
        lineGroups: [
            .init(atcoCode: "940GZZLUPAC", lineIds: [.bakerloo]),
            .init(atcoCode: "910GPADTON", lineIds: [.elizabeth])
        ]
    )
    private let angel = Station(
        id: "940GZZLUAGL",
        icsCode: "1000007",
        name: "Angel",
        location: LocationCoordinate(lat: 51.53184, lon: -0.10635),
        lineGroups: [.init(atcoCode: "940GZZLUAGL", lineIds: [.northern])]
    )

    // MARK: - Stations

    @Test
    func loadStationsByID() {
        let stations = makeStore()

        #expect(stations.station(forID: "HUBKGX") == kingsCross)
        #expect(stations.station(forID: "HUBPAD") == paddington)
        #expect(stations.station(forID: "940GZZLUAGL") == angel)
        #expect(stations.station(forID: "NOT-A-STATION") == nil)
    }

    @Test(
        arguments: [
            "King's Cross & St Pancras International",
            "Kings Cross St Pancras International",
            "Kin",
            "ternational",
            "kings cross",
            "kings cross st pancras",
            "  kings cross  "
        ]
    )
    func filteredStationsByPartialName(partialName: String) {
        let stations = makeStore()

        #expect(stations.filteredStations(matchingName: partialName) == [kingsCross])
    }

    @Test
    func filteredStationsStopAtTheLimit() {
        let stations = makeStore()

        #expect(stations.filteredStations(matchingName: "n", limit: 2) == [kingsCross, paddington])
    }

    // MARK: - Notices

    @Test
    func stationNoticesListLiveOnesFirst() async throws {
        let stations = try makeStore(
            disruptedPointsJSON: """
                [
                    { "atcoCode": "940GZZLUKSX", "description": "Mini ramps are available.", "appearance": "Information" },
                    { "atcoCode": "940GZZLUKSX", "description": "The lifts are closed from Monday.", "appearance": "PlannedWork" },
                    { "atcoCode": "940GZZLUKSX", "description": "The station is closed.", "appearance": "RealTime" }
                ]
                """
        )

        await stations.refreshStationDisruptions()

        #expect(
            stations.notices(forStationID: "HUBKGX").map(\.text) == [
                "The station is closed.",
                "The lifts are closed from Monday.",
                "Mini ramps are available."
            ]
        )
    }

    @Test
    func closureNoticesComeFirst() async throws {
        let stations = try makeStore(
            disruptedPointsJSON: """
                [
                    { "atcoCode": "940GZZLUKSX", "description": "Lifts are out of service.", "appearance": "RealTime", "type": "Information" },
                    { "atcoCode": "940GZZLUKSX", "description": "Westbound trains will not stop.", "appearance": "PlannedWork", "type": "Part Closure" }
                ]
                """
        )

        await stations.refreshStationDisruptions()

        #expect(stations.notices(forStationID: "HUBKGX").map(\.text) == ["Westbound trains will not stop.", "Lifts are out of service."])
        #expect(stations.notices(forStationID: "HUBKGX").first?.isClosure == true)
    }

    @Test
    func noticesAreGroupedByTheStationOfEachStop() async throws {
        let stations = try makeStore(
            disruptedPointsJSON: """
                [
                    { "atcoCode": "940GZZLUPAC", "description": "Bakerloo line: mini ramps are available." },
                    { "atcoCode": "910GPADTON", "description": "Elizabeth line: lifts are out of service." },
                    { "atcoCode": "940GZZLUKSX", "description": "Lifts are out of service." },
                    { "atcoCode": "940GZZLUNOT", "description": "A stop at no known station." }
                ]
                """
        )

        await stations.refreshStationDisruptions()

        #expect(
            stations.publishedNoticeTexts == [
                "HUBPAD": ["Bakerloo line: mini ramps are available.", "Elizabeth line: lifts are out of service."],
                "HUBKGX": ["Lifts are out of service."]
            ]
        )
    }

    @Test
    func endedNoticesAreLeftOut() async throws {
        let twoPM = try Date("2026-11-12T14:00:00Z", strategy: .iso8601)
        let stations = try makeStore(
            disruptedPointsJSON: """
                [
                    { "atcoCode": "940GZZLUKSX", "description": "Exit only after the event.", "toDate": "2026-11-12T12:40:00Z" },
                    { "atcoCode": "940GZZLUKSX", "description": "Lifts are out of service.", "toDate": "2026-11-30T00:00:00Z" }
                ]
                """,
            now: twoPM
        )

        await stations.refreshStationDisruptions()

        #expect(stations.notices(forStationID: "HUBKGX").map(\.text) == ["Lifts are out of service."])
    }

    @Test
    func publishedNoticeTextsOnlyAfterASuccessfulFetch() async throws {
        let stations = try makeStore(
            disruptedPointsJSON: """
                [{ "atcoCode": "940GZZLUKSX", "description": "Lifts are out of service." }]
                """
        )
        #expect(stations.publishedNoticeTexts == nil)

        await stations.refreshStationDisruptions()

        #expect(stations.publishedNoticeTexts == ["HUBKGX": ["Lifts are out of service."]])
    }
}

// MARK: - Private helpers

private extension StationsDataStoreTests {

    func makeStore(disruptedPointsJSON: String, now: Date = .now) throws -> StationsDataStore {
        let tflAPI = StubTflAPIClient()
        tflAPI.stubbedDisruptedPoints = .success200(
            try JSONDecoder.tflModelDecoder.decode([DisruptedPoint].self, from: Data(disruptedPointsJSON.utf8))
        )
        return StationsDataStore(tflAPI: tflAPI, stations: [kingsCross, paddington, angel], now: { now })
    }

    func makeStore() -> StationsDataStore {
        StationsDataStore(tflAPI: StubTflAPIClient(), stations: [kingsCross, paddington, angel])
    }
}
