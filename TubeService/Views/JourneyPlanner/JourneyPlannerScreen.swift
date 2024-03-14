import DataStores
import Models
import PresentationViews
import SwiftUI

// swiftlint:disable type_body_length
struct JourneyPlannerScreen: View {
    
    @Environment(\.openURL) var openURL
    
    @State private var form: JourneyPlannerForm = .empty
    
    @State private var navigationID: NavigationID?
    
    enum NavigationID: Identifiable {
        var id: Self { self }
        case fromLocation, toLocation, viaLocation
    }
    
    enum PushNavigationID {
        case results
    }
    
    @State private var stationSearchResults: [Station] = []
    @State private var nationRailSearchResults: [StopPoint] = []
    @State private var suggestionsSection: JourneyLocationPicker.SectionState = .suggestions([])
    @State private var nearbyStationsSection: JourneyLocationPicker.SectionState = .nearbyStations([])
    @State private var recentJourneys: [RecentJourneyItem] = []
    @State private var searchTerm = ""
    @State private var navigationPath = NavigationPath()
        
    @Environment(\.transportAPI) var transportAPI
    @EnvironmentObject var location: LocationDataStore
    @EnvironmentObject var stations: StationsDataStore
    @EnvironmentObject var userPreferences: UserPreferencesDataStore
    @EnvironmentObject var localSearchCompleter: LocalSearchCompleter
    
    private var searchResultsSection: JourneyLocationPicker.SectionState {
        let stationValues: [JourneyLocationPicker.Value] = stationSearchResults.map { .station($0) }
        let nationalRailValues: [JourneyLocationPicker.Value] = nationRailSearchResults.map { .nationalRail($0) }
        let otherSearchResults: [JourneyLocationPicker.Value] = localSearchCompleter.results.map {
            .namedLocation(.init(name: $0))
        }
        
        return .searchResults(stationValues + nationalRailValues + otherSearchResults)
    }
    
