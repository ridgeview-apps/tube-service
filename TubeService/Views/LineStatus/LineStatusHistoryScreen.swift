import DataStores
import Models
import PresentationViews
import Shared
import SwiftUI

@MainActor
struct LineStatusHistoryScreen: View {

    @Environment(LineStatusDataStore.self) var model
    @Environment(PurchaseStore.self) var purchases

    let lineID: TrainLineID

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
        guard purchases.hasTubeServicePlus else { return .locked }
        let result = model.timelineResult(for: lineID)
        let loadingState = result?.fetchState.loadingState ?? .loading
        let snapshots = result?.value?.snapshots ?? []
        return .unlocked(snapshots: snapshots, loadingState: loadingState)
    }

    private func fetchIfStale() {
        Task { await model.refreshTimelineIfStale(for: lineID) }
    }

    private func handleAction(_ action: LineStatusHistoryView.Action) {
        switch action {
        case .unlockTapped:
            Task { try? await purchases.purchase(.tubeServicePlus) }
        case .restoreTapped:
            Task { try? await purchases.restorePurchases() }
        case .refreshTapped, .retryTapped:
            Task { await model.refreshTimeline(for: lineID) }
        }
    }
}


// MARK: - Previews

#if DEBUG
    #Preview("Locked") {
        PreviewEnvironment {
            NavigationStack {
                LineStatusHistoryScreen(lineID: .victoria)
            }
        }
    }

    #Preview("Unlocked") {
        PreviewEnvironment {
            NavigationStack {
                LineStatusHistoryScreen(lineID: .victoria)
                    .environment(PurchaseStore.stub(isPlus: true))
            }
        }
    }
#endif
