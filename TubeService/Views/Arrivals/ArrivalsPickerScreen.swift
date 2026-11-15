import DataStores
import Models
import PresentationViews
import Shared
import SwiftUI

@MainActor
struct ArrivalsPickerScreen: View {

    @Environment(AppRouter.self) private var router
    @Environment(StationsDataStore.self) private var stations
    @Environment(LocationDataStore.self) private var location

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


    // MARK: - Layout

    var body: some View {
        @Bindable var router = router
        NavigationStack(path: $router.arrivals.path) {
            ArrivalsPickerView(
                content: content,
                locationAccess: locationAccess,
                onAction: handleAction
            )
            .navigationTitle(Text(L10n.arrivalsPickerNavigationTitle))
            // An explicit placement, as the automatic one hides the field until you scroll on iOS 27
            .searchable(
                text: $searchText,
                isPresented: $isSearchPresented,
                placement: .navigationBarDrawer(displayMode: .always),
                prompt: Text(L10n.searchPrompt)
            )
            .autocorrectionDisabled()
            .withSettingsToolbarButton()
            .refreshable {
                location.refreshCurrentLocation()
            }
            .appRouteDestinations()
        }
        .detectsLocationChanges(action: handleLocationChangeAction)
    }

    private var content: ArrivalsPickerView.Content {
        if searchText.trimmed().isEmpty {
            .suggestions(
                favourites: favouriteStations.map { StopRow(station: $0) },
                recents: recentRows,
                nearby: location.nearestStations.prefix(nearbyLimit).map(StopRow.init),
                canShowMoreNearby: location.nearestStations.count > nearbyLimit
            )
        } else {
            .results(
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

    private func handleAction(_ action: ArrivalsPickerView.Action) {
        switch action {
        case .tappedStation(let station):
            router.push(.station(station))
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
        PreviewEnvironment {
            ArrivalsPickerScreen()
        }
        .environment(AppRouter())
    }
#endif
