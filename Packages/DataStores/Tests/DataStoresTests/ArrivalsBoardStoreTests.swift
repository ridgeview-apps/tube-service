import Foundation
import Models
import Testing

@testable import DataStores

@MainActor
struct ArrivalsBoardStoreTests {

    // Northern line → .arrivalPredictions
    private let predictionsLineGroup = Station.LineGroup(atcoCode: "940GZZLUAGL", lineIds: [.northern])

    // Elizabeth line → .arrivalDepartures
    private let departuresLineGroup = Station.LineGroup(atcoCode: "910GPADTLL", lineIds: [.elizabeth])

    private func makeStore(tflAPI: StubTflAPIClient = StubTflAPIClient()) -> ArrivalsBoardStore {
        ArrivalsBoardStore(tflAPI: tflAPI)
    }

    // MARK: - refresh (predictions)

    @Test
    func refresh_predictions_success_setsBoardData() async {
        let tflAPI = StubTflAPIClient()
        let store = makeStore(tflAPI: tflAPI)

        await store.refresh(for: predictionsLineGroup)

        guard case .predictions(let results) = store.boardData else {
            Issue.record("Expected .predictions board data")
            return
        }
        #expect(!results.isEmpty)
        #expect(store.fetchError == nil)
        #expect(store.fetchedAt != nil)
        #expect(tflAPI.fetchArrivalPredictionsCallCount == 1)
    }

    @Test
    func refresh_predictions_networkError_setsFetchError() async {
        let tflAPI = StubTflAPIClient()
        tflAPI.fetchArrivalPredictionsError = URLError(.notConnectedToInternet)
        let store = makeStore(tflAPI: tflAPI)

        await store.refresh(for: predictionsLineGroup)

        #expect(store.boardData == nil)
        #expect(store.fetchError != nil)
        #expect(store.fetchedAt == nil)
        #expect(tflAPI.fetchArrivalPredictionsCallCount == 1)
    }

    // MARK: - refresh (departures)

    @Test
    func refresh_departures_success_setsBoardData() async {
        let tflAPI = StubTflAPIClient()
        let store = makeStore(tflAPI: tflAPI)

        await store.refresh(for: departuresLineGroup)

        guard case .departures(let lineID, let items) = store.boardData else {
            Issue.record("Expected .departures board data")
            return
        }
        #expect(lineID == .elizabeth)
        #expect(!items.isEmpty)
        #expect(store.fetchError == nil)
        #expect(store.fetchedAt != nil)
        #expect(tflAPI.fetchArrivalDeparturesCallCount == 1)
    }

    @Test
    func refresh_departures_networkError_setsFetchError() async {
        let tflAPI = StubTflAPIClient()
        tflAPI.fetchArrivalDeparturesError = URLError(.notConnectedToInternet)
        let store = makeStore(tflAPI: tflAPI)

        await store.refresh(for: departuresLineGroup)

        #expect(store.boardData == nil)
        #expect(store.fetchError != nil)
        #expect(store.fetchedAt == nil)
        #expect(tflAPI.fetchArrivalDeparturesCallCount == 1)
    }

    // MARK: - Deduplication

    @Test
    func refresh_departures_removesDuplicates() async {
        let tflAPI = StubTflAPIClient()
        let departure = ArrivalDeparture(
            platformName: "Platform A",
            destinationName: "Reading",
            naptanId: nil,
            stationName: nil,
            estimatedTimeOfArrival: nil,
            scheduledTimeOfArrival: nil,
            estimatedTimeOfDeparture: nil,
            scheduledTimeOfDeparture: .now,
            minutesAndSecondsToArrival: nil,
            minutesAndSecondsToDeparture: "2:30",
            departureStatus: .onTime
        )
        let otherDeparture = ArrivalDeparture(
            platformName: "Platform B",
            destinationName: "Shenfield",
            naptanId: nil,
            stationName: nil,
            estimatedTimeOfArrival: nil,
            scheduledTimeOfArrival: nil,
            estimatedTimeOfDeparture: nil,
            scheduledTimeOfDeparture: .now,
            minutesAndSecondsToArrival: nil,
            minutesAndSecondsToDeparture: "5:00",
            departureStatus: .onTime
        )
        // 3 items: departure appears twice (duplicate), otherDeparture appears once
        tflAPI.stubbedArrivalDepartures = .success200([departure, departure, otherDeparture])
        let store = makeStore(tflAPI: tflAPI)

        await store.refresh(for: departuresLineGroup)

        guard case .departures(_, let items) = store.boardData else {
            Issue.record("Expected .departures board data")
            return
        }
        #expect(items.count == 2)
    }

    // MARK: - fetchedAt

    @Test
    func refresh_success_updatesFetchedAt() async {
        let store = makeStore()
        let before = Date.now

        await store.refresh(for: predictionsLineGroup)

        let after = Date.now
        guard let fetchedAt = store.fetchedAt else {
            Issue.record("Expected fetchedAt to be set")
            return
        }
        #expect(fetchedAt >= before)
        #expect(fetchedAt <= after)
    }

    @Test
    func refresh_error_doesNotUpdateFetchedAt() async {
        let tflAPI = StubTflAPIClient()
        tflAPI.fetchArrivalPredictionsError = URLError(.notConnectedToInternet)
        let store = makeStore(tflAPI: tflAPI)

        await store.refresh(for: predictionsLineGroup)

        #expect(store.fetchedAt == nil)
    }

    // MARK: - Error recovery

    @Test
    func refresh_afterError_clearsFetchError() async {
        let tflAPI = StubTflAPIClient()
        tflAPI.fetchArrivalPredictionsError = URLError(.notConnectedToInternet)
        let store = makeStore(tflAPI: tflAPI)

        await store.refresh(for: predictionsLineGroup)
        #expect(store.fetchError != nil)

        tflAPI.fetchArrivalPredictionsError = nil
        await store.refresh(for: predictionsLineGroup)

        #expect(store.fetchError == nil)
        if case .predictions = store.boardData {
        } else {
            Issue.record("Expected .predictions board data after recovery")
        }
    }

    // MARK: - resetAutoRefreshTimer

    @Test
    func resetAutoRefreshTimer_doesNotTriggerImmediateFetch() async {
        let tflAPI = StubTflAPIClient()
        let store = makeStore(tflAPI: tflAPI)
        await store.refresh(for: predictionsLineGroup)
        let callCountAfterInitialFetch = tflAPI.fetchArrivalPredictionsCallCount

        store.resetAutoRefreshTimer(for: predictionsLineGroup)

        #expect(tflAPI.fetchArrivalPredictionsCallCount == callCountAfterInitialFetch)

        store.stopAutoRefresh()
    }

    // MARK: - stopAutoRefresh

    @Test
    func stopAutoRefresh_clearsIsFetching() async {
        let store = makeStore()
        store.startAutoRefresh(for: predictionsLineGroup)
        store.stopAutoRefresh()

        #expect(store.isFetching == false)
    }
}
