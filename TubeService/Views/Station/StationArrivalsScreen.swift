import DataStores
import Models
import PresentationViews
import Shared
import SwiftUI

@MainActor
struct StationArrivalsScreen: View {

    @Environment(Navigator.self) private var navigator
    @Environment(LineStatusDataStore.self) private var lineStatus
    @Environment(StationsDataStore.self) private var stations
    @Environment(\.clock) private var clock

    @AppStorage(
        UserDefaults.Keys.userPreferences.rawValue,
        store: AppDependencies.current.userDefaults.value
    )
    private var userPreferences: UserPreferences = .default

    @State private var arrivalsBoard = ArrivalsBoardStore(
        tflAPI: AppDependencies.current.tflAPI,
        now: { AppDependencies.current.clock.now }
    )

    let station: Station

    // MARK: - Layout

    var body: some View {
        Group {
            if let selectedLineGroup {
                StationArrivalsView(
                    station: station,
                    selectedLineGroup: selectedLineGroup,
                    arrivals: arrivals,
                    info: info,
                    isFavourite: isFavouriteStation,
                    onRefresh: {
                        // In its own task because SwiftUI cancels the refreshable's task when the screen updates
                        // mid-refresh (e.g. as line statuses arrive), which would cancel the board's fetch too
                        await Task { await refreshData() }.value
                    },
                    onAction: handleAction
                )
                // Restarts on appear too, because the refresh stops while another screen is pushed on top
                .onAppear {
                    arrivalsBoard.startAutoRefresh(for: selectedLineGroup)
                }
                .onChange(of: selectedLineGroup) {
                    arrivalsBoard.startAutoRefresh(for: selectedLineGroup)
                }
            }
        }
        .navigationTitle(station.name)
        .navigationSubtitle(arrivals.lastUpdatedSubtitle)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            // Always shown, as every station has a location, so the toolbar doesn't shift once notices load
            ToolbarItem {
                StationInfoButton(badge: .init(info: info, stationName: station.name, now: clock.now)) {
                    openInfo()
                }
            }
            ToolbarItem {
                FavouritesButton(.station, style: .small, isSelected: isFavouriteStation)
            }
        }
        .task {
            await refreshDataIfStale()
        }
        .onAppear {
            userPreferences.saveRecentlySelectedStation(station.id)
        }
        .onDisappear {
            arrivalsBoard.stopAutoRefresh()
        }
        .onSceneDidBecomeActive {
            Task {
                await refreshDataIfStale()
            }
        }
    }

    private var selectedLineGroup: Station.LineGroup? {
        userPreferences.selectedLineGroup(at: station)
    }

    // MARK: - Data

    private func refreshDataIfStale() async {
        async let lineStatuses: () = lineStatus.refreshIfStale(for: .live)
        async let stationDisruptions: () = stations.refreshStationDisruptionsIfStale()
        _ = await (lineStatuses, stationDisruptions)
        pruneSeenNotices()
    }

    private func refreshData() async {
        async let lineStatuses: () = lineStatus.refresh(for: .live)
        async let stationDisruptions: () = stations.refreshStationDisruptions()
        async let boards: () = refreshArrivalsBoard()
        _ = await (lineStatuses, stationDisruptions, boards)
        pruneSeenNotices()
    }

    private func pruneSeenNotices() {
        guard let publishedNoticeTexts = stations.publishedNoticeTexts else { return }
        userPreferences.pruneSeenNotices(keeping: publishedNoticeTexts)
    }

    private func refreshArrivalsBoard() async {
        guard let selectedLineGroup else { return }
        await arrivalsBoard.refresh(for: selectedLineGroup)
        arrivalsBoard.resetAutoRefreshTimer(for: selectedLineGroup)
    }

    private var arrivals: StationArrivalsView.Arrivals {
        .init(
            boardStates: boardStates,
            refreshDate: arrivalsBoard.boardData.fetchedAt,
            loadingState: arrivalsBoard.boardData.fetchState.loadingState
        )
    }

    private var boardStates: [ArrivalsBoardState] {
        switch arrivalsBoard.boardData.value {
        case .predictions(let predictions):
            return predictions.toPlatformBoardStates()
        case .departures(let lineID, let items):
            return items.toPlatformBoardStates(forLineID: lineID)
        case nil:
            return []
        }
    }

    private var notices: [StationNotice] {
        stations.notices(forStationID: station.id)
    }

    private var info: StationInfo {
        .init(station: station, lineStatus: lineStatus, stations: stations, userPreferences: userPreferences)
    }

    private var isFavouriteStation: Binding<Bool> {
        .init {
            userPreferences.containsFavouriteStop(.station(id: station.id))
        } set: { isFavourite in
            if isFavourite {
                userPreferences.addFavouriteStop(.station(id: station.id))
            } else {
                userPreferences.removeFavouriteStops([.station(id: station.id)])
            }
        }
    }

    // MARK: - Actions

    private func handleAction(_ action: StationArrivalsView.Action) {
        switch action {
        case .selectedLineGroup(let lineGroup):
            userPreferences.saveSelectedLineGroup(lineGroup, at: station)
        case .tappedLineStatusRow:
            openInfo()
        }
    }

    private func openInfo() {
        userPreferences.markNoticesSeen(notices.map(\.text), at: station.id)
        navigator.present(.station(.info(station)))
    }
}

// MARK: - Previews

import ModelStubs

#if DEBUG
    #Preview {
        PreviewEnvironment(withNavigationHost: true) {
            StationArrivalsScreen(station: ModelStubs.kingsCrossStation)
        }
    }
#endif
