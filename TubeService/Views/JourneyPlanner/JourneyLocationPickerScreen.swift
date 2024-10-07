import DataStores
import Models
import PresentationViews
import SwiftUI

extension JourneyLocationPickerScreen {
    struct Config {
        let navigationTitle: LocalizedStringResource
        let recentJourneys: [RecentJourneyItem]
        let currentSelection: Binding<JourneyLocationPicker.Value?>
    }
    
    @Observable
    @MainActor
    final class ResultsAggregator {
        var stations: [Station] = []
        var nationalRailStations: [StopPoint] = []
        var localSearchResults: [LocationName] = []
        
        func all() -> [JourneyLocationPicker.Value] {
            
            let stationValues: [JourneyLocationPicker.Value] = stations.map { .station($0) }
            let nationalRailValues: [JourneyLocationPicker.Value] = nationalRailStations.map { .nationalRail($0) }
            let otherSearchResults: [JourneyLocationPicker.Value] = localSearchResults.map {
                .namedLocation(.init(name: $0, coordinate: nil, isCurrentLocation: false))
            }
            return stationValues + nationalRailValues + otherSearchResults
        }
    }
}

struct JourneyLocationPickerScreen: View {
    
    @Environment(LocalSearchCompleter.self) var localSearchCompleter
    @Environment(LocationDataStore.self) var location
    @Environment(StationsDataStore.self) var stations
    @Environment(\.dismiss) var dismiss
    
    @State private var suggestionsSection: JourneyLocationPicker.SectionState = .suggestions([])
    @State private var nearbyStationsSection: JourneyLocationPicker.SectionState = .nearbyStations([])
    @State private var searchTerm = ""
    @State private var resultsAggregator = ResultsAggregator()
    
    let navigationTitle: LocalizedStringResource
    let recentJourneys: [RecentJourneyItem]
    @Binding var currentSelection: JourneyLocationPicker.Value?
    
    private var locationPickerSections: [JourneyLocationPicker.SectionState] {
        if !searchTerm.isEmpty {
            [.searchResults(resultsAggregator.all())]
        } else {
            [suggestionsSection,
             nearbyStationsSection]
        }
    }


    // MARK: - Init
    
    init(config: JourneyLocationPickerScreen.Config) {
        self.navigationTitle = config.navigationTitle
        self.recentJourneys = config.recentJourneys
        self._currentSelection = config.currentSelection
    }
    
    
    // MARK: - Layout
    
    var body: some View {
        JourneyLocationPickerView(
            searchTerm: $searchTerm,
            sections: locationPickerSections,
            locationUIStatus: locationUIStatus,
            onAction: handleLocationPickerAction
        )
        .navigationTitle(Text(navigationTitle))
        .detectsLocationChanges {
            handleLocationChangeAction($0)
        }
        .onChange(of: localSearchCompleter.results) { _, newValue in
            resultsAggregator.localSearchResults = newValue
        }
        .task {
            refreshAllSections()
        }
    }
    
    private func refreshAllSections() {
        refreshNearbyStationSection()
        refreshSuggestionsSection()
    }
    
    private func refreshNearbyStationSection() {
        nearbyStationsSection = .nearbyStations(
            location.nearbyStations.prefix(3).map { .station($0.station) }
        )
    }
    
    private func refreshSuggestionsSection() {
        var pickerValues: [JourneyLocationPicker.Value] = [
            .currentLocation(name: location.currentLocationName,
                             coordinate: location.currentLocationCoordinate)
        ]
        
        if let currentSelection {
            if !pickerValues.alreadyContains(currentSelection) {
                pickerValues.append(currentSelection)
            }
        }
        
        let recentJourneyPickerValues = recentJourneys
                                            .flatMap {
                                                [$0.fromLocation, $0.toLocation, $0.viaLocation]
                                            }
                                            .compactMap { $0 }
        recentJourneyPickerValues.forEach {
            if !pickerValues.alreadyContains($0) {
                pickerValues.append($0)
            }
        }
        
        suggestionsSection = .suggestions(pickerValues.removingDuplicates())
    }
    
    private func searchForLocations(matching searchTerm: String) {
        localSearchCompleter.searchForPlaces(matching: searchTerm)
        resultsAggregator.stations = stations.filteredStations(matchingName: searchTerm)
        resultsAggregator.nationalRailStations = stations.filteredNationalRailStations(matching: searchTerm)
    }
    
    private var locationUIStatus: LocationUIStatus {
        .init(
            style: location.locationUIStyle(showsSetUpHeader: false,
                                            loadingState: location.detectionState.toLoadingState()),
            onRequestPermissions: {
                location.promptForPermissions()
                handleLocationPickerAction(.valueSelected(.unknownCurrentLocation))
            }
        )
    }
    
    private func handleLocationPickerAction(_ action: JourneyLocationPicker.Action) {
        switch action {
        case let .searchTermChanged(newValue):
            searchForLocations(matching: newValue)
        case let .valueSelected(value):
            handleSelectedLocationValue(value)
            dismiss()
        }
    }
    
    private func handleSelectedLocationValue(_ value: JourneyLocationPicker.Value) {
        if case .namedLocation(let locationValue) = value, locationValue.isCurrentLocation {
            location.refreshCurrentLocation(forceRefreshLocationName: true)
        }
        
        currentSelection = value
    }
    
    private func handleLocationChangeAction(_ action: DetectLocationChangesAction) {
        switch action {
        case .nameChanged, .coordinateChanged, .authorizationStatusChanged:
            refreshAllSections()
        }
    }
}
