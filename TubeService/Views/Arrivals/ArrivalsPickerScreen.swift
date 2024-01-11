import DataStores
import Models
import PresentationViews
import SwiftUI

@MainActor
struct ArrivalsPickerScreen: View {

    @Environment(StationsDataStore.self) var stations: StationsDataStore
    @Environment(UserPreferencesDataStore.self) var userPreferences: UserPreferencesDataStore
    
    @State private var selection: Station.LineGroup?
    @State private var searchTerm: String = ""
    @State private var selectableStations: [Station] = []
    
    private var isSearching: Bool { !searchTerm.isEmpty }
    private var pickerStyle: ArrivalsPickerStyle {
        isSearching ? .searchResults : .normal(favouriteLineGroupIDs: userPreferences.favouriteLineGroupIDs)
    }
    
    
    // MARK: - Layout
    
    var body: some View {
        NavigationSplitView {
            pickerListView
        } detail: {
            detailView
        }
        .searchable(text: $searchTerm,
                    placement: .navigationBarDrawer(displayMode: .always),
                    prompt: "arrivals.picker.search.placeholder") {
            searchSuggestionsView
        }
        .autocorrectionDisabled()
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
            Text("arrivals.picker.search.no.results")
        } else {
            ArrivalsPickerView(allStations: selectableStations,
                               style: pickerStyle,
                               selection: $selection)
                .navigationTitle("arrivals.picker.navigation.title")
                .withSettingsToolbarButton()
                .onAppear {
                    reloadStations()
                }
        }
    }
    
    private var detailView: some View {
        NavigationStack {
            if let selection {
                ArrivalsBoardListScreen(stationName: stationName(for: selection),
                                        lineGroup: selection)
                .id(selection.id)
            } else {
                Text("arrivals.picker.no.selection")
            }
        }
    }
    
    private func reloadStations() {
        if isSearching {
            selectableStations = stations.filteredStations(matchingName: searchTerm)
        } else {
            selectableStations = stations.allStations
        }
    }
    
    private func stationName(for lineGroup: Station.LineGroup) -> String {
        stations.station(forLineGroupID: lineGroup.id)?.name ?? ""
    }
    
    private func saveRecentSelection(for lineGroup: Station.LineGroup?) {
        if let lineGroup, let station = stations.station(forLineGroupID: lineGroup.id) {
            userPreferences.save(recentlySelectedStationID: station.id)
        }
    }
    
    @ViewBuilder private var searchSuggestionsView: some View {
        // N.B. Suggestions are only shown initially when the search bar is activated (i.e. once typing, results are shown).
        if searchTerm.isEmpty {
            Group {
                if userPreferences.recentlySelectedStations.isEmpty {
                    Text("") // Workaround: prevents the results list from showing before a search is performed
                } else {
                    Section {
                        ForEach(userPreferences.recentlySelectedStations, id: \.self) { stationID in
                            if let station = stations.station(forID: stationID) {
                                Text(station.name).searchCompletion(station.name)
                            }
                        }
                    } header: {
                        Text("search.suggestions.section.title")
                    }
                }
            }
            .listRowSeparator(.hidden)
        }
    }
}


// MARK: - Previews

#if DEBUG
struct ArrivalsPickerScreen_Previews: PreviewProvider {
    static var previews: some View {
        ArrivalsPickerScreen()
            .withStubbedEnvironment()
    }
}
#endif
