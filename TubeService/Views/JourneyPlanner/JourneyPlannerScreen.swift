import DataStores
import Models
import PresentationViews
import SwiftUI

@MainActor
struct JourneyPlannerScreen: View {
    
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
    
    enum DestinationID: Identifiable, Hashable {
        var id: Self { self }
        case locationPicker(JourneyPlannerForm.FieldID.LocationID)
        case results
    }
    
    @State private var form: JourneyPlannerForm = .empty
    @State private var recentJourneys: [RecentJourneyItem] = []
    @State private var suggestionsSection: JourneyLocationPicker.SectionState = .suggestions([])
    @State private var nearbyStationsSection: JourneyLocationPicker.SectionState = .nearbyStations([])
    @State private var searchTerm = ""
    @State private var isTravelOptionsExpanded = false
    @State private var hasLoaded = false

    @State private var navigationState = NavigationState<DestinationID>.root
    
    @State private var resultsAggregator = ResultsAggregator()

    @Environment(\.openURL) var openURL
    @Environment(\.transportAPI) var transportAPI
    @Environment(LocationDataStore.self) var location
    @Environment(StationsDataStore.self) var stations
    @Environment(LocalSearchCompleter.self) var localSearchCompleter
    
    @AppStorage(UserDefaults.Keys.userPreferences.rawValue, store: AppEnvironment.shared.userDefaults)
    private var userPreferences: UserPreferences = .default
    
    private var locationPickerSections: [JourneyLocationPicker.SectionState] {
        if !searchTerm.isEmpty {
            [.searchResults(resultsAggregator.all())]
        } else {
            [suggestionsSection,
             nearbyStationsSection]
        }
    }
    
    var body: some View {
        NavigationStack(path: $navigationState.navigationPath) {
            JourneyPlannerFormView(
                form: $form,
                recentJourneys: $recentJourneys,
                isTravelOptionsExpanded: $isTravelOptionsExpanded,
                locationAccessoryStatus: .loadingState(location.detectionState.toLoadingState()),
                onAction: handleFormAction
            )
            .withSettingsToolbarButton()
            .onSceneDidBecomeActive { restoreUIState() }
            .onSceneDidBecomeInactive { saveUIState() }
            .onChange(of: userPreferences.recentlySavedJourneys) {
                refreshRecentJourneys(sortByLastUsedDate: false) // Preserve the current order (e.g. user selects a journey, we DON'T want it to jump to the top)
            }
            .onChange(of: localSearchCompleter.results) { _, newValue in
                resultsAggregator.localSearchResults = newValue
            }
            .navigationTitle(Text(.journeyPlannerNavigationTitle))
            .withNavigationState($navigationState) { destinationID in
                destinationScreen(for: destinationID)
            }
            .detectsLocationChanges {
                handleLocationChangeAction($0)
            }
            .onCalendarDayChanged {
                resetTimeSelection()
            }
            .task { initialLoad() }
        }
    }
    
    private func initialLoad() {
        guard !hasLoaded else {
            return
        }
        restoreUIState()
        hasLoaded = true
    }
    
    private func saveUIState() {
        userPreferences.cleanUpSavedJourneys()
    }
    
    private func restoreUIState() {
        refreshRecentJourneys(sortByLastUsedDate: true)
    }
        
    private func resetTimeSelection() {
        if form.timeSelection.date < .now {
            form.timeSelection = .leaveNow()
        }
    }

    private func refreshAllSuggestions() {
        form.updateCurrentLocationInfo(
            name: location.currentLocationName,
            coordinate: location.currentLocationCoordinate,
            updatesAllowed: location.isAuthorizedOrUndetermined
        )
        
        nearbyStationsSection = .nearbyStations(
            location.nearbyStations.prefix(3).map { .station($0.station) }
        )
        
        refreshLocationPickerSuggestions()
    }
    
    private func handleLocationChangeAction(_ action: DetectLocationChangesAction) {
        switch action {
        case .nameChanged, .coordinateChanged, .authorizationStatusChanged:
            refreshAllSuggestions()
        }
    }
    
    private func refreshRecentJourneys(sortByLastUsedDate: Bool) {
        recentJourneys = userPreferences.recentlySavedJourneys.toRecentJourneyItems(
            findStationByID: stations.station(forID:),
            findNationalRailByICSCode: stations.nationalRailStation(forICSCode:),
            sortByLastUsedDate: sortByLastUsedDate
        )
        refreshAllSuggestions()
    }
    
    
    // MARK: - Navigation
    
