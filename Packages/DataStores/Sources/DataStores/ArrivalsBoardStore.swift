import Foundation
import Models
import Observation
import Shared

@MainActor
@Observable
public final class ArrivalsBoardStore {

    public enum Board: Hashable, Sendable {
        case lineGroup(Station.LineGroup)
        case busStop(BusStop.ID)
    }

    public enum BoardData: Sendable {
        case predictions([ArrivalPrediction])
        case departures(lineID: TrainLineID, items: [ArrivalDeparture])
        case busArrivals([BusArrival])
    }

    // Matches the max-age TfL sends with arrivals responses
    private static let refreshInterval: TimeInterval = 30

    public private(set) var boardData = RemoteData<BoardData?>(value: nil, fetchedAt: nil, fetchState: .idle)
    private var currentBoard: Board?

    private let tflAPI: TflAPIClientType
    private let now: () -> Date
    private var initialFetchTask: Task<Void, Never>?
    private var periodicRefreshTask: Task<Void, Never>?

    public init(tflAPI: TflAPIClientType, now: @escaping () -> Date = { .now }) {
        self.tflAPI = tflAPI
        self.now = now
    }

    // Fetches immediately then starts the periodic refresh loop.
    public func startAutoRefresh(for board: Board) {
        stopAutoRefresh()
        switchIfNeeded(to: board)
        initialFetchTask = Task {
            await self.refresh(for: board)
            guard !Task.isCancelled else { return }
            self.startPeriodicRefresh(for: board)
        }
    }

    // Resets the periodic timer without an immediate fetch (used after a manual pull-to-refresh).
    public func resetAutoRefreshTimer(for board: Board) {
        periodicRefreshTask?.cancel()
        startPeriodicRefresh(for: board)
    }

    public func stopAutoRefresh() {
        initialFetchTask?.cancel()
        initialFetchTask = nil
        periodicRefreshTask?.cancel()
        periodicRefreshTask = nil
    }

    public func refresh(for board: Board) async {
        switchIfNeeded(to: board)
        if case .fetching = boardData.fetchState { return }
        let previousFetchState = boardData.fetchState
        boardData.fetchState = .fetching
        do {
            let data = try await fetchBoardData(for: board)
            guard isStillCurrent(board) else { return }
            boardData.succeed(with: data, fetchedAt: now())
        } catch is CancellationError {
            guard isStillCurrent(board) else { return }
            boardData.fetchState = previousFetchState
        } catch {
            guard isStillCurrent(board) else { return }
            boardData.fetchState = .failure(error)
        }
    }

    // The board may have switched while a fetch was in flight, whose result then belongs to no board
    private func isStillCurrent(_ board: Board) -> Bool {
        board == currentBoard
    }

    // Clears the previous board's data, so it's never shown under another line group or stop
    private func switchIfNeeded(to board: Board) {
        guard board != currentBoard else { return }
        currentBoard = board
        boardData = RemoteData(value: nil, fetchedAt: nil, fetchState: .idle)
    }

    private func startPeriodicRefresh(for board: Board) {
        periodicRefreshTask = Task {
            while !Task.isCancelled {
                try? await Task.sleep(for: .seconds(Self.refreshInterval))
                if Task.isCancelled { break }
                await self.refresh(for: board)
            }
        }
    }

    private func fetchBoardData(for board: Board) async throws -> BoardData? {
        switch board {
        case .lineGroup(let lineGroup):
            return try await fetchBoardData(for: lineGroup)
        case .busStop(let stopID):
            return .busArrivals(try await tflAPI.fetchBusArrivals(stopID: stopID).decodedModel)
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
