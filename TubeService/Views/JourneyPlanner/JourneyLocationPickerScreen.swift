import DataStores
import Models
import PresentationViews
import SwiftUI

extension JourneyLocationPickerScreen {
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

    @Environment(JourneyPlannerStore.self) var journeyPlanner
    @Environment(LocalSearchResultsStore.self) var localSearchResults
    @Environment(LocationDataStore.self) var location
    @Environment(StationsDataStore.self) var stations
    @Environment(\.dismiss) var dismiss

    @AppStorage(
        UserDefaults.Keys.userPreferences.rawValue,
        store: AppDependencies.current.userDefaults.value
    )
    private var userPreferences: UserPreferences = .default

    @State private var suggestionsSection: JourneyLocationPicker.SectionState = .suggestions([])
    @State private var nearbyStationsSection: JourneyLocationPicker.SectionState = .nearbyStations([])
    @State private var searchTerm = ""
    @State private var resultsAggregator = ResultsAggregator()

    let fieldID: JourneyPlannerForm.FieldID.LocationID

    private var currentSelection: JourneyLocationPicker.Value? {
        journeyPlanner.form.locationValue(for: fieldID)
    }

    private var recentJourneys: [RecentJourneyItem] {
        userPreferences.recentlySavedJourneys.toRecentJourneyItems(
            findStationByID: stations.station(forID:),
            findNationalRailByICSCode: stations.nationalRailStation(forICSCode:),
            sortByLastUsedDate: true
        )
    }

    private var locationPickerSections: [JourneyLocationPicker.SectionState] {
        if !searchTerm.isEmpty {
            [.searchResults(resultsAggregator.all())]
        } else {
            [
                suggestionsSection,
                .favourites(favouriteStations.map { .station($0) }),
                nearbyStationsSection
            ]
        }
    }

    private var favouriteStations: [Station] {
        stations.allLondon.favourites(matching: userPreferences.favouriteStops)
    }


    // MARK: - Layout

    var body: some View {
        JourneyLocationPickerView(
            searchTerm: $searchTerm,
            sections: locationPickerSections,
            locationAccess: locationAccess,
            onAction: handleLocationPickerAction
        )
        .navigationTitle(Text(fieldID.navigationTitle))
        .toolbar { CloseToolbarItem() }
        .detectsLocationChanges {
            handleLocationChangeAction($0)
        }
        .onChange(of: localSearchResults.results) { _, newValue in
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
            location.nearestStations.prefix(3).map { .station($0.station) }
        )
    }

    private func refreshSuggestionsSection() {
        var pickerValues: [JourneyLocationPicker.Value] = [
            .currentLocation(
                name: location.currentLocationName,
                coordinate: location.currentLocationCoordinate
            )
        ]

        let favouriteIDs = Set(favouriteStations.map(\.id))
        let recentJourneyPickerValues =
            recentJourneys
            .flatMap {
                [$0.fromLocation, $0.toLocation, $0.viaLocation]
            }
            .compactMap { $0 }
        let candidates = [currentSelection].compactMap { $0 } + recentJourneyPickerValues

        for candidate in candidates {
            if case .station(let station) = candidate, favouriteIDs.contains(station.id) {
                continue
            }
            if !pickerValues.alreadyContains(candidate) {
                pickerValues.append(candidate)
            }
        }

        suggestionsSection = .suggestions(pickerValues.removingDuplicates())
    }

    private func searchForLocations(matching searchTerm: String) {
        localSearchResults.searchForPlaces(matching: searchTerm)
        resultsAggregator.stations = stations.filteredStations(matchingName: searchTerm)
        resultsAggregator.nationalRailStations = stations.filteredNationalRailStations(matching: searchTerm)
    }

    private var locationAccess: LocationAccess {
        .init(
            state: location.locationAccessState(loadingState: location.detectionState.toLoadingState()),
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

        journeyPlanner.form.populate(locationFieldID: fieldID, with: value)
    }

    private func handleLocationChangeAction(_ action: DetectLocationChangesAction) {
        switch action {
        case .nameChanged, .coordinateChanged, .authorizationStatusChanged:
            refreshAllSections()
        }
    }
}

private extension JourneyPlannerForm.FieldID.LocationID {

    var navigationTitle: LocalizedStringResource {
        switch self {
        case .from:
            L10n.journeyPlannerLocationPickerScreenFromNavigationTitle
        case .to:
            L10n.journeyPlannerLocationPickerScreenToNavigationTitle
        case .via:
            L10n.journeyPlannerLocationPickerScreenViaNavigationTitle
        }
    }
}
