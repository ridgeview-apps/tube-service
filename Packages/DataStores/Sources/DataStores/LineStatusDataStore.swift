import Foundation
import Models
import Shared

@MainActor
@Observable
public final class LineStatusDataStore {

    public enum LineStatusRequest: Hashable, Sendable {
        case live
        case planned(DateInterval)
    }

    private enum DisruptionSummaryCacheKey {
        case current
    }

    private struct TimelineCacheKey: Hashable {
        let lineID: TrainLineID
        let operationalDate: Date?
    }

    // MARK: - State

    private let tflAPI: TflAPIClientType
    private let tubeServiceAPI: TubeServiceAPIClientType
    private let now: () -> Date

    private var lineStatusCache = FetchCache<LineStatusRequest, [Line]>()
    private var disruptionSummaryCache = FetchCache<DisruptionSummaryCacheKey, Set<TrainLineID>>()
    private var timelineCache = FetchCache<TimelineCacheKey, DailyLineTimeline>()

    public init(
        tflAPI: TflAPIClientType,
        tubeServiceAPI: TubeServiceAPIClientType,
        now: @escaping () -> Date = { .now }
    ) {
        self.tflAPI = tflAPI
        self.tubeServiceAPI = tubeServiceAPI
        self.now = now
    }

    // MARK: - Outputs

    public var earlierDisruptedLineIDs: Set<TrainLineID> {
        disruptionSummaryCache[.current]?.value ?? []
    }

    public func statusResult(for request: LineStatusRequest) -> FetchResult<[Line]>? {
        guard let entry = lineStatusCache[request] else { return nil }
        return FetchResult(value: entry.value ?? [], fetchedAt: entry.fetchedAt, fetchState: entry.fetchState)
    }

    public func timelineResult(
        for lineID: TrainLineID,
        operationalDate: Date?
    ) -> FetchResult<DailyLineTimeline?>? {
        let key = TimelineCacheKey(lineID: lineID, operationalDate: operationalDate)
        guard let entry = timelineCache[key] else { return nil }
        return FetchResult(value: entry.value, fetchedAt: entry.fetchedAt, fetchState: entry.fetchState)
    }

    // MARK: - Refreshing

    public func refresh(for request: LineStatusRequest, ignoringCache: Bool) async {
        if case .live = request {
            Task {
                ignoringCache
                    ? await refreshDisruptionSummary()
                    : await refreshDisruptionSummaryIfStale()
            }
            ignoringCache
                ? await refreshLineStatuses(for: request)
                : await refreshLineStatusesIfStale(for: request)
        } else if ignoringCache {
            await refreshLineStatuses(for: request)
        } else {
            await refreshLineStatusesIfStale(for: request)
        }
    }

    public func refreshLineStatusesIfStale(for request: LineStatusRequest) async {
        let fiveMinutes: TimeInterval = 5 * 60
        if isStale(fetchedAt: lineStatusCache[request]?.fetchedAt, threshold: fiveMinutes) {
            await refreshLineStatuses(for: request)
        }
    }

    public func refreshLineStatuses(for request: LineStatusRequest) async {
        guard lineStatusCache.beginFetch(for: request) else { return }
        do {
            let lines = try await fetchLineStatuses(for: request)
            lineStatusCache.setSuccess(for: request, value: lines, fetchedAt: now())
        } catch {
            lineStatusCache.setFailure(for: request, error: error)
        }
    }

    public func refreshDisruptionSummaryIfStale() async {
        let thirtyMinutes: TimeInterval = 30 * 60
        if isStale(fetchedAt: disruptionSummaryCache[.current]?.fetchedAt, threshold: thirtyMinutes) {
            await refreshDisruptionSummary()
        }
    }

    public func refreshDisruptionSummary() async {
        guard disruptionSummaryCache.beginFetch(for: .current) else { return }
        do {
            let summary = try await tubeServiceAPI.fetchDailyLineDisruptionSummary(operationalDate: nil).decodedModel
            let disruptedLineIDs = Set(
                summary.lines.compactMap { key, value in
                    value.disrupted ? TrainLineID(rawValue: key) : nil
                }
            )
            disruptionSummaryCache.setSuccess(for: .current, value: disruptedLineIDs, fetchedAt: now())
        } catch {
            disruptionSummaryCache.setFailure(for: .current, error: error)
        }
    }

    public func refreshTimelineIfStale(for lineID: TrainLineID, operationalDate: Date?) async {
        let thirtyMinutes: TimeInterval = 30 * 60
        let key = TimelineCacheKey(lineID: lineID, operationalDate: operationalDate)
        if isStale(fetchedAt: timelineCache[key]?.fetchedAt, threshold: thirtyMinutes) {
            await refreshTimeline(for: lineID, operationalDate: operationalDate)
        }
    }

    public func refreshTimeline(for lineID: TrainLineID, operationalDate: Date?) async {
        let key = TimelineCacheKey(lineID: lineID, operationalDate: operationalDate)
        guard timelineCache.beginFetch(for: key) else { return }
        do {
            let timeline = try await tubeServiceAPI.fetchDailyLineTimeline(lineID: lineID, operationalDate: operationalDate).decodedModel
            timelineCache.setSuccess(for: key, value: timeline, fetchedAt: now())
        } catch {
            timelineCache.setFailure(for: key, error: error)
        }
    }

    // MARK: - Implementation

    private func fetchLineStatuses(for request: LineStatusRequest) async throws -> [Line] {
        switch request {
        case .live:
            return try await tflAPI.fetchCurrentLineStatuses().decodedModel
        case let .planned(dateInterval):
            let lines = try await tflAPI.fetchLineStatuses(for: dateInterval).decodedModel
            let isFutureDateRange = dateInterval.start > now()
            return isFutureDateRange ? lines.removingRealtimeDisruptionStatuses() : lines
        }
    }

    private func isStale(fetchedAt: Date?, threshold: TimeInterval) -> Bool {
        (fetchedAt ?? .distantPast) <= now() - threshold
    }
}

private extension Sequence where Element == Line {
    func removingRealtimeDisruptionStatuses() -> [Line] {
        self.map { $0.removingRealtimeDisruption() }
    }
}

private extension Line {

    // Workaround for the fact the TFL API sometimes returns "realtime" statuses when querying a future date (i.e. typically
    // when querying tomorrow). For example: it's currently Friday and the Jubilee line has severe delays. If you query for
    // Saturday's status, it will also include Friday's (realtime) delays.

    func removingRealtimeDisruption() -> Line {
        var updatedStatuses = lineStatuses?.filter { $0.disruption?.category != .realTime } ?? []

        if updatedStatuses.isEmpty {
            updatedStatuses.append(.goodService)
        }

        return .init(id: id, lineStatuses: updatedStatuses)
    }
}
