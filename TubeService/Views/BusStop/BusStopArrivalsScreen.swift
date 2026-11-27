import DataStores
import Models
import PresentationViews
import Shared
import SwiftUI

@MainActor
struct BusStopArrivalsScreen: View {

    @Environment(Navigator.self) private var navigator
    @Environment(BusStopsDataStore.self) private var busStops

    @AppStorage(
        UserDefaults.Keys.userPreferences.rawValue,
        store: AppDependencies.current.userDefaults.value
    )
    private var userPreferences: UserPreferences = .default

    @State private var arrivalsBoard = ArrivalsBoardStore(
        tflAPI: AppDependencies.current.tflAPI,
        now: { AppDependencies.current.clock.now }
    )

    @State private var stop: BusStop
    @State private var selectedRoute: String?

    init(stop: BusStop) {
        _stop = State(initialValue: stop)
    }

    // MARK: - Layout

    var body: some View {
        BusStopArrivalsView(
            stop: stop,
            oppositeStop: BusStopDatabase.london.oppositeStop(of: stop),
            routes: routes,
            selectedRoute: selectedRoute,
            arrivals: arrivals,
            notices: busStops.notices(forStopID: stop.id),
            isFavourite: isFavouriteStop,
            onRefresh: {
                // In its own task because SwiftUI cancels the refreshable's task when the screen updates
                // mid-refresh, which would cancel the board's fetch too
                await Task { await refreshArrivalsBoard() }.value
            },
            onAction: handleAction
        )
        .navigationTitle(stop.name)
        .navigationSubtitle(arrivals.lastUpdatedSubtitle)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem {
                StationInfoButton(title: L10n.busStopInfoTitle) {
                    openInfo()
                }
            }
            ToolbarItem {
                FavouritesButton(.busStop, style: .small, isSelected: isFavouriteStop)
            }
        }
        // Restarts on appear too, because the refresh stops while another screen is pushed on top
        .onAppear {
            arrivalsBoard.startAutoRefresh(for: .busStop(stop.id))
        }
        .onChange(of: stop) {
            arrivalsBoard.startAutoRefresh(for: .busStop(stop.id))
        }
        .onDisappear {
            arrivalsBoard.stopAutoRefresh()
        }
        .task(id: stop) {
            userPreferences.saveRecentlySelectedBusStop(stop.id)
            await busStops.refreshNoticesIfStale(for: stop.id)
        }
        .onSceneDidBecomeActive {
            Task {
                await busStops.refreshNoticesIfStale(for: stop.id)
            }
        }
    }

    // MARK: - Data

    private var busArrivals: [BusArrival] {
        guard case .busArrivals(let busArrivals) = arrivalsBoard.boardData.value else { return [] }
        return busArrivals
    }

    private var routes: [String] {
        busArrivals.routes(at: stop)
    }

    private var arrivals: LiveArrivals {
        .init(
            boardStates: busArrivals.toBoardStates(at: stop, route: selectedRoute),
            refreshDate: arrivalsBoard.boardData.fetchedAt,
            loadingState: arrivalsBoard.boardData.fetchState.loadingState
        )
    }

    private var isFavouriteStop: Binding<Bool> {
        .init {
            userPreferences.containsFavouriteStop(.busStop(id: stop.id))
        } set: { isFavourite in
            if isFavourite {
                userPreferences.addFavouriteStop(.busStop(id: stop.id))
            } else {
                userPreferences.removeFavouriteStops([.busStop(id: stop.id)])
            }
        }
    }

    private func refreshArrivalsBoard() async {
        await arrivalsBoard.refresh(for: .busStop(stop.id))
        arrivalsBoard.resetAutoRefreshTimer(for: .busStop(stop.id))
    }

    // MARK: - Actions

    private func handleAction(_ action: BusStopArrivalsView.Action) {
        switch action {
        case .selectedRoute(let route):
            selectedRoute = route
        case .tappedOpposite(let oppositeStop):
            stop = oppositeStop
            selectedRoute = nil
        case .tappedNotice:
            openInfo()
        }
    }

    private func openInfo() {
        navigator.present(.busStop(.info(stop)))
    }
}

// MARK: - Previews

#if DEBUG
    #Preview {
        PreviewEnvironment(withNavigationHost: true) {
            BusStopArrivalsScreen(stop: BusStopDatabase.london.nearbyStops(to: LocationCoordinate(lat: 51.53047, lon: -0.12169), limit: 1)[0].stop)
        }
    }
#endif
