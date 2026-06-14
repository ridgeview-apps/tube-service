import DataStores
import Models
import PresentationViews
import SwiftUI

@MainActor
struct StationScreen: View {

    @Environment(LineStatusDataStore.self) var lineStatus
    @Environment(StationsDataStore.self) var stations

    let station: Station

    // MARK: - Layout

    var body: some View {
        StationView(
            station: station,
            loadingState: loadingState,
            statusCells: statusCells,
            earlierDisruptedLineIDs: lineStatus.earlierDisruptedLineIDs,
            disruptionMessages: disruptionMessages
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
        async let lineStatuses: () = lineStatus.refreshLineStatusesIfStale(for: .live)
        async let disruptionSummary: () = lineStatus.refreshDisruptionSummaryIfStale()
        async let stationDisruptions: () = stations.refreshStationDisruptionsIfStale()
        _ = await (lineStatuses, disruptionSummary, stationDisruptions)
    }

    private func refreshData() async {
        async let lineStatuses: () = lineStatus.refreshLineStatuses(for: .live)
        async let disruptionSummary: () = lineStatus.refreshDisruptionSummary()
        async let stationDisruptions: () = stations.refreshStationDisruptions()
        _ = await (lineStatuses, disruptionSummary, stationDisruptions)
    }

    private var loadingState: LoadingState {
        let fetchedData = lineStatus.result(for: .live)

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
        let allLineStatuses = lineStatus.result(for: .live)?.lines ?? []
        return allLineStatuses.toLineStatusCellStyles(for: station)
    }

    private var disruptionMessages: [String] {
        stations.disruptions(forStationID: station.id)
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

private struct WrapperView: View {
    var station: Station = ModelStubs.kingsCrossStation
    @State var selection: StationView.Selection?

    var body: some View {
        StationScreen(station: station)
    }
}

#if DEBUG
    #Preview {
        NavigationStack {
            PreviewEnvironment {
                WrapperView()
            }
            .navigationTitle("Selected station")
        }
    }
#endif
