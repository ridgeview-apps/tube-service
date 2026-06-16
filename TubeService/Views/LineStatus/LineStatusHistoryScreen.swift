import DataStores
import Models
import PresentationViews
import SwiftUI

@MainActor
struct LineStatusHistoryScreen: View {

    @Environment(LineStatusDataStore.self) var model

    let lineID: TrainLineID

    var body: some View {
        LineStatusHistoryView(
            lineID: lineID,
            snapshots: snapshots,
            loadingState: loadingState,
            onAction: handleAction
        )
        .onAppear { fetchIfStale() }
        .onSceneDidBecomeActive { fetchIfStale() }
    }

    private var snapshots: [LineStatusSnapshot] {
        model.timelineResult(for: lineID)?.value?.snapshots ?? []
    }

    private var loadingState: LoadingState {
        model.timelineResult(for: lineID)?.fetchState.loadingState ?? .loading
    }

    private func fetchIfStale() {
        Task { await model.refreshTimeline(for: lineID, forced: false) }
    }

    private func handleAction(_ action: LineStatusHistoryView.Action) {
        switch action {
        case .refreshTapped, .retryTapped:
            Task { await model.refreshTimeline(for: lineID, forced: true) }
        }
    }
}


// MARK: - Previews

#if DEBUG
    #Preview("Unlocked") {
        PreviewEnvironment {
            NavigationStack {
                LineStatusHistoryScreen(lineID: .victoria)
                    .environment(PurchaseStore.stub(isPlus: true))
            }
        }
    }
#endif
