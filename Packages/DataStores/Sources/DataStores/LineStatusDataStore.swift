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

    // MARK: - State

    private let tflAPI: TflAPIClientType
    private let tubeServiceAPI: TubeServiceAPIClientType
    private let now: () -> Date

    private var lineStatusCache = FetchCache<LineStatusRequest, [Line]>()
    private var disruptionSummaryCache = FetchCache<DisruptionSummaryCacheKey, Set<TrainLineID>>()
    private var timelineCache = FetchCache<TrainLineID, DailyLineTimeline>()

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

    public func timelineResult(for lineID: TrainLineID) -> FetchResult<DailyLineTimeline?>? {
        guard let entry = timelineCache[lineID] else { return nil }
        return FetchResult(value: entry.value, fetchedAt: entry.fetchedAt, fetchState: entry.fetchState)
    }

    // MARK: - Refreshing

    public func refresh(for request: LineStatusRequest, forced: Bool) async {
        if case .live = request {
            Task {
                forced
                    ? await forceRefreshDisruptionSummary()
                    : await refreshDisruptionSummaryIfStale()
            }
        }
        forced
            ? await forceRefreshLineStatuses(for: request)
            : await refreshLineStatusesIfStale(for: request)
    }

    func refreshLineStatusesIfStale(for request: LineStatusRequest) async {
        let fiveMinutes: TimeInterval = 5 * 60
        if isStale(fetchedAt: lineStatusCache[request]?.fetchedAt, threshold: fiveMinutes) {
            await forceRefreshLineStatuses(for: request)
        }
    }

    func forceRefreshLineStatuses(for request: LineStatusRequest) async {
        guard lineStatusCache.beginFetch(for: request) else { return }
        do {
            let previousLines = lineStatusCache[request]?.value
            let lines = try await fetchLineStatuses(for: request)
            lineStatusCache.setSuccess(for: request, value: lines, fetchedAt: now())
            if case .live = request {
                evictStaleTimelines(previousLines: previousLines, newLines: lines)
            }
        } catch {
            lineStatusCache.setFailure(for: request, error: error)
        }
    }

    private func evictStaleTimelines(previousLines: [Line]?, newLines: [Line]) {
        guard let previousLines else { return }
        let previousByID = Dictionary(uniqueKeysWithValues: previousLines.map { ($0.id, $0) })
        for line in newLines {
            if previousByID[line.id] != line {
                timelineCache.markStale(for: line.id)
            }
        }
    }

    func refreshDisruptionSummaryIfStale() async {
        let thirtyMinutes: TimeInterval = 30 * 60
        if isStale(fetchedAt: disruptionSummaryCache[.current]?.fetchedAt, threshold: thirtyMinutes) {
            await forceRefreshDisruptionSummary()
        }
    }

    func forceRefreshDisruptionSummary() async {
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

    public func refreshTimelineIfStale(for lineID: TrainLineID) async {
        let thirtyMinutes: TimeInterval = 30 * 60
        if isStale(fetchedAt: timelineCache[lineID]?.fetchedAt, threshold: thirtyMinutes) {
            await refreshTimeline(for: lineID)
        }
    }

    public func refreshTimeline(for lineID: TrainLineID) async {
        guard timelineCache.beginFetch(for: lineID) else { return }
        do {
            let timeline = try await tubeServiceAPI.fetchDailyLineTimeline(lineID: lineID, operationalDate: nil).decodedModel
            timelineCache.setSuccess(for: lineID, value: timeline, fetchedAt: now())
        } catch {
            timelineCache.setFailure(for: lineID, error: error)
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
