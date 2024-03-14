import DataStores
import Models
import PresentationViews
import SwiftUI

struct NearbyStationsScreen: View {

    @EnvironmentObject var stations: StationsDataStore
    @EnvironmentObject var location: LocationDataStore
    
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
        .detectsLocationChanges {
            handleLocationChangeAction($0)
        }
        .task {
            updateResultsSectionState()
        }
    }
    
    private var nearbyStationsListView: some View {
        NearbyStationsView(locationUIStatus: locationUIStatus,
                           onAction: handleNearbyStationsViewAction,
                           sectionState: $sectionState,
                           selection: $selectedStation)
            .withSettingsToolbarButton()
            .navigationTitle("nearby.stations.navigation.title")
            .refreshable {
                resetPageNo()
                location.refreshCurrentLocation()
            }
    }
    
    private var locationUIStatus: LocationUIStatus {
        .init(
            style: location.locationUIStyle(), 
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
                        Text("nearby.stations.no.selection")
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
            LineStatusDetailScreen(line: line)
        case let .lineGroup(lineGroup):
            ArrivalsBoardListScreen(stationName: selectedStation?.station.name ?? "",
                                    lineGroup: lineGroup)
        }
    }
    
    private func stationName(for lineGroup: Station.LineGroup) -> String {
        stations.station(forLineGroupID: lineGroup.id)?.name ?? ""
    }
    
    private func resumeLocationDetection() {
        location.startDetectingCurrentLocationIfAuthorized()
    }
    
    private func resetPageNo() {
        sectionState.resetPageNo()
    }
    
    private func updateResultsSectionState(reset: Bool = false) {
        let loadingState = location.detectionState.toLoadingState()
        let nearbyStations = location.nearbyStations
        
        if reset {
            sectionState = .init(loadingState: loadingState,
                                 nearbyStations: nearbyStations)
        } else {
            sectionState.loadingState = loadingState
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
