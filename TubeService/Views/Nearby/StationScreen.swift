import DataStores
import Models
import PresentationViews
import SwiftUI

@MainActor
struct StationScreen: View {

    @Environment(LineStatusDataStore.self) var lineStatus: LineStatusDataStore
    @Environment(StationsDataStore.self) var stations: StationsDataStore
    
    let station: Station
    
    @Binding var selection: StationView.Selection?
    
    
    // MARK: - Layout
    
    var body: some View {
        StationView(station: station,
                    loadingState: loadingState,
                    statusCells: statusCells,
                    disruptionMessages: disruptionMessages,
                    selection: $selection)
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
        async let refreshLineStatuses: () = await lineStatus.refreshLineStatusesIfStale(for: .today)
        async let refreshDisruptions: () = await stations.refreshStationDisruptionsIfStale()
        
        _ = await (refreshLineStatuses, refreshDisruptions)
    }
    
    private func refreshData() async {
        async let refreshLineStatuses: () = await lineStatus.refreshLineStatuses(for: .today)
        async let refreshDisruptions: () = await stations.refreshStationDisruptions()
        
        _ = await (refreshLineStatuses, refreshDisruptions)
    }
    
    private var loadingState: LoadingState {
        let fetchedData = lineStatus.fetchedData(for: .today)
        
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
        let allLineStatuses = lineStatus.fetchedData(for: .today)?.lines ?? []
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
                LineStatusCell.Style.singleLine($0, showFavouriteImage: false)
            }
    }
}


// MARK: - Previews

private struct WrapperView: View {
    var station: Station = ModelStubs.kingsCrossStation
    @State var selection: StationView.Selection?
    
    var body: some View {
        StationScreen(station: station,
                      selection: $selection)
    }
}

#if DEBUG
#Preview {
    NavigationStack {
        WrapperView()
            .withStubbedEnvironment()
            .navigationTitle("Selected station")
    }
}
#endif
