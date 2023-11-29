import Models
import PresentationViews
import SwiftUI

struct NearbyStationsScreen: View {

    @EnvironmentObject var stations: StationsModel
    @EnvironmentObject var location: LocationModel
    
    @State private var selectedStation: NearbyStation?
    @State private var selectedStationViewItem: StationView.Selection?
    @State private var nearbyStations: [NearbyStation] = []
    
    @State private var currentPageNo: Int = 1
    
    // MARK: - Layout
    
    var body: some View {
        NavigationSplitView {
            nearbyStationsListView
        } detail: {
            detailView
        }
        .onAppear { resumeLocationDetection() }
        .onDisappear { location.stopDetectingCurrentLocation() }
        .onSceneDidBecomeActive { resumeLocationDetection() }
        .onSceneDidBecomeInactive { location.stopDetectingCurrentLocation() }
        .onChange(of: location.currentLocation) { _ in
            reloadNearbyStations()
        }
        .task {
            reloadNearbyStations()
        }
    }
    
    private var nearbyStationsListView: some View {
        NearbyStationsView(
            mode: mode,
            onAction: handleNearbyStationsViewAction,
            selection: $selectedStation,
            currentPageNo: $currentPageNo
            
        )
        .withSettingsToolbarButton()
        .navigationTitle("nearby.stations.navigation.title")
        .refreshable {
            resetPageNo()
            location.refreshCurrentLocation()
        }
    }
    
    private func handleNearbyStationsViewAction(_ action: NearbyStationsView.Action) {
        switch action {
        case .tappedLocationButton:
            location.promptForPermissions()
        case .tappedRetryButton:
            location.refreshCurrentLocation()
        }
    }
    
    private var mode: NearbyStationsView.Mode {
        switch location.authorizationStatus {
        case .notDetermined:
            return .setUp
        case .restricted, .denied:
            return .permissionDenied
        case .authorizedAlways, .authorizedWhenInUse, .authorized:
            return .permissionGranted(location.detectionState.toLoadingState(), nearbyStations)
        @unknown default:
            return .permissionGranted(location.detectionState.toLoadingState(), nearbyStations)
        }
    }
    
    private func nearestStations(to detectedLocation: Location) -> [NearbyStation] {
        location.nearestStations(to: detectedLocation, in: stations.allStations)
    }
    
    private var detailView: some View {
        NavigationStack {
            Group {
                if let selectedStation {
                    StationScreen(station: selectedStation.station,
                                  selection: $selectedStationViewItem)
                } else {
                    if case .permissionGranted = mode {
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
        currentPageNo = 1
    }
    
    private func reloadNearbyStations() {
        if let currentLocation = location.currentLocation {
            nearbyStations = location.nearestStations(to: currentLocation, in: stations.allStations)
        }
    }
}

private extension LocationModel.DetectionState {
    
    func toLoadingState() -> LoadingState {
        switch self {
        case .detecting:
            return .loading
        case .failed(let error):
            return .failure(errorMessage: error.toUIErrorMessage())
        case .detected:
            return .loaded
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
