import DataStores
import Models
import PresentationViews
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


    // MARK: - Layout

    var body: some View {
        @Bindable var router = router
        NavigationStack(path: $router.arrivals.path) {
            ArrivalsPickerView(
                favourites: favouriteStations.map { StopRow(station: $0) },
                recents: recentRows,
                nearby: location.nearestStations.prefix(nearbyLimit).map(StopRow.init),
                canShowMoreNearby: location.nearestStations.count > nearbyLimit,
                locationAccess: locationAccess,
                onAction: handleAction
            )
            .navigationTitle(Text(L10n.arrivalsPickerNavigationTitle))
            .withSettingsToolbarButton()
            .refreshable {
                location.refreshCurrentLocation()
            }
            .appRouteDestinations()
        }
        .detectsLocationChanges(action: handleLocationChangeAction)
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
            router.startSearch()
        case .tappedShowMoreNearby:
            nearbyLimit += Self.nearbyPageSize
        case .tappedRefreshNearby:
            location.refreshCurrentLocation()
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
