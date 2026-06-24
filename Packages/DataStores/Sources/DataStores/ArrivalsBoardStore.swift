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

    public private(set) var boardData = RemoteData<BoardData?>(value: nil, fetchedAt: nil, fetchState: .fetching)

    private let tflAPI: TflAPIClientType
    private var initialFetchTask: Task<Void, Never>?
    private var periodicRefreshTask: Task<Void, Never>?

    public init(tflAPI: TflAPIClientType) {
        self.tflAPI = tflAPI
    }

    // Fetches immediately then starts the periodic refresh loop.
    public func startAutoRefresh(for lineGroup: Station.LineGroup) {
        stopAutoRefresh()
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
        if case .fetching = boardData.fetchState { return }
        let previousFetchState = boardData.fetchState
        boardData.fetchState = .fetching
        do {
            boardData.succeed(with: try await fetchBoardData(for: lineGroup))
        } catch is CancellationError {
            boardData.fetchState = previousFetchState
        } catch {
            boardData.fetchState = .failure(error)
        }
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
