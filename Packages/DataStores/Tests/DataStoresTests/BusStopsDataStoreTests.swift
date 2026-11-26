import Foundation
import Models
import Testing

@testable import DataStores

@MainActor
struct BusStopsDataStoreTests {

    private let stopID = "490000129R"

    @Test
    func noticesListClosuresFirstWithoutRepeats() async throws {
        let store = try makeStore(
            disruptedPointsJSON: """
                [
                    { "atcoCode": "490000129R", "description": "Route 73 is diverted.", "appearance": "RealTime", "type": "Information" },
                    { "atcoCode": "490000129R", "description": "This stop is closed.", "appearance": "PlannedWork", "type": "Closure" },
                    { "atcoCode": "490000129R", "description": "Route 73 is diverted.", "appearance": "Information" }
                ]
                """
        )

        await store.refreshNotices(for: stopID)

        #expect(store.notices(forStopID: stopID)?.map(\.text) == ["This stop is closed.", "Route 73 is diverted."])
    }

    @Test
    func endedNoticesAreLeftOut() async throws {
        let twoPM = try Date("2026-11-26T14:00:00Z", strategy: .iso8601)
        let store = try makeStore(
            disruptedPointsJSON: """
                [
                    { "atcoCode": "490000129R", "description": "Closed this morning.", "toDate": "2026-11-26T12:00:00Z" },
                    { "atcoCode": "490000129R", "description": "Closed for roadworks.", "toDate": "2026-12-20T00:00:00Z" }
                ]
                """,
            now: twoPM
        )

        await store.refreshNotices(for: stopID)

        #expect(store.notices(forStopID: stopID)?.map(\.text) == ["Closed for roadworks."])
    }

    @Test
    func noticesAreKeptPerStop() async throws {
        let store = try makeStore(
            disruptedPointsJSON: """
                [{ "atcoCode": "490000129R", "description": "This stop is closed." }]
                """
        )

        await store.refreshNotices(for: stopID)

        #expect(store.notices(forStopID: stopID)?.count == 1)
        #expect(store.notices(forStopID: "490000129S") == nil)
        #expect(store.isLoadingNotices(forStopID: "490000129S"))
    }

    @Test
    func noticesLoadUntilTheFirstFetchSucceeds() async throws {
        let store = try makeStore(disruptedPointsJSON: "[]")
        #expect(store.isLoadingNotices(forStopID: stopID))
        #expect(store.notices(forStopID: stopID) == nil)

        await store.refreshNotices(for: stopID)

        #expect(!store.isLoadingNotices(forStopID: stopID))
        #expect(store.notices(forStopID: stopID) == [])
    }

    @Test
    func noticesStopLoadingWhenTheFirstFetchFails() async {
        let tflAPI = StubTflAPIClient()
        tflAPI.fetchBusStopDisruptionsError = URLError(.notConnectedToInternet)
        let store = BusStopsDataStore(tflAPI: tflAPI)

        await store.refreshNotices(for: stopID)

        #expect(!store.isLoadingNotices(forStopID: stopID))
        #expect(store.notices(forStopID: stopID) == nil)
    }

    @Test
    func refreshIfStaleSkipsTheRequestForHalfAnHour() async throws {
        var now = try Date("2026-11-26T14:00:00Z", strategy: .iso8601)
        let tflAPI = StubTflAPIClient()
        let store = BusStopsDataStore(tflAPI: tflAPI, now: { now })

        await store.refreshNoticesIfStale(for: stopID)
        now += 29 * 60
        await store.refreshNoticesIfStale(for: stopID)
        #expect(tflAPI.fetchBusStopDisruptionsCallCount == 1)

        now += 60
        await store.refreshNoticesIfStale(for: stopID)
        #expect(tflAPI.fetchBusStopDisruptionsCallCount == 2)
    }

    @Test
    func refreshIfStaleRequestsEachStopSeparately() async {
        let tflAPI = StubTflAPIClient()
        let store = BusStopsDataStore(tflAPI: tflAPI)

        await store.refreshNoticesIfStale(for: stopID)
        await store.refreshNoticesIfStale(for: "490000129S")

        #expect(tflAPI.fetchBusStopDisruptionsCallCount == 2)
    }
}

// MARK: - Private helpers

private extension BusStopsDataStoreTests {

    func makeStore(disruptedPointsJSON: String, now: Date = .now) throws -> BusStopsDataStore {
        let tflAPI = StubTflAPIClient()
        tflAPI.stubbedBusStopDisruptions = .success200(
            try JSONDecoder.tflModelDecoder.decode([DisruptedPoint].self, from: Data(disruptedPointsJSON.utf8))
        )
        return BusStopsDataStore(tflAPI: tflAPI, now: { now })
    }
}
