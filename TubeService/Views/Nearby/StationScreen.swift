import DataStores
import Models
import PresentationViews
import SwiftUI

@MainActor
struct StationScreen: View {

    @Environment(AppRouter.self) private var router
    @Environment(LineStatusDataStore.self) var lineStatus
    @Environment(StationsDataStore.self) var stations

    let station: Station

    // MARK: - Layout

    var body: some View {
        StationView(
            station: station,
            loadingState: loadingState,
            statusCells: statusCells,
            disruptionCountsByLineID: lineStatus.disruptionCountsByLineID,
            disruptionMessages: disruptionMessages,
            onAction: handleAction
        )
        .navigationTitle(station.name)
        .refreshable {
            await refreshData()
        }
        .task {
            await refreshDataIfStale()
        }
        .onSceneDidBecomeActive {
            Task {
                await refreshDataIfStale()
            }
        }
    }

    private func refreshDataIfStale() async {
        async let lineStatuses: () = lineStatus.refresh(for: .live, forced: false)
        async let stationDisruptions: () = stations.refreshStationDisruptionsIfStale()
        _ = await (lineStatuses, stationDisruptions)
    }

    private func refreshData() async {
        async let lineStatuses: () = lineStatus.refresh(for: .live, forced: true)
        async let stationDisruptions: () = stations.refreshStationDisruptions()
        _ = await (lineStatuses, stationDisruptions)
    }

    private var loadingState: LoadingState {
        let fetchedData = lineStatus.statusResult(for: .live)

        switch fetchedData?.fetchState {
        case .success:
            return .loaded
        case .failure(let error):
            return .failure(errorMessage: error.toUIErrorMessage())
        case .fetching, nil:
            return .loading
        }
    }

    private var statusCells: [LineStatusCell.Style] {
        let allLineStatuses = lineStatus.statusResult(for: .live)?.value ?? []
        return allLineStatuses.toLineStatusCellStyles(for: station)
    }

    private var disruptionMessages: [String] {
        stations.disruptions(forStationID: station.id)
    }

    private func handleAction(_ action: StationView.Action) {
        switch action {
        case .tappedLine(let line):
            router.push(.lineStatusDetail(lineID: line.id, request: .live))
        case .tappedLineGroup(let lineGroup):
            router.push(.arrivalsBoard(lineGroup: lineGroup, stationName: station.name))
        }
    }
}

private extension Sequence where Element == Line {
    func toLineStatusCellStyles(for station: Station) -> [LineStatusCell.Style] {
        self
            .sortedByStatusSeverity()
            .filter { station.sortedLineIDs.contains($0.id) }
            .map {
                LineStatusCell.Style.singleLine($0)
            }
    }
}


// MARK: - Previews

import ModelStubs

#if DEBUG
    #Preview {
        NavigationStack {
            PreviewEnvironment {
                StationScreen(station: ModelStubs.kingsCrossStation)
            }
            .environment(AppRouter())
            .navigationTitle("Selected station")
        }
    }
#endif
