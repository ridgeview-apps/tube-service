import Foundation
import Models
import Shared

@MainActor
@Observable
public final class BusStopsDataStore {

    private static let noticesMaxAge: TimeInterval = 30 * 60

    private let tflAPI: TflAPIClientType
    private let now: () -> Date

    private(set) var noticesByStopID: [BusStop.ID: RemoteData<[StationNotice]>] = [:]

    public init(tflAPI: TflAPIClientType, now: @escaping () -> Date = { .now }) {
        self.tflAPI = tflAPI
        self.now = now
    }

    // MARK: - Outputs

    /// The stop's notices that haven't ended, closures first, or nil until they first arrive.
    public func notices(forStopID stopID: BusStop.ID) -> [StationNotice]? {
        guard let notices = noticesByStopID[stopID], notices.fetchedAt != nil else { return nil }
        let now = now()
        return notices.value.filter { $0.timing(at: now) != .ended }
    }

    /// True until the stop's notices first arrive or fail to load.
    public func isLoadingNotices(forStopID stopID: BusStop.ID) -> Bool {
        guard let notices = noticesByStopID[stopID] else { return true }
        if case .failure = notices.fetchState { return false }
        return notices.fetchedAt == nil
    }

    // MARK: - Refreshing

    public func refreshNoticesIfStale(for stopID: BusStop.ID) async {
        let lastFetchedAt = noticesByStopID[stopID]?.fetchedAt ?? .distantPast
        guard lastFetchedAt <= now() - Self.noticesMaxAge else { return }
        await refreshNotices(for: stopID)
    }

    public func refreshNotices(for stopID: BusStop.ID) async {
        var notices = noticesByStopID[stopID] ?? RemoteData(value: [], fetchedAt: nil, fetchState: .idle)
        if case .fetching = notices.fetchState { return }
        notices.fetchState = .fetching
        noticesByStopID[stopID] = notices

        do {
            let disruptedPoints = try await tflAPI.fetchBusStopDisruptions(stopID: stopID).decodedModel
            noticesByStopID[stopID]?.succeed(with: disruptedPoints.compactMap(StationNotice.init).prioritised(), fetchedAt: now())
        } catch {
            noticesByStopID[stopID]?.fetchState = .failure(error)
        }
    }
}
