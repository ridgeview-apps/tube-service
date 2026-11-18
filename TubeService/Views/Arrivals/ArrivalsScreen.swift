import DataStores
import Models
import PresentationViews
import Shared
import SwiftUI

@MainActor
struct ArrivalsScreen: View {

    @Environment(Navigator.self) private var navigator
    @Environment(StationsDataStore.self) private var stations
    @Environment(LocationDataStore.self) private var location
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    @AppStorage(
        UserDefaults.Keys.userPreferences.rawValue,
        store: AppDependencies.current.userDefaults.value
    )
    private var userPreferences: UserPreferences = .default

    private static let nearbyPageSize = 3
    private static let maxRecents = 3

    @State private var nearbyLimit = nearbyPageSize
    @State private var searchText = ""
    @State private var isSearchPresented = false

    // The automatic placement hides the field until you scroll on iOS 27 in compact width. In regular width the
    // drawer spans the whole window, wider than the list's maximum width.
    private var searchFieldPlacement: SearchFieldPlacement {
        horizontalSizeClass == .compact ? .navigationBarDrawer(displayMode: .always) : .automatic
    }

    // MARK: - Layout

    var body: some View {
        ArrivalsView(
            content: content,
            locationAccess: locationAccess,
            onAction: handleAction
        )
        .navigationTitle(Text(L10n.arrivalsNavigationTitle))
        .searchable(
            text: $searchText,
            isPresented: $isSearchPresented,
            placement: searchFieldPlacement,
            prompt: Text(L10n.searchPrompt)
        )
        .autocorrectionDisabled()
        .withSettingsToolbarButton()
        .refreshable {
            location.refreshCurrentLocation()
        }
        .detectsLocationChanges(action: handleLocationChangeAction)
    }

    private var content: ArrivalsView.Content {
        if searchText.trimmed().isEmpty {
            .browse(
                favourites: favouriteStations.map { StopRow(station: $0) },
                recents: recentRows,
                nearby: location.nearestStations.prefix(nearbyLimit).map(StopRow.init),
                canShowMoreNearby: location.nearestStations.count > nearbyLimit
            )
        } else {
            .searchResults(
                searchTerm: searchText,
                stations: stations.filteredStations(matchingName: searchText).map { StopRow(station: $0) }
            )
        }
    }

    private var favouriteStations: [Station] {
        stations.allLondon.favourites(matching: userPreferences.favouriteStops)
    }

    private var recentRows: [StopRow] {
        let favouriteIDs = Set(favouriteStations.map(\.id))
        return userPreferences.recentlySelectedStations
            .filter { !favouriteIDs.contains($0) }
            .compactMap { stations.station(forID: $0) }
            .prefix(Self.maxRecents)
            .map { StopRow(station: $0) }
    }

    private var locationAccess: LocationAccess {
        .init(
            state: location.locationAccessState(loadingState: location.detectionState.toLoadingState()),
            onRequestPermissions: {
                location.promptForPermissions()
            }
        )
    }

    private func handleLocationChangeAction(_ action: DetectLocationChangesAction) {
        switch action {
        case .coordinateChanged, .nameChanged:
            nearbyLimit = Self.nearbyPageSize
        case .authorizationStatusChanged:
            return
        }
    }

    private func handleAction(_ action: ArrivalsView.Action) {
        switch action {
        case .tappedStation(let station):
            navigator.push(.station(.arrivals(station)))
        case .tappedFindStation:
            isSearchPresented = true
        case .tappedShowMoreNearby:
            nearbyLimit += Self.nearbyPageSize
        case .tappedRefreshNearby:
            location.refreshCurrentLocation()
        case .tappedClearRecents:
            userPreferences.clearRecentlySelectedStations()
        case .reorderFavourites(let stationIDs):
            userPreferences.reorderFavouriteStops(stationIDs.map { .station(id: $0) })
        case .removeFavourites(let stationIDs):
            userPreferences.removeFavouriteStops(stationIDs.map { .station(id: $0) })
        }
    }
}


// MARK: - Previews

#if DEBUG
    #Preview {
        PreviewEnvironment(withNavigationHost: true) {
            ArrivalsScreen()
        }
    }
#endif
