import DataStores
import Models
import PresentationViews
import SwiftUI

@MainActor
struct LocatedStationsScreen: View {

    @Environment(AppRouter.self) private var router
    @Environment(StationsDataStore.self) var stations
    @Environment(LocationDataStore.self) var location

    @State private var sectionState: LocatedStationsResultsSectionState = .empty

    // MARK: - Layout

    var body: some View {
        @Bindable var router = router
        NavigationStack(path: $router.nearby.path) {
            nearbyStationsListView
                .appRouteDestinations()
        }
        .detectsLocationChanges(action: handleLocationChangeAction)
        .task {
            updateResultsSectionState()
        }
    }

    private var nearbyStationsListView: some View {
        LocatedStationsView(
            locationUIStatus: locationUIStatus,
            onAction: handleLocatedStationsViewAction,
            sectionState: $sectionState
        )
        .withSettingsToolbarButton()
        .navigationTitle(Text(L10n.nearbyStationsNavigationTitle))
        .refreshable {
            location.refreshCurrentLocation()
        }
    }

    private var locationUIStatus: LocationUIStatus {
        .init(
            style: location.locationUIStyle(loadingState: location.detectionState.toLoadingState()),
            onRequestPermissions: {
                location.promptForPermissions()
            }
        )
    }

    private func handleLocationChangeAction(_ action: DetectLocationChangesAction) {
        switch action {
        case .coordinateChanged, .nameChanged:
            updateResultsSectionState(reset: true)
        case .authorizationStatusChanged:
            return
        }
    }

    private func handleLocatedStationsViewAction(_ action: LocatedStationsView.Action) {
        switch action {
        case .tappedRefresh:
            location.refreshCurrentLocation()
        case .tappedStation(let station):
            router.push(.stationDetail(station: station))
        }
    }

    private func updateResultsSectionState(reset: Bool = false) {
        let nearbyStations = location.nearestStations

        if reset {
            sectionState = .init(stations: nearbyStations)
        } else {
            sectionState.stations = nearbyStations
        }
    }
}

// MARK: - Previews

#if DEBUG
    #Preview {
        PreviewEnvironment {
            LocatedStationsScreen()
        }
        .environment(AppRouter())
    }
#endif
