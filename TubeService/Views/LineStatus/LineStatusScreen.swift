import DataStores
import Models
import PresentationViews
import Shared
import SwiftUI

@MainActor
struct LineStatusScreen: View {
    @Environment(LineStatusDataStore.self) var model
    @Environment(AppRouter.self) private var router

    @AppStorage(
        UserDefaults.Keys.userPreferences.rawValue,
        store: AppDependencies.current.userDefaults.value
    )
    private var userPreferences: UserPreferences = .default

    @State private var selectedFilterOption: LineStatusFilterOption = .today
    @State private var selectedDate: Date = .now
    @State private var selectedWeekendDayFilter: WeekendDayFilter = .both

    private var request: LineStatusDataStore.LineStatusRequest {
        selectedFilterOption.toLineStatusRequest(for: selectedDate, weekendDayFilter: selectedWeekendDayFilter)
    }

    var body: some View {
        @Bindable var router = router
        NavigationStack(path: $router.lineStatusPath) {
            statusListView
                .navigationDestination(for: AppRoute.self) { route in
                    destinationScreen(for: route)
                }
        }
        .onSceneDidBecomeActive {
            fetchIfStale()
        }
    }

    @ViewBuilder
    private func destinationScreen(for route: AppRoute) -> some View {
        switch route {
        case .journeyResults:
            EmptyView()
        case .lineStatusDetail(let line, let request):
            LineStatusDetailScreen(line: line, request: request)
        }
    }

    private var statusListView: some View {
        LineStatusListView(
            loadingState: loadingState,
            lines: lines,
            favouriteLineIDs: userPreferences.favouriteLineIDs,
            disruptionCountsByLineID: model.disruptionCountsByLineID,
            refreshDate: refreshDate,
            onSelectLine: { line in router.push(.lineStatusDetail(line: line, request: request)) },
            selectedFilterOption: $selectedFilterOption,
            selectedDate: $selectedDate,
            selectedWeekendDayFilter: $selectedWeekendDayFilter
        )
        .navigationTitle(Text(L10n.lineStatusNavigationTitle))
        .refreshable {
            await model.refresh(for: request, forced: true)
        }
        .withSettingsToolbarButton()
        .onAppear {
            fetchIfStale()
        }
        .onChange(of: lines) {
            refreshSelectedLine()
        }
        .onChange(of: selectedFilterOption) {
            router.lineStatusPath = []
            selectedWeekendDayFilter = .both
            fetchIfStale()
        }
        .onChange(of: selectedDate) {
            fetchIfStale()
        }
        .onChange(of: selectedWeekendDayFilter) {
            fetchIfStale()
        }
        .onCalendarDayChanged {
            selectedFilterOption = .today
            selectedDate = .now
        }
    }

    private var loadingState: LoadingState {
        model.statusResult(for: request)?.fetchState.loadingState ?? .loaded
    }

    private var lines: [Line] {
        (model.statusResult(for: request)?.value ?? []).sortedByStatusSeverity()
    }

    private var refreshDate: Date? {
        model.statusResult(for: request)?.fetchedAt
    }

    private func fetchIfStale() {
        Task { await model.refresh(for: request, forced: false) }
    }

    private func refreshSelectedLine() {
        guard case .lineStatusDetail(let current, let req) = router.lineStatusPath.last,
            let updated = lines.first(where: { $0.id == current.id })
        else { return }
        router.lineStatusPath[router.lineStatusPath.count - 1] = .lineStatusDetail(line: updated, request: req)
    }
}

extension DataFetchState {

    var loadingState: LoadingState {
        switch self {
        case .fetching:
            return .loading
        case .success:
            return .loaded
        case let .failure(error):
            return .failure(errorMessage: error.toUIErrorMessage())
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
