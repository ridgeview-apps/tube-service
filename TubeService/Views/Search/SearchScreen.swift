import DataStores
import Models
import PresentationViews
import Shared
import SwiftUI

@MainActor
struct SearchScreen: View {

    @Environment(AppRouter.self) private var router
    @Environment(StationsDataStore.self) private var stations
    @Environment(LocationDataStore.self) private var location

    @AppStorage(
        UserDefaults.Keys.userPreferences.rawValue,
        store: AppDependencies.current.userDefaults.value
    )
    private var userPreferences: UserPreferences = .default

    @State private var searchTerm: String = ""

    // MARK: - Layout

    var body: some View {
        @Bindable var router = router
        NavigationStack(path: $router.search.path) {
            SearchView(
                content: content,
                locationAccess: locationAccess,
                onAction: handleAction
            )
            .navigationTitle(Text(L10n.searchNavigationTitle))
            .withSettingsToolbarButton()
            .appRouteDestinations()
        }
        .searchable(text: $searchTerm, prompt: Text(L10n.searchPrompt))
        .autocorrectionDisabled()
        // Starts location updates while the tab is visible, so the nearby stations stay current
        .detectsLocationChanges { _ in }
    }

    private var content: SearchView.Content {
        if searchTerm.trimmed().isEmpty {
            .suggestions(nearby: nearbyRows, recents: recentRows)
        } else {
            .results(
                searchTerm: searchTerm,
                stops: stations.filteredStations(matchingName: searchTerm).map { StopRow(station: $0) },
                lines: stations.filteredLines(matchingName: searchTerm)
            )
        }
    }

    private var nearbyRows: [StopRow] {
        location.nearestStations.prefix(3).map(StopRow.init)
    }

    private var recentRows: [StopRow] {
        userPreferences.recentlySelectedStations
            .compactMap { stations.station(forID: $0) }
            .prefix(5)
            .map { StopRow(station: $0) }
    }

    private var locationAccess: LocationAccess {
        .init(
            state: location.locationAccessState(loadingState: location.detectionState.toLoadingState()),
            onRequestPermissions: {
                location.promptForPermissions()
            }
        )
    }

    private func handleAction(_ action: SearchView.Action) {
        switch action {
        case .tappedStation(let station):
            router.push(.station(station))
        case .tappedLine(let lineID):
            router.push(.lineStatusDetail(lineID: lineID, request: .live))
        case .tappedRefreshNearby:
            location.refreshCurrentLocation()
        }
    }
}

// MARK: - Previews

#if DEBUG
    #Preview {
        PreviewEnvironment {
            SearchScreen()
        }
        .environment(AppRouter())
    }
#endif