    @ViewBuilder
    private func destinationScreen(for destinationID: DestinationID) -> some View {
        Group {
            switch destinationID {
            case .locationPicker(let fieldID):
                locationPicker(for: fieldID)
            case .results:
                JourneyResultsScreen(form: $form)
            }
        }
    }
        
    @ViewBuilder
    private func locationPicker(for fieldID: JourneyPlannerForm.FieldID.LocationID) -> some View {
        JourneyLocationPickerView(
            searchTerm: $searchTerm,
            sections: locationPickerSections,
            locationUIStatus: locationUIStatus,
            onAction: handleLocationPickerAction
        )
        .navigationTitle(Text(fieldID.navigationTitle))
    }
    
    private var locationUIStatus: LocationUIStatus {
        .init(
            style: location.locationUIStyle(showsSetUpHeader: false,
                                            loadingState: location.detectionState.toLoadingState()),
            onRequestPermissions: {
                handleSelectedLocationValue(.unknownCurrentLocation)
                location.promptForPermissions()
            }
        )
    }
    
    
    // MARK: - Form actions
    
    private func handleFormAction(_ actionEvent: JourneyPlannerForm.Action) {
        switch actionEvent {
        case let .tappedLocationField(locationFieldID):
            showModalLocationPicker(for: locationFieldID)
        case let .swipedToDelete(recentJourneyItem):
            userPreferences.removeRecentJourney(recentJourneyItem.id)
        case let .tappedRecentJourney(recentJourneyItem):
            form.populate(with: recentJourneyItem)
            showResults()
        case .tappedSubmit:
            showResults()
        }
    }
    
    private func showModalLocationPicker(for fieldID: JourneyPlannerForm.FieldID.LocationID) {
        searchTerm = ""
        navigationState.modal(to: .locationPicker(fieldID))
        refreshAllSuggestions()
    }
    
    private func showResults() {
        isTravelOptionsExpanded = false
        form.adjustCurrentTimeIfNeeded()
        navigationState.push(to: .results)
    }
    
    
    // MARK: - Location picker state / actions
    
    private func refreshLocationPickerSuggestions() {
        guard let destinationID = navigationState.modalDestinationID,
              case let .locationPicker(fieldID) = destinationID else {
            return
        }
        
        var pickerValues: [JourneyLocationPicker.Value] = [
            .currentLocation(name: location.currentLocationName,
                             coordinate: location.currentLocationCoordinate)
        ]
        
        if let currentlySelectedValue = form.locationPickerValue(for: fieldID) {
            if !pickerValues.alreadyContains(currentlySelectedValue) {
                pickerValues.append(currentlySelectedValue)
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
    
    private func handleLocationPickerAction(_ action: JourneyLocationPicker.Action) {
        switch action {
        case let .searchTermChanged(newValue):
            searchForLocations(matching: newValue)
        case let .valueSelected(value):
            handleSelectedLocationValue(value)
        }
    }
    
    private func searchForLocations(matching searchTerm: String) {
        localSearchCompleter.searchForPlaces(matching: searchTerm)
        resultsAggregator.stations = stations.filteredStations(matchingName: searchTerm)
        resultsAggregator.nationalRailStations = stations.filteredNationalRailStations(matching: searchTerm)
    }
    
    private func handleSelectedLocationValue(_ value: JourneyLocationPicker.Value) {
        guard let destinationID = navigationState.modalDestinationID,
              case let .locationPicker(fieldID) = destinationID else {
            return
        }
        
        
        if case .namedLocation(let locationValue) = value, locationValue.isCurrentLocation {
            location.refreshCurrentLocation(forceRefreshLocationName: true)
        }

        form.populate(locationFieldID: fieldID, withValue: value)
        navigationState.popOrDismiss()
    }
}

private extension JourneyPlannerForm.FieldID.LocationID {
    
    var navigationTitle: LocalizedStringResource {
        switch self {
        case .from:
            .journeyPlannerLocationPickerScreenFromNavigationTitle
        case .to:
            .journeyPlannerLocationPickerScreenToNavigationTitle
        case .via:
            .journeyPlannerLocationPickerScreenViaNavigationTitle
        }
    }
}


// MARK: - Previews

#if DEBUG
#Preview {
    JourneyPlannerScreen()
        .withStubbedEnvironment()
}
#endif
