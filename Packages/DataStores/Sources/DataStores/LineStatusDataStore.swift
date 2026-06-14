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

    private struct DisruptionSummaryCache {
        var disruptedLineIDs: Set<TrainLineID>
        var fetchedAt: Date
    }


    // MARK: - Properties / outputs

    public let tflAPI: TflAPIClientType
    public let tubeServiceAPI: TubeServiceAPIClientType
    public let now: () -> Date

    private var lineStatusCache: [FetchType: LineStatusResult] = [:]
    private var disruptionSummaryCache: DisruptionSummaryCache?

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


    // MARK: - Actions / inputs

    public func refreshLineStatusesIfStale(for fetchType: FetchType) async {
        if isStale(fetchedAt: lineStatusCache[fetchType]?.fetchedAt, threshold: 5 * 60) {
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
        if isStale(fetchedAt: disruptionSummaryCache?.fetchedAt, threshold: 30 * 60) {
            await refreshDisruptionSummary()
        }
    }

    public func refreshDisruptionSummary() async {
        do {
            let summary = try await tubeServiceAPI.fetchDailyLineDisruptionSummary(date: nil).decodedModel
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
