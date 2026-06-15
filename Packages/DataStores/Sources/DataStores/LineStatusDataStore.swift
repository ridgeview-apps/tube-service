import Foundation
import Models
import Shared

@MainActor
@Observable
public final class LineStatusDataStore {

    // MARK: - Data types

    public enum FetchType: Hashable, Sendable {
        case live
        case planned(DateInterval)
    }

    public struct LineStatusResult: Sendable {
        public var lines: [Line]
        public var fetchedAt: Date?
        public var fetchState: DataFetchState

        static let initial = LineStatusResult(lines: [], fetchState: .fetching)
    }

    public struct TimelineResult: Sendable {
        public var timeline: DailyLineTimeline?
        public var fetchedAt: Date?
        public var fetchState: DataFetchState

        static let initial = TimelineResult(timeline: nil, fetchedAt: nil, fetchState: .fetching)
    }

    private struct DisruptionSummaryCache {
        var disruptedLineIDs: Set<TrainLineID>
        var fetchedAt: Date
    }

    private struct TimelineCacheKey: Hashable {
        let lineID: TrainLineID
        let operationalDate: Date?
    }


    // MARK: - Properties / outputs

    public let tflAPI: TflAPIClientType
    public let tubeServiceAPI: TubeServiceAPIClientType
    public let now: () -> Date

    private var lineStatusCache: [FetchType: LineStatusResult] = [:]
    private var disruptionSummaryCache: DisruptionSummaryCache?
    private var timelineCache: [TimelineCacheKey: TimelineResult] = [:]

    public var earlierDisruptedLineIDs: Set<TrainLineID> {
        disruptionSummaryCache?.disruptedLineIDs ?? []
    }


    // MARK: - Init

    public init(
        tflAPI: TflAPIClientType,
        tubeServiceAPI: TubeServiceAPIClientType,
        now: @escaping () -> Date = { .now }
    ) {
        self.tflAPI = tflAPI
        self.tubeServiceAPI = tubeServiceAPI
        self.now = now
    }

    public func result(for fetchType: FetchType) -> LineStatusResult? {
        lineStatusCache[fetchType]
    }

    public func timelineResult(for lineID: TrainLineID, operationalDate: Date?) -> TimelineResult? {
        timelineCache[TimelineCacheKey(lineID: lineID, operationalDate: operationalDate)]
    }


    // MARK: - Actions / inputs

    public func refreshLineStatusesIfStale(for fetchType: FetchType) async {
        let fiveMinutes: TimeInterval = 5 * 60
        if isStale(fetchedAt: lineStatusCache[fetchType]?.fetchedAt, threshold: fiveMinutes) {
            await refreshLineStatuses(for: fetchType)
        }
    }

    public func refreshLineStatuses(for fetchType: FetchType) async {
        if case .fetching = lineStatusCache[fetchType]?.fetchState {
            return
        }

        lineStatusCache[fetchType, default: .initial].fetchState = .fetching

        do {
            let refreshedLines = try await fetchLineStatuses(for: fetchType)
            lineStatusCache[fetchType]?.lines = refreshedLines
            lineStatusCache[fetchType]?.fetchState = .success
            lineStatusCache[fetchType]?.fetchedAt = now()
        } catch {
            lineStatusCache[fetchType]?.fetchState = .failure(error)
        }
    }

    public func refresh(for fetchType: FetchType, ignoringCache: Bool) async {
        if case .live = fetchType {
            async let lineStatuses: () =
                ignoringCache
                ? refreshLineStatuses(for: fetchType)
                : refreshLineStatusesIfStale(for: fetchType)
            async let disruptionSummary: () =
                ignoringCache
                ? refreshDisruptionSummary()
                : refreshDisruptionSummaryIfStale()
            _ = await (lineStatuses, disruptionSummary)
        } else if ignoringCache {
            await refreshLineStatuses(for: fetchType)
        } else {
            await refreshLineStatusesIfStale(for: fetchType)
        }
    }

    public func refreshDisruptionSummaryIfStale() async {
        let thirtyMinutes: TimeInterval = 30 * 60
        if isStale(fetchedAt: disruptionSummaryCache?.fetchedAt, threshold: thirtyMinutes) {
            await refreshDisruptionSummary()
        }
    }

    public func refreshDisruptionSummary() async {
        do {
            let summary = try await tubeServiceAPI.fetchDailyLineDisruptionSummary(operationalDate: nil).decodedModel
            let disruptedLineIDs = Set(
                summary.lines.compactMap { key, value in
                    value.disrupted ? TrainLineID(rawValue: key) : nil
                }
            )
            disruptionSummaryCache = DisruptionSummaryCache(disruptedLineIDs: disruptedLineIDs, fetchedAt: now())
        } catch {
            // Preserve existing cache on failure rather than clearing it
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
        if case .fetching = timelineCache[key]?.fetchState {
            return
        }

        timelineCache[key, default: .initial].fetchState = .fetching

        do {
            let timeline = try await tubeServiceAPI.fetchDailyLineTimeline(lineID: lineID, operationalDate: operationalDate).decodedModel
            timelineCache[key]?.timeline = timeline
            timelineCache[key]?.fetchState = .success
            timelineCache[key]?.fetchedAt = now()
        } catch {
            timelineCache[key]?.fetchState = .failure(error)
        }
    }

    private func isStale(fetchedAt: Date?, threshold: TimeInterval) -> Bool {
        (fetchedAt ?? .distantPast) <= now() - threshold
    }

    private func fetchLineStatuses(for fetchType: FetchType) async throws -> [Line] {
        switch fetchType {
        case .live:
            return try await tflAPI.fetchCurrentLineStatuses().decodedModel
        case let .planned(dateInterval):
            let lines = try await tflAPI.fetchLineStatuses(for: dateInterval).decodedModel
            let isFutureDateRange = dateInterval.start > now()
            return isFutureDateRange ? lines.removingRealtimeDisruptionStatuses() : lines
        }
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
