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
        let model = makeStore(
            tflAPI: tflAPI,
            now: { clock.currentTime }
        )

        // When
        #expect(model.lineStatusData(for: .live) == nil)
        await model.forceRefreshLineStatuses(for: .live)
        let fetchedData = model.lineStatusData(for: .live)

        // Then
        let requiredFetchedData = try #require(fetchedData)
        #expect(requiredFetchedData.fetchState.isSuccess)
        #expect(requiredFetchedData.fetchedAt == clock.currentTime)
        #expect(!requiredFetchedData.value.isEmpty)
        #expect(tflAPI.fetchCurrentLineStatusesCallCount == 1)
    }

    @Test
    func refreshLineStatusesForDateRange() async throws {
        // Given
        let clock = FakeClock(initialTime: .now)
        let oneDay: TimeInterval = 60 * 60 * 24
        let tflAPI = StubTflAPIClient()
        let model = makeStore(
            tflAPI: tflAPI,
            now: { clock.currentTime }
        )

        // When
        let dateInterval = DateInterval(start: Date(), duration: oneDay)
        await model.forceRefreshLineStatuses(for: .planned(dateInterval))
        let fetchedData = model.lineStatusData(for: .planned(dateInterval))

        // Then
        let requiredFetchedData = try #require(fetchedData)
        #expect(requiredFetchedData.fetchState.isSuccess)
        #expect(requiredFetchedData.fetchedAt == clock.currentTime)
        #expect(!requiredFetchedData.value.isEmpty)
        #expect(tflAPI.fetchLineStatusesForDateRangeCallCount == 1)
    }

    @Test
    func refreshLineStatusesFailure() async throws {
        // Given
        let clock = FakeClock(initialTime: .now)
        let tflAPI = StubTflAPIClient()
        let model = makeStore(
            tflAPI: tflAPI,
            now: { clock.currentTime }
        )

        // When
        tflAPI.fetchCurrentLineStatusesError = HTTPError.invalidRequestURL
        await model.forceRefreshLineStatuses(for: .live)
        let fetchedData = model.lineStatusData(for: .live)

        // Then
        let requiredFetchedData = try #require(fetchedData)
        #expect(requiredFetchedData.fetchState.isError)
        #expect(requiredFetchedData.fetchedAt == nil)
        #expect(requiredFetchedData.value.isEmpty)
        #expect(tflAPI.fetchCurrentLineStatusesCallCount == 1)
    }

    @Test
    func refreshStaleLineStatuses() async {
        // Given
        var clock = FakeClock(initialTime: .now)
        let tflAPI = StubTflAPIClient()
        let model = makeStore(
            tflAPI: tflAPI,
            now: { clock.currentTime }
        )

        // Initial data refresh
        await model.refreshLineStatusesIfStale(for: .live)
        #expect(model.lineStatusData(for: .live)?.fetchedAt == clock.initialTime)
        #expect(tflAPI.fetchCurrentLineStatusesCallCount == 1)

        // After 4 minutes (no change - data NOT stale)
        clock.addingMinutes(4)
        await model.refreshLineStatusesIfStale(for: .live)
        #expect(model.lineStatusData(for: .live)?.fetchedAt == clock.initialTime)  // No change
        #expect(tflAPI.fetchCurrentLineStatusesCallCount == 1)  // No change

        // After 5 minutes (fetch expected - data IS now stale)
        clock.addingMinutes(5)
        await model.refreshLineStatusesIfStale(for: .live)
        #expect(model.lineStatusData(for: .live)?.fetchedAt == clock.currentTime)
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
                operationalDate: .now,
                timezone: "Europe/London",
                startsAt: .now,
                endsAt: .now,
                lines: [
                    "central": [.init(lineId: .central, observedAt: .now, transition: .disruptionStarted, statuses: [])],
                    "victoria": []
                ]
            )
        )
        let model = makeStore(
            tubeServiceAPI: tubeServiceAPI,
            now: { clock.currentTime }
        )

        // When
        #expect(model.disruptionCountsByLineID.isEmpty)
        await model.forceRefreshDisruptionSummary()

        // Then
        #expect(model.disruptionCountsByLineID == [.central: 1])
        #expect(tubeServiceAPI.fetchDailyLineDisruptionSummaryCallCount == 1)
    }

    @Test
    func refreshStaleDisruptionSummary() async {
        // Given
        var clock = FakeClock(initialTime: .now)
        let tubeServiceAPI = StubTubeServiceAPIClient()
        let model = makeStore(
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
                operationalDate: .now,
                timezone: "Europe/London",
                startsAt: .now,
                endsAt: .now,
                lines: ["jubilee": [.init(lineId: .jubilee, observedAt: .now, transition: .disruptionStarted, statuses: [])]]
            )
        )
        let model = makeStore(
            tubeServiceAPI: tubeServiceAPI,
            now: { .now }
        )

        // Populate cache with a successful fetch
        await model.forceRefreshDisruptionSummary()
        #expect(model.disruptionCountsByLineID == [.jubilee: 1])

        // Simulate failure on next fetch
        tubeServiceAPI.fetchDailyLineDisruptionSummaryError = HTTPError.invalidRequestURL
        await model.forceRefreshDisruptionSummary()

        // Cache should be preserved
        #expect(model.disruptionCountsByLineID == [.jubilee: 1])
    }

    // MARK: - Timeline cache invalidation

    @Test
    func timelineCacheEvictedWhenLineStatusChanges() async {
        // Given
        let tflAPI = StubTflAPIClient()
        let tubeServiceAPI = StubTubeServiceAPIClient()
        let model = makeStore(tflAPI: tflAPI, tubeServiceAPI: tubeServiceAPI, now: { .now })

        // Initial line status fetch (good service) and populate timeline cache
        tflAPI.stubbedLineStatuses = .success200([Line(id: .victoria, lineStatuses: [.goodService])])
        await model.forceRefreshLineStatuses(for: .live)
        tubeServiceAPI.stubbedDailyLineTimeline = .success200(
            DailyLineTimeline(lineId: .victoria, operationalDate: .now, timezone: "Europe/London", startsAt: .now, endsAt: .now, snapshots: [])
        )
        await model.forceRefreshTimeline(for: .victoria)
        #expect(model.timelineData(for: .victoria)?.fetchedAt != nil)

        // When – line status changes (good service → disrupted)
        tflAPI.stubbedLineStatuses = .success200([
            Line(id: .victoria, lineStatuses: [LineStatus(statusSeverity: .severeDelays, statusSeverityDescription: nil, reason: nil, disruption: nil)])
        ])
        await model.forceRefreshLineStatuses(for: .live)

        // Then – timeline cache entry for victoria is now stale
        #expect(model.timelineData(for: .victoria)?.fetchedAt == nil)
    }

    @Test
    func timelineCachePreservedWhenLineStatusUnchanged() async {
        // Given
        let tflAPI = StubTflAPIClient()
        let tubeServiceAPI = StubTubeServiceAPIClient()
        let goodServiceLine = Line(id: .victoria, lineStatuses: [.goodService])
        tflAPI.stubbedLineStatuses = .success200([goodServiceLine])
        let model = makeStore(tflAPI: tflAPI, tubeServiceAPI: tubeServiceAPI, now: { .now })

        // Initial line status fetch + populate timeline cache
        await model.forceRefreshLineStatuses(for: .live)
        tubeServiceAPI.stubbedDailyLineTimeline = .success200(
            DailyLineTimeline(lineId: .victoria, operationalDate: .now, timezone: "Europe/London", startsAt: .now, endsAt: .now, snapshots: [])
        )
        await model.forceRefreshTimeline(for: .victoria)
        let originalFetchedAt = model.timelineData(for: .victoria)?.fetchedAt
        #expect(originalFetchedAt != nil)

        // When – line status fetched again with identical data
        await model.forceRefreshLineStatuses(for: .live)

        // Then – timeline cache entry is untouched
        #expect(model.timelineData(for: .victoria)?.fetchedAt == originalFetchedAt)
    }

    // MARK: - Timeline

    @Test
    func refreshTimeline() async throws {
        // Given
        let clock = FakeClock(initialTime: .now)
        let tubeServiceAPI = StubTubeServiceAPIClient()
        let timeline = DailyLineTimeline(
            lineId: .victoria,
            operationalDate: .now,
            timezone: "Europe/London",
            startsAt: .now,
            endsAt: .now,
            snapshots: []
        )
        tubeServiceAPI.stubbedDailyLineTimeline = .success200(timeline)
        let model = makeStore(
            tubeServiceAPI: tubeServiceAPI,
            now: { clock.currentTime }
        )

        // When
        #expect(model.timelineData(for: .victoria) == nil)
        await model.forceRefreshTimeline(for: .victoria)
        let result = model.timelineData(for: .victoria)

        // Then
        let requiredResult = try #require(result)
        #expect(requiredResult.fetchState.isSuccess)
        #expect(requiredResult.fetchedAt == clock.currentTime)
        #expect(requiredResult.value == timeline)
        #expect(tubeServiceAPI.fetchDailyLineTimelineCallCount == 1)
    }

    @Test
    func refreshTimelineFailure() async throws {
        // Given
        let tubeServiceAPI = StubTubeServiceAPIClient()
        tubeServiceAPI.fetchDailyLineTimelineError = HTTPError.invalidRequestURL
        let model = makeStore(
            tubeServiceAPI: tubeServiceAPI,
            now: { .now }
        )

        // When
        await model.forceRefreshTimeline(for: .victoria)
        let result = model.timelineData(for: .victoria)

        // Then
        let requiredResult = try #require(result)
        #expect(requiredResult.fetchState.isError)
        #expect(requiredResult.fetchedAt == nil)
        #expect(requiredResult.value == nil)
        #expect(tubeServiceAPI.fetchDailyLineTimelineCallCount == 1)
    }

    @Test
    func refreshStaleTimeline() async {
        // Given
        var clock = FakeClock(initialTime: .now)
        let tubeServiceAPI = StubTubeServiceAPIClient()
        let model = makeStore(
            tubeServiceAPI: tubeServiceAPI,
            now: { clock.currentTime }
        )

        // Initial fetch
        await model.refreshTimelineIfStale(for: .victoria)
        #expect(model.timelineData(for: .victoria)?.fetchedAt == clock.initialTime)
        #expect(tubeServiceAPI.fetchDailyLineTimelineCallCount == 1)

        // After 29 minutes (no change - NOT stale)
        clock.addingMinutes(29)
        await model.refreshTimelineIfStale(for: .victoria)
        #expect(model.timelineData(for: .victoria)?.fetchedAt == clock.initialTime)  // No change
        #expect(tubeServiceAPI.fetchDailyLineTimelineCallCount == 1)  // No change

        // After 30 minutes (fetch expected - IS now stale)
        clock.addingMinutes(30)
        await model.refreshTimelineIfStale(for: .victoria)
        #expect(tubeServiceAPI.fetchDailyLineTimelineCallCount == 2)
    }

    private func makeStore(
        tflAPI: StubTflAPIClient = StubTflAPIClient(),
        tubeServiceAPI: StubTubeServiceAPIClient = StubTubeServiceAPIClient(),
        now: @escaping () -> Date
    ) -> LineStatusDataStore {
        LineStatusDataStore(
            tflAPI: tflAPI,
            tubeServiceAPI: tubeServiceAPI,
            now: now
        )
    }
}
