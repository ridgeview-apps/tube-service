import Foundation
import Models
import ModelStubs
import Testing

@testable import DataStores

@MainActor
struct StationsModelTests {

    @Test
    func loadStationsByID() {
        let stationsModel = StationsDataStore(tflAPI: StubTflAPIClient())

        #expect(stationsModel.station(forID: "HUBKGX") == ModelStubs.kingsCrossStation)
        #expect(stationsModel.station(forID: "HUBPAD") == ModelStubs.paddingtonStation)
        #expect(stationsModel.station(forID: "940GZZLUHBT") == ModelStubs.highBarnetStation)
    }

    @Test
    func filteredStationsByPartialName() {
        let stations = StationsDataStore(tflAPI: StubTflAPIClient())

        func filteredStationsContainsKingsCross(forInputText partialName: String) -> Bool {
            stations.filteredStations(matchingName: partialName).contains(ModelStubs.kingsCrossStation)
        }

        #expect(filteredStationsContainsKingsCross(forInputText: "King's Cross & St Pancras International"))
        #expect(filteredStationsContainsKingsCross(forInputText: "Kings Cross St Pancras International"))
        #expect(filteredStationsContainsKingsCross(forInputText: "Kin"))
        #expect(filteredStationsContainsKingsCross(forInputText: "ternational"))
        #expect(filteredStationsContainsKingsCross(forInputText: "kings cross"))
        #expect(filteredStationsContainsKingsCross(forInputText: "kings cross st pancras"))
    }

    @Test
    func stationNoticesListLiveOnesFirst() async throws {
        let disruptedPointsJSON = """
            [
                { "atcoCode": "940GZZLUKSX", "description": "Mini ramps are available.", "appearance": "Information" },
                { "atcoCode": "940GZZLUKSX", "description": "The lifts are closed from Monday.", "appearance": "PlannedWork" },
                { "atcoCode": "940GZZLUKSX", "description": "The station is closed.", "appearance": "RealTime" }
            ]
            """
        let tflAPI = StubTflAPIClient()
        tflAPI.stubbedDisruptedPoints = .success200(
            try JSONDecoder().decode([DisruptedPoint].self, from: Data(disruptedPointsJSON.utf8))
        )
        let stations = StationsDataStore(tflAPI: tflAPI)

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
        let disruptedPointsJSON = """
            [
                { "atcoCode": "940GZZLUKSX", "description": "Lifts are out of service.", "appearance": "RealTime", "type": "Information" },
                { "atcoCode": "940GZZLUKSX", "description": "Westbound trains will not stop.", "appearance": "PlannedWork", "type": "Part Closure" },
                { "atcoCode": "940GZZLUPAC", "description": "Mini ramps are available.", "appearance": "Information", "type": "Information" }
            ]
            """
        let tflAPI = StubTflAPIClient()
        tflAPI.stubbedDisruptedPoints = .success200(
            try JSONDecoder().decode([DisruptedPoint].self, from: Data(disruptedPointsJSON.utf8))
        )
        let stations = StationsDataStore(tflAPI: tflAPI)

        await stations.refreshStationDisruptions()

        #expect(stations.notices(forStationID: "HUBKGX").map(\.text) == ["Westbound trains will not stop.", "Lifts are out of service."])
        #expect(stations.notices(forStationID: "HUBKGX").first?.isClosure == true)
    }

    @Test
    func endedNoticesAreLeftOut() async throws {
        let disruptedPointsJSON = """
            [
                { "atcoCode": "940GZZLUKSX", "description": "Exit only after the event.", "toDate": "2026-11-12T12:40:00Z" },
                { "atcoCode": "940GZZLUKSX", "description": "Lifts are out of service.", "toDate": "2026-11-30T00:00:00Z" }
            ]
            """
        let tflAPI = StubTflAPIClient()
        tflAPI.stubbedDisruptedPoints = .success200(
            try JSONDecoder.tflModelDecoder.decode([DisruptedPoint].self, from: Data(disruptedPointsJSON.utf8))
        )
        let twoPM = try Date("2026-11-12T14:00:00Z", strategy: .iso8601)
        let stations = StationsDataStore(tflAPI: tflAPI, now: { twoPM })

        await stations.refreshStationDisruptions()

        #expect(stations.notices(forStationID: "HUBKGX").map(\.text) == ["Lifts are out of service."])
    }

    @Test
    func publishedNoticeTextsOnlyAfterASuccessfulFetch() async throws {
        let disruptedPointsJSON = """
            [{ "atcoCode": "940GZZLUKSX", "description": "Lifts are out of service." }]
            """
        let tflAPI = StubTflAPIClient()
        tflAPI.stubbedDisruptedPoints = .success200(
            try JSONDecoder().decode([DisruptedPoint].self, from: Data(disruptedPointsJSON.utf8))
        )
        let stations = StationsDataStore(tflAPI: tflAPI)
        #expect(stations.publishedNoticeTexts == nil)

        await stations.refreshStationDisruptions()

        #expect(stations.publishedNoticeTexts == ["HUBKGX": ["Lifts are out of service."]])
    }
}
