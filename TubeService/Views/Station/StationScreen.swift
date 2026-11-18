import DataStores
import Models
import PresentationViews
import SwiftUI

@MainActor
struct StationScreen: View {

    @Environment(Navigator.self) private var navigator
    @Environment(LineStatusDataStore.self) private var lineStatus
    @Environment(StationsDataStore.self) private var stations

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
                StationView(
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

    private var arrivals: StationView.Arrivals {
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

    private var info: StationView.Info {
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

    private func handleAction(_ action: StationView.Action) {
        switch action {
        case .selectedLineGroup(let lineGroup):
            userPreferences.saveSelectedLineGroup(lineGroup, at: station)
        case .tappedInfo, .tappedLineStatusRow:
            userPreferences.markNoticesSeen(notices.map(\.text), at: station.id)
            navigator.present(.station(.info(station)))
        }
    }
}

// MARK: - Previews

import ModelStubs

#if DEBUG
    #Preview {
        PreviewEnvironment(withNavigationHost: true) {
            StationScreen(station: ModelStubs.kingsCrossStation)
        }
    }
#endif