    private var locationPickerSections: [JourneyLocationPicker.SectionState] {
        if !searchTerm.isEmpty {
            [searchResultsSection]
        } else {
            [suggestionsSection,
             nearbyStationsSection]
        }
    }
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            ScrollViewReader { reader in
                JourneyPlannerView(
                    form: $form,
                    recentJourneys: $recentJourneys,
                    locationAccessoryStatus: .loadingState(location.detectionState.toLoadingState()),
                    onAction: handleFormAction
                )
                .onChange(of: recentJourneys) { newValue in
                    reader.scrollTo(newValue.first, anchor: .bottom)
                }
            }
            .navigationTitle("journey.planner.navigation.title")
            .withSettingsToolbarButton()
            .withResetToolbarButton(enabled: form.hasChanges,
                                    alertTitle: "journey.planner.reset.alert.title") {
                form.reset()
            }
            .navigationDestination(for: PushNavigationID.self) { destinationNavigationID in
                push(to: destinationNavigationID)
            }
            .sheet(item: $navigationID) { navgationID in
                handleNavigation(navgationID)
            }
            .detectsLocationChanges {
                handleLocationChangeAction($0)
            }
            .onChange(of: userPreferences.recentlySavedJourneys) { _ in
                withAnimation {
                    updateRecentJourneyList()
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: .NSCalendarDayChanged)) { _ in
                resetTimeSelectionForDayChange()
            }
            .task {
                initialLoad()
            }
        }
    }
    
    private func initialLoad() {
        updateSuggestions()
        withAnimation {
            updateRecentJourneyList()
        }
    }
    
    private func resetTimeSelectionForDayChange() {
        if form.timeSelection.date < .now {
            form.timeSelection = .leaveNow()
        }
    }

    private func updateSuggestions() {
        form.updateCurrentLocationInfo(
            isAuthorized: location.isAuthorized,
            updatedValue: .init(name: location.currentLocationName,
                                coordinate: location.currentLocationCoordinate)
        )
        
        nearbyStationsSection = .nearbyStations(
            location.nearbyStations.prefix(3).map { .station($0.station) }
        )
        updateLocationPickerSuggestions()
    }
    
    private func handleLocationChangeAction(_ action: DetectLocationChangesAction) {
        switch action {
        case .nameChanged, .coordinateChanged, .authorizationStatusChanged:
            updateSuggestions()
        }
    }
    
    private func updateLocationPickerSuggestions() {
        guard let navigationID else {
            return
        }
        
        let currentLocationValue = JourneyLocationPicker.CurrentLocationValue(name: location.currentLocationName,
                                                                              coordinate: location.currentLocationCoordinate)
        var pickerValues: [JourneyLocationPicker.Value] = [
            .currentLocation(currentLocationValue)
        ]
        
        let currentSelection: JourneyLocationPicker.Value?
        switch navigationID {
        case .fromLocation:
            currentSelection = form.from
        case .toLocation:
            currentSelection = form.to
        case .viaLocation:
            currentSelection = form.via
        }
        
        if let currentSelection, 
            !currentSelection.isSameAs(currentLocationName: currentLocationValue.name) {
            pickerValues.append(currentSelection)
        }
        
        recentJourneys.forEach {
            if !$0.fromLocation.isSameAs(currentLocationName: currentLocationValue.name) {
                pickerValues.append($0.fromLocation)
            }
            if !$0.toLocation.isSameAs(currentLocationName: currentLocationValue.name) {
                pickerValues.append($0.toLocation)
            }
            if let viaLocation = $0.viaLocation,
               !viaLocation.isSameAs(currentLocationName: currentLocationValue.name) {
                pickerValues.append(viaLocation)
            }
        }
   
        suggestionsSection = .suggestions(pickerValues.removingDuplicates())
    }
        
    private func updateRecentJourneyList() {
        recentJourneys = userPreferences.recentlySavedJourneys.toRecentJourneyItems(
            findStationByID: stations.station(forID:),
            findNationalRailByICSCode: stations.nationalRailStation(forICSCode:)
        )
    }
    
    @ViewBuilder
    private func handleNavigation(_ navigationID: NavigationID) -> some View {
        NavigationStack {
            Group {
                switch navigationID {
                case .fromLocation:
                    locationPicker(
                        placeholder: "location.picker.screen.from.placeholder.text",
                        sections: locationPickerSections,
                        navigationTitle: "location.picker.screen.from.navigation.title"
                    )
                case .toLocation:
                    locationPicker(
                        placeholder: "location.picker.screen.to.placeholder.text",
                        sections: locationPickerSections,
                        navigationTitle: "location.picker.screen.to.navigation.title"
                    )
                case .viaLocation:
                    locationPicker(
                        placeholder: "location.picker.screen.via.placeholder.text",
                        sections: locationPickerSections,
                        navigationTitle: "location.picker.screen.via.navigation.title"
                    )
                }
            }
            .toolbar {
                NavigationButton.Close {
                    self.navigationID = nil
                }
            }
        }
    }
    
    @ViewBuilder
    private func push(to destinationNavigationID: PushNavigationID) -> some View {
        switch destinationNavigationID {
        case .results:
            JourneyResultsScreen(
                form: $form
            )
        }
    }
    
    @ViewBuilder
    private func locationPicker(placeholder: LocalizedStringKey,
                                sections: [JourneyLocationPicker.SectionState],
                                navigationTitle: LocalizedStringKey) -> some View {
        JourneyLocationPickerView(
            searchTerm: $searchTerm,
            placeholder: placeholder,
            sections: sections,
            locationUIStatus: locationUIStatus,
            onAction: handleLocationPickerAction
        )
        .navigationTitle(navigationTitle)
    }
    
    private var locationUIStatus: LocationUIStatus {
        .init(
            style: location.locationUIStyle(showsSetUpHeader: false),
            onRequestPermissions: {
                handleSelectedLocationValue(.currentLocation(.unknown))
                location.promptForPermissions()
            }
        )
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
        stationSearchResults = stations.filteredStations(matchingName: searchTerm)
        nationRailSearchResults = stations.filteredNationalRailStations(matching: searchTerm)
    }
    
    private func handleSelectedLocationValue(_ value: JourneyLocationPicker.Value) {
        switch navigationID {
        case .fromLocation:
            form.from = value
        case .toLocation:
            form.to = value
        case .viaLocation:
            form.via = value
        case nil:
            break
        }
        
        navigationID = nil
    }
    
    private func handleFormAction(_ actionEvent: JourneyPlannerForm.Action) {
        switch actionEvent {
        case let .tapLocationField(locationFieldID):
            showLocationPicker(for: locationFieldID)
        case let .deleteRecentJourney(recentJourneyItem):
            delete(recentJourneyItem: recentJourneyItem)
        case let .selectRecentJourney(recentJourneyItem):
            form = recentJourneyItem.toJourneyPlannerForm(timeSelection: form.timeSelection)
            showResults()
        case .submit:
            showResults()
        }
    }
    
    private func showResults() {
        navigationPath.append(PushNavigationID.results)
    }
    
    private func showLocationPicker(for fieldID: JourneyPlannerForm.FieldID.LocationID) {
        searchTerm = ""
        
        switch fieldID {
        case .from:
            navigationID = .fromLocation
        case .to:
            navigationID = .toLocation
        case .via:
            navigationID = .viaLocation
        }
        
        updateSuggestions()
    }
    
    private func delete(recentJourneyItem: RecentJourneyItem) {
        guard let recentJourney = recentJourneyItem.toSavedJourney() else {
            return
        }
        userPreferences.remove(recentJourney: recentJourney)
    }
}


// MARK: - Previews

#if DEBUG
#Preview {
    JourneyPlannerScreen()
        .withStubbedEnvironment()
}
#endif
// swiftlint:enable type_body_length
