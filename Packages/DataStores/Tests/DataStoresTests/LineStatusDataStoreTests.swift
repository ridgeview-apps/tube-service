import Foundation
import Models
import Testing

@testable import DataStores


@MainActor
struct LineStatusDataStoreTests {

    // MARK: - Line statuses

    @Test
    func refreshLineStatusesForToday() async throws {
        // Given
        let clock = FakeClock(initialTime: .now)
        let tflAPI = StubTflAPIClient()
        let model = LineStatusDataStore(
            tflAPI: tflAPI,
            tubeServiceAPI: StubTubeServiceAPIClient(),
            now: { clock.currentTime }
        )

        // When
        #expect(model.result(for: .live) == nil)
        await model.refreshLineStatuses(for: .live)
        let fetchedData = model.result(for: .live)

        // Then
        let requiredFetchedData = try #require(fetchedData)
        #expect(requiredFetchedData.fetchState.isSuccess)
        #expect(requiredFetchedData.fetchedAt == clock.currentTime)
        #expect(!requiredFetchedData.lines.isEmpty)
        #expect(tflAPI.fetchCurrentLineStatusesCallCount == 1)
    }

    @Test
    func refreshLineStatusesForDateRange() async throws {
        // Given
        let clock = FakeClock(initialTime: .now)
        let oneDay: TimeInterval = 60 * 60 * 24
        let tflAPI = StubTflAPIClient()
        let model = LineStatusDataStore(
            tflAPI: tflAPI,
            tubeServiceAPI: StubTubeServiceAPIClient(),
            now: { clock.currentTime }
        )

        // When
        let dateInterval = DateInterval(start: Date(), duration: oneDay)
        await model.refreshLineStatuses(for: .planned(dateInterval))
        let fetchedData = model.result(for: .planned(dateInterval))

        // Then
        let requiredFetchedData = try #require(fetchedData)
        #expect(requiredFetchedData.fetchState.isSuccess)
        #expect(requiredFetchedData.fetchedAt == clock.currentTime)
        #expect(!requiredFetchedData.lines.isEmpty)
        #expect(tflAPI.fetchLineStatusesForDateRangeCallCount == 1)
    }

    @Test
    func refreshLineStatusesFailure() async throws {
        // Given
        let clock = FakeClock(initialTime: .now)
        let tflAPI = StubTflAPIClient()
        let model = LineStatusDataStore(
            tflAPI: tflAPI,
            tubeServiceAPI: StubTubeServiceAPIClient(),
            now: { clock.currentTime }
        )

        // When
        tflAPI.fetchCurrentLineStatusesError = HTTPError.invalidRequestURL
        await model.refreshLineStatuses(for: .live)
        let fetchedData = model.result(for: .live)

        // Then
        let requiredFetchedData = try #require(fetchedData)
        #expect(requiredFetchedData.fetchState.isError)
        #expect(requiredFetchedData.fetchedAt == nil)
        #expect(requiredFetchedData.lines.isEmpty)
        #expect(tflAPI.fetchCurrentLineStatusesCallCount == 1)
    }

    @Test
    func refreshStaleLineStatuses() async throws {
        // Given
        var clock = FakeClock(initialTime: .now)
        let tflAPI = StubTflAPIClient()
        let model = LineStatusDataStore(
            tflAPI: tflAPI,
            tubeServiceAPI: StubTubeServiceAPIClient(),
            now: { clock.currentTime }
        )

        // Initial data refresh
        #expect(model.result(for: .live) == nil)
        await model.refreshLineStatusesIfStale(for: .live)
        #expect(model.result(for: .live)?.fetchedAt == clock.initialTime)
        #expect(tflAPI.fetchCurrentLineStatusesCallCount == 1)

        // After 4 minutes (no change - data NOT stale)
        clock.addingMinutes(4)
        await model.refreshLineStatusesIfStale(for: .live)
        #expect(model.result(for: .live)?.fetchedAt == clock.initialTime)  // No change
        #expect(tflAPI.fetchCurrentLineStatusesCallCount == 1)  // No change

        // After 5 minutes (fetch expected - data IS now stale)
        clock.addingMinutes(5)
        await model.refreshLineStatusesIfStale(for: .live)
        #expect(model.result(for: .live)?.fetchedAt == clock.currentTime)
        #expect(tflAPI.fetchCurrentLineStatusesCallCount == 2)
    }

    // MARK: - Disruption summary

    @Test
    func refreshDisruptionSummary() async {
        // Given
        let clock = FakeClock(initialTime: .now)
        let tubeServiceAPI = StubTubeServiceAPIClient()
        tubeServiceAPI.stubbedDailyLineDisruptionSummary = .success200(
            .init(
                date: .now,
                timezone: "Europe/London",
                startsAt: .now,
                endsAt: .now,
                lines: [
                    "central": .init(disrupted: true, disruptionCount: 2, latestDisruptionAt: nil),
                    "victoria": .init(disrupted: false, disruptionCount: 0, latestDisruptionAt: nil)
                ]
            )
        )
        let model = LineStatusDataStore(
            tflAPI: StubTflAPIClient(),
            tubeServiceAPI: tubeServiceAPI,
            now: { clock.currentTime }
        )

        // When
        #expect(model.earlierDisruptedLineIDs.isEmpty)
        await model.refreshDisruptionSummary()

        // Then
        #expect(model.earlierDisruptedLineIDs == [.central])
        #expect(tubeServiceAPI.fetchDailyLineDisruptionSummaryCallCount == 1)
    }

    @Test
    func refreshStaleDisruptionSummary() async {
        // Given
        var clock = FakeClock(initialTime: .now)
        let tubeServiceAPI = StubTubeServiceAPIClient()
        let model = LineStatusDataStore(
            tflAPI: StubTflAPIClient(),
            tubeServiceAPI: tubeServiceAPI,
            now: { clock.currentTime }
        )

        // Initial fetch
        await model.refreshDisruptionSummaryIfStale()
        #expect(tubeServiceAPI.fetchDailyLineDisruptionSummaryCallCount == 1)

        // After 29 minutes (no change - NOT stale)
        clock.addingMinutes(29)
        await model.refreshDisruptionSummaryIfStale()
        #expect(tubeServiceAPI.fetchDailyLineDisruptionSummaryCallCount == 1)  // No change

        // After 30 minutes (fetch expected - IS now stale)
        clock.addingMinutes(30)
        await model.refreshDisruptionSummaryIfStale()
        #expect(tubeServiceAPI.fetchDailyLineDisruptionSummaryCallCount == 2)
    }

    @Test
    func refreshDisruptionSummaryFailurePreservesCache() async {
        // Given
        let tubeServiceAPI = StubTubeServiceAPIClient()
        tubeServiceAPI.stubbedDailyLineDisruptionSummary = .success200(
            .init(
                date: .now,
                timezone: "Europe/London",
                startsAt: .now,
                endsAt: .now,
                lines: ["jubilee": .init(disrupted: true, disruptionCount: 1, latestDisruptionAt: nil)]
            )
        )
        let model = LineStatusDataStore(
            tflAPI: StubTflAPIClient(),
            tubeServiceAPI: tubeServiceAPI,
            now: { .now }
        )

        // Populate cache with a successful fetch
        await model.refreshDisruptionSummary()
        #expect(model.earlierDisruptedLineIDs == [.jubilee])

        // Simulate failure on next fetch
        tubeServiceAPI.fetchDailyLineDisruptionSummaryError = HTTPError.invalidRequestURL
        await model.refreshDisruptionSummary()

        // Cache should be preserved
        #expect(model.earlierDisruptedLineIDs == [.jubilee])
    }

}
