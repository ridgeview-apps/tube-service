import DataStores
import Models
import PresentationViews
import Shared
import SwiftUI

@MainActor
struct ArrivalsStopPickerScreen: View {

    @Environment(Navigator.self) private var navigator
    @Environment(StationsDataStore.self) private var stations
    @Environment(LocationDataStore.self) private var location
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    @AppStorage(
        UserDefaults.Keys.userPreferences.rawValue,
        store: AppDependencies.current.userDefaults.value
    )
    private var userPreferences: UserPreferences = .default

    @AppStorage(
        UserDefaults.Keys.featureFlags.rawValue,
        store: AppDependencies.current.userDefaults.value
    )
    private var featureFlags: FeatureFlags = .default

    private static let maxNearby = 9
    private static let maxRecents = 3

    private static let maxBusNearbyPlaces = 20
    private static let maxBusPlaceDistance: Double = 500

    @State private var searchText = ""
    @State private var isSearchPresented = false
    @State private var arrivalsMode = ArrivalsMode.trains

    // The automatic placement hides the field until you scroll on iOS 27 in compact width. In regular width the
    // drawer spans the whole window, wider than the list's maximum width.
    private var searchFieldPlacement: SearchFieldPlacement {
        horizontalSizeClass == .compact ? .navigationBarDrawer(displayMode: .always) : .automatic
    }

    // MARK: - Layout

    var body: some View {
        modeContent
            .navigationTitle(Text(L10n.arrivalsNavigationTitle))
            .navigationBarTitleDisplayMode(.inline)
            .searchable(
                text: $searchText,
                isPresented: $isSearchPresented,
                placement: searchFieldPlacement,
                prompt: Text(L10n.searchPrompt)
            )
            .autocorrectionDisabled()
            .refreshable {
                location.refreshCurrentLocation()
            }
            .detectsLocationChanges()
    }

    @ViewBuilder private var modeContent: some View {
        if featureFlags.isBusesEnabled {
            selectedModeView
                .safeAreaBar(edge: .top) {
                    ArrivalsModePicker(selectedMode: $arrivalsMode)
                }
        } else {
            trainsView
        }
    }

    @ViewBuilder private var selectedModeView: some View {
        if arrivalsMode == .buses && searchText.trimmed().isEmpty {
            BusStopsView(
                favourites: favouriteBusStops,
                recents: recentBusStops,
                nearby: nearbyBusPlaces,
                locationAccess: locationAccess,
                onAction: handleBusStopsAction
            )
        } else {
            trainsView
        }
    }

    private var trainsView: some View {
        ArrivalsStopPickerView(
            content: content,
            locationAccess: locationAccess,
            onAction: handleAction
        )
    }

    private var nearbyBusPlaces: [NearbyBusPlace] {
        guard let coordinate = location.currentLocationCoordinate else { return [] }
        return BusStopDatabase.london.nearbyPlaces(
            to: coordinate,
            within: Self.maxBusPlaceDistance,
            limit: Self.maxBusNearbyPlaces
        )
    }

    private var favouriteBusStops: [BusStop] {
        BusStopDatabase.london.stops(ids: userPreferences.favouriteStops.busStopIDs)
    }

    private var recentBusStops: [BusStop] {
        let favouriteIDs = Set(userPreferences.favouriteStops.busStopIDs)
        let recentIDs = userPreferences.recentlySelectedBusStops.filter { !favouriteIDs.contains($0) }
        return Array(BusStopDatabase.london.stops(ids: recentIDs).prefix(Self.maxRecents))
    }

    private var content: ArrivalsStopPickerView.Content {
        if searchText.trimmed().isEmpty {
            .browse(
                favourites: favouriteStations.map { StopRow(station: $0) },
                recents: recentRows,
                nearby: location.nearestStations.prefix(Self.maxNearby).map(StopRow.init)
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

    private func handleAction(_ action: ArrivalsStopPickerView.Action) {
        switch action {
        case .tappedStation(let station):
            navigator.push(.station(.arrivals(station)))
        case .tappedFindStation:
            isSearchPresented = true
        case .tappedRefreshNearby:
            location.refreshCurrentLocation()
        case .tappedClearRecents:
            userPreferences.clearRecentlySelectedStations()
        case .removeRecent(let stationID):
            userPreferences.removeRecentlySelectedStation(stationID)
        case .reorderFavourites(let stationIDs):
            userPreferences.reorderFavouriteStops(stationIDs.map { .station(id: $0) })
        case .removeFavourites(let stationIDs):
            userPreferences.removeFavouriteStops(stationIDs.map { .station(id: $0) })
        }
    }

    private func handleBusStopsAction(_ action: BusStopsView.Action) {
        switch action {
        case .tappedStop(let stop):
            navigator.push(.busStop(.arrivals(stop)))
        case .tappedRefreshNearby:
            location.refreshCurrentLocation()
        case .tappedClearRecents:
            userPreferences.clearRecentlySelectedBusStops()
        case .removeRecent(let stopID):
            userPreferences.removeRecentlySelectedBusStop(stopID)
        case .reorderFavourites(let stopIDs):
            userPreferences.reorderFavouriteStops(stopIDs.map { .busStop(id: $0) })
        case .removeFavourites(let stopIDs):
            userPreferences.removeFavouriteStops(stopIDs.map { .busStop(id: $0) })
        }
    }
}


// MARK: - Previews

#if DEBUG
    #Preview {
        PreviewEnvironment(withNavigationHost: true) {
            ArrivalsStopPickerScreen()
        }
    }
#endif
