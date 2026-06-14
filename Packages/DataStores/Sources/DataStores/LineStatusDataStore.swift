import Foundation
import Models
import Shared

@MainActor
@Observable
public final class LineStatusDataStore {

    // MARK: - Data types

    public enum FetchType: Hashable {
        case live
        case planned(DateInterval)
    }

    public struct LineStatusResult: Sendable {
        public var lines: [Line]
        public var fetchedAt: Date?
        public var fetchState: DataFetchState

        static let initial = LineStatusResult(lines: [], fetchState: .fetching)
    }


    // MARK: - Properties / outputs

    public let tflAPI: TflAPIClientType
    public let now: () -> Date
    public let calendar: Calendar

    private var cache: [FetchType: LineStatusResult] = [:]


    // MARK: - Init

    public init(
        tflAPI: TflAPIClientType,
        now: @escaping () -> Date = { .now },
        calendar: Calendar = .london
    ) {
        self.tflAPI = tflAPI
        self.now = now
        self.calendar = calendar
    }

    public func result(for fetchType: FetchType) -> LineStatusResult? {
        cache[fetchType]
    }


    // MARK: - Actions / inputs

    public func refreshLineStatusesIfStale(for fetchType: FetchType) async {
        let fiveMinutes = TimeInterval(5 * 60)
        let fiveMinutesAgo = now() - fiveMinutes

        let lastFetchedAt = cache[fetchType]?.fetchedAt ?? .distantPast
        let lastFetchedOver5MinutesAgo = lastFetchedAt <= fiveMinutesAgo

        if lastFetchedOver5MinutesAgo {
            await refreshLineStatuses(for: fetchType)
        }
    }

    public func refreshLineStatuses(for fetchType: FetchType) async {
        if case .fetching = cache[fetchType]?.fetchState {
            return
        }

        cache[fetchType, default: .initial].fetchState = .fetching

        do {
            let refreshedLines = try await fetchLineStatuses(for: fetchType)
            cache[fetchType]?.lines = refreshedLines
            cache[fetchType]?.fetchState = .success
            cache[fetchType]?.fetchedAt = now()
        } catch {
            cache[fetchType]?.fetchState = .failure(error)
        }
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
