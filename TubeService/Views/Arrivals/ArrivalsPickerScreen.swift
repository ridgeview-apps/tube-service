import Models
import PresentationViews
import SwiftUI

struct ArrivalsPickerScreen: View {

    @EnvironmentObject var stations: StationsModel
    @EnvironmentObject var userPreferences: UserPreferencesModel
    
    @State private var selectedLineGroup: Station.LineGroup?
    @State private var searchTerm: String = ""
    @State private var selectedFilterOption: UserPreferences.ArrivalsPickerFilterOption = .all
    @State private var selectableStations: [Station] = []
    
    private var isSearching: Bool { !searchTerm.isEmpty }
    
    
    // MARK: - Layout
    
    var body: some View {
        NavigationSplitView {
            pickerListView
        } detail: {
            arrivalsBoardsDetailView
        }
        .searchable(text: $searchTerm,
                    placement: .navigationBarDrawer(displayMode: .always),
                    prompt: "arrivals.picker.search.placeholder") {
            searchSuggestionsView
        }
        .autocorrectionDisabled()
        .onChange(of: searchTerm) { _ in
            reloadStations()
        }
        .onSubmit(of: .search) {
            reloadStations()
        }
        .onChange(of: selectedLineGroup) { newValue in
            saveRecentSelection(for: newValue)
        }
    }
    
    @ViewBuilder private var pickerListView: some View {
        if isSearching && selectableStations.isEmpty {
            Text("arrivals.picker.search.no.results")
        } else {
            ArrivalsPickerView(stations: selectableStations,
                               selectedLineGroup: $selectedLineGroup,
                               selectedFilterOption: $selectedFilterOption,
                               showsFilterOptions: searchTerm.isEmpty)
                .navigationTitle("arrivals.picker.navigation.title")
                .withSettingsToolbarButton()
                .onAppear {
                    selectedFilterOption = userPreferences.lastUsedFilterOption
                    reloadStations()
                }
                .onChange(of: selectedFilterOption) { newValue in
                    userPreferences.save(lastUserFilterOption: newValue)
                    reloadStations()
                }
        }
    }
    
    private var arrivalsBoardsDetailView: some View {
        NavigationStack {
            if let selectedLineGroup {
                ArrivalsBoardListScreen(stationName: stationName(for: selectedLineGroup),
                                        lineGroup: selectedLineGroup)
                    .id(selectedLineGroup.id)
            } else {
                Text("arrivals.picker.no.selection")
            }
        }
    }
    
    private func reloadStations() {
        if isSearching {
            selectableStations = stations.filteredStations(matchingName: searchTerm)
        } else {
            switch selectedFilterOption {
            case .all:
                selectableStations = stations.allStations
            case .favourites:
                selectableStations = stations.filteredStations(matchingLineGroupIDs: userPreferences.favourites)
            }
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
                    Text("") // Prevents the list from showing through before a search is performed
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
