import DataStores
import Models
import PresentationViews
import SwiftUI

@MainActor
struct ArrivalsPickerScreen: View {

    @Environment(StationsDataStore.self) var stations

    @AppStorage(
        UserDefaults.Keys.userPreferences.rawValue,
        store: AppDependencies.current.userDefaults.value
    )
    private var userPreferences: UserPreferences = .default

    @State private var selection: Station.LineGroup?
    @State private var searchTerm: String = ""
    @State private var selectableStations: [Station] = []

    private var isSearching: Bool { !searchTerm.isEmpty }
    private var pickerMode: ArrivalsPickerMode {
        isSearching ? .searchResults : .favouritesVisible(favourites: userPreferences.favouriteLineGroupIDs)
    }


    // MARK: - Layout

    var body: some View {
        NavigationStack {
            pickerListView
                .navigationDestination(item: $selection) { lineGroup in
                    ArrivalsBoardListScreen(
                        stationName: stationName(for: lineGroup),
                        lineGroup: lineGroup
                    )
                    .id(lineGroup.id)
                }
                .searchable(
                    text: $searchTerm,
                    prompt: Text(.arrivalsPickerSearchPlaceholder)
                ) {
                    searchSuggestionsView
                }
                .autocorrectionDisabled()
        }
        .onChange(of: searchTerm) {
            reloadStations()
        }
        .onSubmit(of: .search) {
            reloadStations()
        }
        .onChange(of: userPreferences.favouriteLineGroupIDs) {
            reloadStations()
        }
        .onChange(of: selection) { _, newValue in
            saveRecentSelection(for: newValue)
        }
    }

    @ViewBuilder private var pickerListView: some View {
        if isSearching && selectableStations.isEmpty {
            Text(.arrivalsPickerSearchNoResults)
        } else {
            ArrivalsPickerView(
                allStations: selectableStations,
                mode: pickerMode,
                selection: $selection
            )
            .navigationTitle(Text(.arrivalsPickerNavigationTitle))
            .withSettingsToolbarButton()
            .onAppear {
                reloadStations()
            }
        }
    }

    private func reloadStations() {
        if isSearching {
            selectableStations = stations.filteredStations(matchingName: searchTerm)
        } else {
            selectableStations = stations.allLondon
        }
    }

    private func stationName(for lineGroup: Station.LineGroup) -> String {
        stations.station(forLineGroupID: lineGroup.id)?.name ?? ""
    }

    private func saveRecentSelection(for lineGroup: Station.LineGroup?) {
        if let lineGroup, let station = stations.station(forLineGroupID: lineGroup.id) {
            userPreferences.saveRecentlySelectedStation(station.id)
        }
    }

    @ViewBuilder private var searchSuggestionsView: some View {
        // N.B. Suggestions are only shown initially when the search bar is activated (i.e. once typing, results are shown).
        if searchTerm.isEmpty {
            Group {
                if userPreferences.recentlySelectedStations.isEmpty {
                    Text("")  // Workaround: prevents the results list from showing before a search is performed
                } else {
                    Section {
                        ForEach(userPreferences.recentlySelectedStations, id: \.self) { stationID in
                            if let station = stations.station(forID: stationID) {
                                Text(station.name).searchCompletion(station.name)
                            }
                        }
                    } header: {
                        HStack(spacing: 4) {
                            Image(systemName: "sparkles")
                            Text(.searchSuggestionsSectionTitle)
                                .secondarySectionHeaderStyle()
                        }
                    }
                }
            }
            .listRowSeparator(.hidden)
        }
    }
}


// MARK: - Previews

#if DEBUG
    #Preview {
        PreviewEnvironment {
            ArrivalsPickerScreen()
        }
    }
#endif
