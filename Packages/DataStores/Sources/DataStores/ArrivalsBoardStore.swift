import Foundation
import Models
import Observation
import Shared

@MainActor
@Observable
public final class ArrivalsBoardStore {

    public enum BoardData: Sendable {
        case predictions([ArrivalPrediction])
        case departures(lineID: TrainLineID, items: [ArrivalDeparture])
    }

    private static let refreshInterval: TimeInterval = 20

    public private(set) var boardData = RemoteData<BoardData?>(value: nil, fetchedAt: nil, fetchState: .idle)
    private var currentLineGroup: Station.LineGroup?

    private let tflAPI: TflAPIClientType
    private let now: () -> Date
    private var initialFetchTask: Task<Void, Never>?
    private var periodicRefreshTask: Task<Void, Never>?

    public init(tflAPI: TflAPIClientType, now: @escaping () -> Date = { .now }) {
        self.tflAPI = tflAPI
        self.now = now
    }

    // Fetches immediately then starts the periodic refresh loop.
    public func startAutoRefresh(for lineGroup: Station.LineGroup) {
        stopAutoRefresh()
        switchIfNeeded(to: lineGroup)
        initialFetchTask = Task {
            await self.refresh(for: lineGroup)
            guard !Task.isCancelled else { return }
            self.startPeriodicRefresh(for: lineGroup)
        }
    }

    // Resets the periodic timer without an immediate fetch (used after a manual pull-to-refresh).
    public func resetAutoRefreshTimer(for lineGroup: Station.LineGroup) {
        periodicRefreshTask?.cancel()
        startPeriodicRefresh(for: lineGroup)
    }

    public func stopAutoRefresh() {
        initialFetchTask?.cancel()
        initialFetchTask = nil
        periodicRefreshTask?.cancel()
        periodicRefreshTask = nil
    }

    public func refresh(for lineGroup: Station.LineGroup) async {
        switchIfNeeded(to: lineGroup)
        if case .fetching = boardData.fetchState { return }
        let previousFetchState = boardData.fetchState
        boardData.fetchState = .fetching
        do {
            let data = try await fetchBoardData(for: lineGroup)
            guard isStillCurrent(lineGroup) else { return }
            boardData.succeed(with: data, fetchedAt: now())
        } catch is CancellationError {
            guard isStillCurrent(lineGroup) else { return }
            boardData.fetchState = previousFetchState
        } catch {
            guard isStillCurrent(lineGroup) else { return }
            boardData.fetchState = .failure(error)
        }
    }

    // The board may have switched line group while a fetch was in flight, whose result then belongs to no board
    private func isStillCurrent(_ lineGroup: Station.LineGroup) -> Bool {
        lineGroup == currentLineGroup
    }

    // Clears the previous line group's boards, so they're never shown under another line group
    private func switchIfNeeded(to lineGroup: Station.LineGroup) {
        guard lineGroup != currentLineGroup else { return }
        currentLineGroup = lineGroup
        boardData = RemoteData(value: nil, fetchedAt: nil, fetchState: .idle)
    }

    private func startPeriodicRefresh(for lineGroup: Station.LineGroup) {
        periodicRefreshTask = Task {
            while !Task.isCancelled {
                try? await Task.sleep(for: .seconds(Self.refreshInterval))
                if Task.isCancelled { break }
                await self.refresh(for: lineGroup)
            }
        }
    }

    private func fetchBoardData(for lineGroup: Station.LineGroup) async throws -> BoardData? {
        switch lineGroup.arrivalsDataType {
        case let .arrivalDepartures(lineIDs):
            guard let lineID = lineIDs.first else { return nil }
            let items = try await tflAPI.fetchArrivalDepartures(forLineGroup: lineGroup)
                .decodedModel
                .removingDuplicates()
                .filter { $0.scheduledTimeOfDeparture != nil }
            return .departures(lineID: lineID, items: items)
        case .arrivalPredictions:
            let predictions = try await tflAPI.fetchArrivalPredictions(forLineGroup: lineGroup)
                .decodedModel
            return .predictions(predictions)
        }
    }
}
