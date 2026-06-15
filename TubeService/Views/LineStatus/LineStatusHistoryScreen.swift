import DataStores
import Models
import PresentationViews
import Shared
import SwiftUI

@MainActor
struct LineStatusHistoryScreen: View {

    @Environment(LineStatusDataStore.self) var model

    let lineID: TrainLineID
    let operationalDate: Date?

    var body: some View {
        LineStatusHistoryView(
            lineID: lineID,
            state: historyState,
            onAction: handleAction
        )
        .onAppear { fetchIfStale() }
        .onSceneDidBecomeActive { fetchIfStale() }
    }

    private var historyState: LineStatusHistoryState {
        let result = model.timelineResult(for: lineID, operationalDate: operationalDate)
        let loadingState = result?.fetchState.loadingState ?? .loading
        let snapshots = result?.value?.snapshots ?? []
        return .unlocked(snapshots: snapshots, loadingState: loadingState)
    }

    private func fetchIfStale() {
        Task { await model.refreshTimelineIfStale(for: lineID, operationalDate: operationalDate) }
    }

    private func handleAction(_ action: LineStatusHistoryView.Action) {
        switch action {
        case .unlockTapped:
            break
        case .refreshTapped, .retryTapped:
            Task { await model.refreshTimeline(for: lineID, operationalDate: operationalDate) }
        }
    }
}


// MARK: - Previews

#if DEBUG
    #Preview {
        PreviewEnvironment {
            NavigationStack {
                LineStatusHistoryScreen(lineID: .victoria, operationalDate: nil)
            }
        }
    }
#endif
