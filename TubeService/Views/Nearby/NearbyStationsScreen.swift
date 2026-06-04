import DataStores
import Models
import PresentationViews
import SwiftUI

@MainActor
struct NearbyStationsScreen: View {

    @Environment(StationsDataStore.self) var stations
    @Environment(LocationDataStore.self) var location

    @State private var selectedStation: NearbyStation?
    @State private var sectionState: NearbyStationsResultsSectionState = .empty

    // MARK: - Layout

    var body: some View {
        NavigationStack {
            nearbyStationsListView
                .navigationDestination(for: NearbyStation.self) { station in
                    StationScreen(station: station.station)
                }
                .navigationDestination(for: StationView.Selection.self) { selection in
                    destinationView(for: selection)
                }
        }
        .detectsLocationChanges(action: handleLocationChangeAction)
        .task {
            updateResultsSectionState()
        }
    }

    private var nearbyStationsListView: some View {
        NearbyStationsView(
            locationUIStatus: locationUIStatus,
            onAction: handleNearbyStationsViewAction,
            sectionState: $sectionState
        )
        .withSettingsToolbarButton()
        .navigationTitle(Text(.nearbyStationsNavigationTitle))
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

    private func handleNearbyStationsViewAction(_ action: NearbyStationsView.Action) {
        switch action {
        case .tappedRefresh:
            location.refreshCurrentLocation()
        }
    }

    @ViewBuilder private func destinationView(for selection: StationView.Selection) -> some View {
        switch selection {
        case let .lineStatusDetail(line):
            LineStatusDetailScreen(line: line, fetchType: .today)
        case let .arrivalsBoards(stationName, lineGroup):
            ArrivalsBoardListScreen(
                stationName: stationName,
                lineGroup: lineGroup
            )
        }
    }

    private func updateResultsSectionState(reset: Bool = false) {
        let nearbyStations = location.nearbyStations

        if reset {
            sectionState = .init(nearbyStations: nearbyStations)
        } else {
            sectionState.nearbyStations = nearbyStations
        }
    }
}

// MARK: - Previews

#if DEBUG
    #Preview {
        PreviewEnvironment {
            NearbyStationsScreen()
        }
        .navigationTitle("Nearby stations")
    }
#endif
