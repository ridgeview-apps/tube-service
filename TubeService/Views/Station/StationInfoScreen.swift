import DataStores
import Models
import PresentationViews
import Shared
import SwiftUI

/// The Station screen's info sheet, reading the stores itself so it stays live while open.
@MainActor
struct StationInfoScreen: View {

    @Environment(Navigator.self) private var navigator
    @Environment(LineStatusDataStore.self) private var lineStatus
    @Environment(StationsDataStore.self) private var stations

    let station: Station

    var body: some View {
        StationInfoView(
            station: station,
            info: .init(station: station, lineStatus: lineStatus, stations: stations)
        ) { line in
            navigator.push(.lineStatus(.detail(lineID: line.id, request: .live)))
        }
        .navigationTitle(station.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar { CloseToolbarItem() }
        // Loaded here rather than on the Station screen, so notices are only requested when someone wants them
        .task {
            await stations.refreshStationDisruptionsIfStale()
        }
        .onSceneDidBecomeActive {
            Task {
                await stations.refreshStationDisruptionsIfStale()
            }
        }
    }
}

// MARK: - Previews

import ModelStubs

#if DEBUG
    #Preview {
        PreviewEnvironment(withNavigationHost: true) {
            StationInfoScreen(station: ModelStubs.kingsCrossStation)
        }
    }
#endif
