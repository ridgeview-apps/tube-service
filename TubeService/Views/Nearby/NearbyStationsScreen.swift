import DataStores
import Models
import PresentationViews
import SwiftUI

@MainActor
struct NearbyStationsScreen: View {

    @Environment(StationsDataStore.self) var stations
    @Environment(LocationDataStore.self) var location
    
    @State private var selectedStation: NearbyStation?
    @State private var selectedStationViewItem: StationView.Selection?
    @State private var sectionState: NearbyStationsResultsSectionState = .empty
    
    // MARK: - Layout
    
    var body: some View {
        NavigationSplitView {
            nearbyStationsListView
        } detail: {
            detailView
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
            sectionState: $sectionState,
            selection: $selectedStation
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
    
    private var detailView: some View {
        NavigationStack {
            Group {
                if let selectedStation {
                    StationScreen(station: selectedStation.station,
                                  selection: $selectedStationViewItem)
                } else {
                    if location.isAuthorized {
                        Text(.nearbyStationsNoSelection)
                    }
                }
            }
            .navigationDestination(for: StationView.Selection.self) { selection in
                destinationView(for: selection)
            }
        }
    }
    
    @ViewBuilder private func destinationView(for selection: StationView.Selection) -> some View {
        switch selection {
        case let .line(line):
            LineStatusDetailScreen(line: line, fetchType: .today)
        case let .lineGroup(lineGroup):
            ArrivalsBoardListScreen(stationName: selectedStation?.station.name ?? "",
                                    lineGroup: lineGroup)
        }
    }
    
    private func stationName(for lineGroup: Station.LineGroup) -> String {
        stations.station(forLineGroupID: lineGroup.id)?.name ?? ""
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
    NearbyStationsScreen()
        .withStubbedEnvironment()
        .navigationTitle("Nearby stations")
}
#endif
