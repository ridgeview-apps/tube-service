import DataStores
import Models
import PresentationViews
import Shared
import SwiftUI

@MainActor
struct LineStatusScreen: View {
    @Environment(LineStatusDataStore.self) var model
    @Environment(AppRouter.self) private var router
    @Environment(\.now) private var now

    @AppStorage(
        UserDefaults.Keys.userPreferences.rawValue,
        store: AppDependencies.current.userDefaults.value
    )
    private var userPreferences: UserPreferences = .default

    @State private var selectedFilterOption: LineStatusFilterOption = .today
    // The environment can't be read while initialising state, so this reads the same clock directly.
    @State private var selectedDate: Date = AppDependencies.current.now()
    @State private var selectedWeekendDayFilter: WeekendDayFilter = .both

    private var request: LineStatusDataStore.LineStatusRequest {
        selectedFilterOption.toLineStatusRequest(
            for: selectedDate,
            weekendDayFilter: selectedWeekendDayFilter,
            now: now()
        )
    }

    var body: some View {
        @Bindable var router = router
        NavigationStack(path: $router.lineStatus.path) {
            statusListView
                .appRouteDestinations()
        }
    }

    private var statusListView: some View {
        LineStatusListView(
            loadingState: loadingState,
            lines: lines,
            favouriteLineIDs: userPreferences.favouriteLineIDs,
            disruptionCountsByLineID: model.disruptionCountsByLineID,
            refreshDate: refreshDate,
            onAction: handleAction,
            selectedFilterOption: $selectedFilterOption,
            selectedDate: $selectedDate,
            selectedWeekendDayFilter: $selectedWeekendDayFilter
        )
        .navigationTitle(Text(L10n.lineStatusNavigationTitle))
        .refreshable {
            await model.refresh(for: request)
        }
        .withSettingsToolbarButton()
        .onAppear {
            refreshIfStale()
        }
        .onSceneDidBecomeActive {
            refreshIfStale()
        }
        .onChange(of: selectedFilterOption) {
            router.popToRoot(on: .lineStatus)
            selectedWeekendDayFilter = .both
            refreshIfStale()
        }
        .onChange(of: selectedDate) {
            refreshIfStale()
        }
        .onChange(of: selectedWeekendDayFilter) {
            refreshIfStale()
        }
        .onCalendarDayChanged {
            selectedFilterOption = .today
            selectedDate = now()
        }
    }

    private var loadingState: LoadingState {
        model.lineStatusData(for: request)?.fetchState.loadingState ?? .loaded
    }

    private var lines: [Line] {
        (model.lineStatusData(for: request)?.value ?? []).sortedByStatusSeverity()
    }

    private var refreshDate: Date? {
        model.lineStatusData(for: request)?.fetchedAt
    }

    private func refreshIfStale() {
        Task { await model.refreshIfStale(for: request) }
    }

    private func handleAction(_ action: LineStatusListView.Action) {
        switch action {
        case .selectLine(let line):
            router.push(.lineStatusDetail(lineID: line.id, request: request))
        case .reorderFavourites(let lineIDs):
            userPreferences.reorderFavouriteLines(lineIDs)
        case .removeFavourites(let lineIDs):
            lineIDs.forEach { userPreferences.removeFavouriteLine($0) }
        }
    }
}

// MARK: - Previews

#if DEBUG
    #Preview {
        PreviewEnvironment {
            LineStatusScreen()
        }
    }
#endif
