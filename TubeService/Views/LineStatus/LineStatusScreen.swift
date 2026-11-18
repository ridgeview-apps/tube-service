import DataStores
import Models
import PresentationViews
import Shared
import SwiftUI

@MainActor
struct LineStatusScreen: View {
    @Environment(LineStatusDataStore.self) var model
    @Environment(Navigator.self) private var navigator
    @Environment(\.clock) private var clock

    @AppStorage(
        UserDefaults.Keys.userPreferences.rawValue,
        store: AppDependencies.current.userDefaults.value
    )
    private var userPreferences: UserPreferences = .default

    @State private var selectedFilterOption: LineStatusFilterOption = .today
    // The environment can't be read while initialising state, so this reads the same clock directly.
    @State private var selectedDate: Date = AppDependencies.current.clock.now
    @State private var selectedWeekendDayFilter: WeekendDayFilter = .both

    private var request: LineStatusDataStore.LineStatusRequest {
        selectedFilterOption.toLineStatusRequest(
            for: selectedDate,
            weekendDayFilter: selectedWeekendDayFilter,
            now: clock.now
        )
    }

    var body: some View {
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
        .onAppear {
            refreshIfStale()
        }
        .onSceneDidBecomeActive {
            refreshIfStale()
        }
        .onChange(of: selectedFilterOption) {
            navigator.popToRoot()
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
            selectedDate = clock.now
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
            navigator.push(.lineStatus(.detail(lineID: line.id, request: request)))
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
        PreviewEnvironment(withNavigationHost: true) {
            LineStatusScreen()
        }
    }
#endif
