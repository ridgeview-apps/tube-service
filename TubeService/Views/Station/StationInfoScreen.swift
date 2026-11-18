import DataStores
import Models
import PresentationViews
import SwiftUI

/// The Station screen's info sheet, reading the stores itself so it stays live while open.
@MainActor
struct StationInfoScreen: View {

    @Environment(Navigator.self) private var navigator
    @Environment(LineStatusDataStore.self) private var lineStatus
    @Environment(StationsDataStore.self) private var stations

    @AppStorage(
        UserDefaults.Keys.userPreferences.rawValue,
        store: AppDependencies.current.userDefaults.value
    )
    private var userPreferences: UserPreferences = .default

    let station: Station

    var body: some View {
        StationInfoView(
            station: station,
            info: .init(station: station, lineStatus: lineStatus, stations: stations, userPreferences: userPreferences)
        ) { line in
            navigator.push(.lineStatus(.detail(lineID: line.id, request: .live)))
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
