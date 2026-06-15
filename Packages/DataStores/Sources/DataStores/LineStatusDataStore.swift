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

    public struct FetchResult<Value: Sendable>: Sendable {
        public var value: Value
        public var fetchedAt: Date?
        public var fetchState: DataFetchState
    }

    private struct DisruptionSummaryCache {
        var disruptedLineIDs: Set<TrainLineID>
        var fetchedAt: Date
    }

    private struct TimelineCacheKey: Hashable {
        let lineID: TrainLineID
        let operationalDate: Date?
    }

    private struct FetchCache<Key: Hashable, Value> {
        struct Entry {
            var value: Value?
            var fetchedAt: Date?
            var fetchState: DataFetchState

            static var initial: Entry {
                Entry(value: nil, fetchedAt: nil, fetchState: .fetching)
            }
        }

        private var storage: [Key: Entry] = [:]

        subscript(key: Key) -> Entry? { storage[key] }

        mutating func beginFetch(for key: Key) -> Bool {
            if case .fetching = storage[key]?.fetchState { return false }
            storage[key, default: .initial].fetchState = .fetching
            return true
        }

        mutating func setSuccess(for key: Key, value: Value, fetchedAt: Date) {
            storage[key]?.value = value
            storage[key]?.fetchState = .success
            storage[key]?.fetchedAt = fetchedAt
        }

        mutating func setFailure(for key: Key, error: Error) {
            storage[key]?.fetchState = .failure(error)
        }
    }


    // MARK: - Properties / outputs

    public let tflAPI: TflAPIClientType
    public let tubeServiceAPI: TubeServiceAPIClientType
    public let now: () -> Date

    private var lineStatusCache = FetchCache<FetchType, [Line]>()
    private var disruptionSummaryCache: DisruptionSummaryCache?
    private var timelineCache = FetchCache<TimelineCacheKey, DailyLineTimeline>()

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

    public func statusResult(for fetchType: FetchType) -> FetchResult<[Line]>? {
        guard let entry = lineStatusCache[fetchType] else { return nil }
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


    // MARK: - Actions / inputs

    public func refreshLineStatusesIfStale(for fetchType: FetchType) async {
        let fiveMinutes: TimeInterval = 5 * 60
        if isStale(fetchedAt: lineStatusCache[fetchType]?.fetchedAt, threshold: fiveMinutes) {
            await refreshLineStatuses(for: fetchType)
        }
    }

    public func refreshLineStatuses(for fetchType: FetchType) async {
        guard lineStatusCache.beginFetch(for: fetchType) else { return }
        do {
            let lines = try await fetchLineStatuses(for: fetchType)
            lineStatusCache.setSuccess(for: fetchType, value: lines, fetchedAt: now())
        } catch {
            lineStatusCache.setFailure(for: fetchType, error: error)
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
        guard timelineCache.beginFetch(for: key) else { return }
        do {
            let timeline = try await tubeServiceAPI.fetchDailyLineTimeline(lineID: lineID, operationalDate: operationalDate).decodedModel
            timelineCache.setSuccess(for: key, value: timeline, fetchedAt: now())
        } catch {
            timelineCache.setFailure(for: key, error: error)
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
