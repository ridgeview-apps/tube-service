import Combine
import DataStores
import Models
import PresentationViews
import SwiftUI

struct JourneyPlannerScreen: View {
    
    @Environment(\.openURL) var openURL
    
    @State private var form: JourneyPlannerForm = .default
    
    @State private var navigationID: NavigationID?
    
    enum NavigationID: Identifiable {
        var id: Self { self }
        case fromLocation, toLocation, timePicker
    }
    
    enum PushNavigationID {
        case results
    }
    
    @State private var stationSearchResults: [Station] = []
    @State private var nationRailSearchResults: [StopPoint] = []
    @State private var recentlyUsedSection: JourneyLocationPicker.SectionState = .recent([])
    @State private var nearbyStationsSection: JourneyLocationPicker.SectionState = .nearbyStations([])
    @State private var searchTerm = ""
    @State private var navigationPath = NavigationPath()
        
    @Environment(\.transportAPI) var transportAPI
    @EnvironmentObject var location: LocationDataStore
    @EnvironmentObject var stations: StationsDataStore
    @EnvironmentObject var localSearchCompleter: LocalSearchCompleter
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            JourneyPlannerFormView(
                form: $form,
                onAction: handleFormAction,
                currentLocationAccessoryStatus: .loadingState(location.detectionState.toLoadingState())
            )
            .navigationDestination(for: PushNavigationID.self) { destinationNavigationID in
                push(to: destinationNavigationID)
            }
            .navigationTitle("journey.planner.navigation.title")
            .sheet(item: $navigationID) { navgationID in
                handleNavigation(navgationID)
            }
            .onChange(of: location.currentLocation) { _ in
                updateSuggestions()
            }
            .task {
                updateSuggestions()
            }
            .onAppear {
                location.refreshCurrentLocationIfAuthorized()
            }
        }
    }
    
    private func updateSuggestions() {
        nearbyStationsSection = .nearbyStations(
            location.nearbyStations.prefix(3).map { .station($0.station) }
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
                        sections: sections(forFieldID: .from),
                        navigationTitle: "location.picker.screen.from.navigation.title"
                    )
                case .toLocation:
                    locationPicker(
                        placeholder: "location.picker.screen.to.placeholder.text",
                        sections: sections(forFieldID: .to),
                        navigationTitle: "location.picker.screen.to.navigation.title"
                    )
                case .timePicker:
                    EmptyView()
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
            onAllowLocation: {
                handleSelectedLocationValue(.currentLocation(name: nil))
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
    
    private func sections(forFieldID: JourneyPlannerForm.FieldID) -> [JourneyLocationPicker.SectionState] {
        if !searchTerm.isEmpty {
            [mergedSearchResults()]
        } else {
            [
                .userLocation(name: location.currentLocationName),
                nearbyStationsSection,
                recentlyUsedSection
            ]
        }
    }
    
    private func mergedSearchResults() -> JourneyLocationPicker.SectionState {
        let stationValues: [JourneyLocationPicker.Value] = stationSearchResults.map { .station($0) }
        let nationalRailValues: [JourneyLocationPicker.Value] = nationRailSearchResults.map { .nationalRail($0) }
        let otherLocationValues: [JourneyLocationPicker.Value] = localSearchCompleter.results.map { .searchResult($0) }
        
        
        return .searchResults(stationValues + nationalRailValues + otherLocationValues)
    }
    
    private func handleSelectedLocationValue(_ value: JourneyLocationPicker.Value) {
        switch navigationID {
        case .fromLocation:
            form.from = value
        case .toLocation:
            form.to = value
        default:
            break
        }
        navigationID = nil
    }
    
    private func handleFormAction(_ actionEvent: JourneyPlannerForm.Action) {
        switch actionEvent {
        case let .select(fieldID):
            showPicker(for: fieldID)
        case let .clear(fieldID):
            clear(fieldID)
        case .submit:
            navigationPath.append(PushNavigationID.results)
        }
    }
    
    private func showPicker(for fieldID: JourneyPlannerForm.FieldID) {
        switch fieldID {
        case .from:
            searchTerm = ""
            navigationID = .fromLocation
        case .to:
            searchTerm = ""
            navigationID = .toLocation
        case .timeOption:
            navigationID = .timePicker
        }
    }
    
    private func clear(_ fieldID: JourneyPlannerForm.FieldID) {
        switch fieldID {
        case .from:
            form.from = nil
        case .to:
            form.to = nil
        case .timeOption:
            return
        }
    }
}

struct JourneyResultsScreen: View {
    
    enum JourneyPlannerResultsError: Error {
        case locationValueError
    }
    
    @State private var loadingState: LoadingState = .loaded
    @State private var journeyItinerary: JourneyItinerary?
    
    @Environment(\.transportAPI) var transportAPI
    @EnvironmentObject var location: LocationDataStore
    @EnvironmentObject var stations: StationsDataStore
    @EnvironmentObject var localSearchCompleter: LocalSearchCompleter

    @Binding var form: JourneyPlannerForm
    
    @Namespace private var animationNamespace
    
    var body: some View {
        Group {
            if let fromLocation = form.from,
               let toLocation = form.to {
                JourneyResultsView(
                    loadingState: loadingState,
                    journeys: journeyItinerary?.journeys?.sortedByArrivalTime() ?? [],
                    fromLocation: fromLocation,
                    toLocation: toLocation,
                    onAction: handleResultsAction
                )
                .navigationBarTitleDisplayMode(.inline)
            }
        }
        .navigationTitle("journey.results.navigation.title")
        .task {
            await fetchData()
        }
    }
    
    private func handleResultsAction(_ action: JourneyResultsView.Action) {
        switch action {
        case .refresh:
            Task {
                await fetchData()
            }
        }
    }

    private func fetchData() async {
        do {
            loadingState = .loading
            let apiParams = try await buildAPIParams()
            journeyItinerary = try await transportAPI.fetchJourneyItinerary(for: apiParams)
            loadingState = .loaded
        } catch {
            loadingState = .failure(errorMessage: error.toUIErrorMessage())
        }
    }
    
    
    private func buildAPIParams() async throws -> JourneyItineraryParams {
        guard let fromValue = form.from,
              let toValue = form.to else {
            throw JourneyPlannerResultsError.locationValueError
        }
        
        async let fetchFromLocation = journeyLocation(for: fromValue)
        async let fetchToLocation = journeyLocation(for: toValue)

        let (fromLocation, toLocation) = try await (fetchFromLocation, fetchToLocation)
        
        guard let fromLocation, let toLocation else {
            throw JourneyPlannerResultsError.locationValueError
        }
        
        return .init(from: fromLocation, to: toLocation)
    }
    
    private func journeyLocation(for locationPickerValue: JourneyLocationPicker.Value) async throws -> JourneyItineraryParams.JourneyLocation? {
        switch locationPickerValue {
        case .currentLocation:
            guard let location = location.currentLocation else {
                throw JourneyPlannerResultsError.locationValueError
            }
            return .coordinate(location)
        case .station(let station):
            return .icsCode(station.icsCode)
        case .nationalRail(let stopPoint):
            guard let icsCode = stopPoint.icsCode else {
                assertionFailure("Invalid national rail stoppoint detected: \(stopPoint)")
                return .icsCode("")
            }
            return .icsCode(icsCode)
        case .searchResult(let searchResult):
            let location = try await localSearchCompleter.location(for: searchResult)
            return .coordinate(location)
        }
    }
}

extension Sequence where Element == Journey {
    
    func sortedByArrivalTime() -> [Journey] {
        filter {
            ($0.duration ?? 0) > 0
        }
        .sorted {
            $0.arrivalDateTime ?? .distantPast < $1.arrivalDateTime ?? .distantPast
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
