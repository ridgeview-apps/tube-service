import DataStores
import Models
import PresentationViews
import SwiftUI

@MainActor
struct StationScreen: View {

    @Environment(AppRouter.self) private var router
    @Environment(JourneyPlannerStore.self) private var journeyPlanner
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

    /// Set once the first fetch of line statuses and notices finishes, whether or not it succeeded.
    @State private var hasLoadedInfo = false

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
        .refreshable {
            // In its own task because SwiftUI cancels the refreshable's task when the screen updates mid-refresh
            // (e.g. as line statuses arrive), which would cancel the board's fetch too
            await Task { await refreshData() }.value
        }
        .task {
            // A slow connection mustn't hold the boards back for long, so the wait for the cards is capped
            let waitCap = Task {
                guard (try? await Task.sleep(for: .seconds(2))) != nil else { return }
                hasLoadedInfo = true
            }
            await refreshDataIfStale()
            waitCap.cancel()
            hasLoadedInfo = true
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
        let allLines = lineStatus.lineStatusData(for: .live)?.value ?? []
        return .init(
            lines: allLines.filter { station.sortedLineIDs.contains($0.id) },
            notices: notices,
            hasLoaded: hasLoadedInfo,
            hasUnseenNotices: userPreferences.hasUnseenNotices(notices.map(\.text), at: station.id)
        )
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
        case .tappedLine(let line):
            router.push(.lineStatusDetail(lineID: line.id, request: .live))
        case .planJourneyFromHere:
            planJourney(placingStationIn: .from, opposite: .to)
        case .planJourneyToHere:
            planJourney(placingStationIn: .to, opposite: .from)
        case .openedNotices:
            userPreferences.markNoticesSeen(notices.map(\.text), at: station.id)
        }
    }

    private func planJourney(
        placingStationIn field: JourneyPlannerForm.FieldID.LocationID,
        opposite otherField: JourneyPlannerForm.FieldID.LocationID
    ) {
        let stationLocation = JourneyLocation.station(station)
        // A journey from and to the same station can't be planned
        if journeyPlanner.form.locationValue(for: otherField) == stationLocation {
            journeyPlanner.form.populate(locationFieldID: otherField, with: nil)
        }
        journeyPlanner.form.populate(locationFieldID: field, with: stationLocation)
        router.popToRoot(on: .journeyPlanner)
        router.selectedTab = .journeyPlanner
    }
}

// MARK: - Previews

import ModelStubs

#if DEBUG
    #Preview {
        NavigationStack {
            PreviewEnvironment {
                StationScreen(station: ModelStubs.kingsCrossStation)
            }
            .environment(AppRouter())
        }
    }
#endif
