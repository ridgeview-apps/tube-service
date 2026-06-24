import DataStores
import Models
import PresentationViews
import SwiftUI

@MainActor
struct ArrivalsPickerScreen: View {

    @Environment(AppRouter.self) private var router
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
        @Bindable var router = router
        NavigationStack(path: $router.arrivalsPath) {
            rootView
                .appRouteDestinations()
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
            guard let newValue else { return }
            saveRecentSelection(for: newValue)
            router.push(.arrivalsBoard(lineGroup: newValue, stationName: stationName(for: newValue)))
            selection = nil
        }
    }

    private var rootView: some View {
        pickerListView
            .searchable(
                text: $searchTerm,
                prompt: Text(L10n.arrivalsPickerSearchPlaceholder)
            ) {
                searchSuggestionsView
            }
            .autocorrectionDisabled()
    }

    @ViewBuilder private var pickerListView: some View {
        if isSearching && selectableStations.isEmpty {
            Text(L10n.arrivalsPickerSearchNoResults)
        } else {
            ArrivalsPickerView(
                allStations: selectableStations,
                mode: pickerMode,
                selection: $selection
            )
            .navigationTitle(Text(L10n.arrivalsPickerNavigationTitle))
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

    private func saveRecentSelection(for lineGroup: Station.LineGroup) {
        if let station = stations.station(forLineGroupID: lineGroup.id) {
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
                            Text(L10n.searchSuggestionsSectionTitle)
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
        .environment(AppRouter())
    }
#endif
