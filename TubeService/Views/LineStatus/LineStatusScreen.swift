import DataStores
import Models
import PresentationViews
import Shared
import SwiftUI

@MainActor
struct LineStatusScreen: View {
    @Environment(LineStatusDataStore.self) var model

    @AppStorage(
        UserDefaults.Keys.userPreferences.rawValue,
        store: AppDependencies.current.userDefaults.value
    )
    private var userPreferences: UserPreferences = .default

    @State private var selectedLine: Line?
    @State private var selectedFilterOption: LineStatusFilterOption = .today
    @State private var selectedDate: Date = .now

    private var fetchType: LineStatusDataStore.FetchType {
        selectedFilterOption.toFetchType(for: selectedDate)
    }

    var body: some View {
        NavigationStack {
            statusListView
                .navigationDestination(item: $selectedLine) { line in
                    LineStatusDetailScreen(line: line, fetchType: fetchType)
                }
        }
        .onSceneDidBecomeActive {
            fetchIfStale()
        }
    }

    private var statusListView: some View {
        LineStatusListView(
            loadingState: loadingState,
            lines: lines,
            favouriteLineIDs: userPreferences.favouriteLineIDs,
            earlierDisruptedLineIDs: model.earlierDisruptedLineIDs,
            refreshDate: refreshDate,
            selectedLine: $selectedLine,
            selectedFilterOption: $selectedFilterOption,
            selectedDate: $selectedDate
        )
        .navigationTitle(Text(L10n.lineStatusNavigationTitle))
        .refreshable {
            await model.refresh(for: fetchType, ignoringCache: true)
        }
        .withSettingsToolbarButton()
        .onAppear {
            fetchIfStale()
        }
        .onChange(of: lines) {
            refreshSelectedLine()
        }
        .onChange(of: selectedFilterOption) {
            selectedLine = nil
            fetchIfStale()
        }
        .onChange(of: selectedDate) {
            fetchIfStale()
        }
        .onCalendarDayChanged {
            selectedFilterOption = .today
            selectedDate = .now
        }
    }

    private var loadingState: LoadingState {
        model.result(for: fetchType)?.fetchState.loadingState ?? .loaded
    }

    private var lines: [Line] {
        (model.result(for: fetchType)?.value ?? []).sortedByStatusSeverity()
    }

    private var refreshDate: Date? {
        model.result(for: fetchType)?.fetchedAt
    }

    private func fetchIfStale() {
        Task { await model.refresh(for: fetchType, ignoringCache: false) }
    }

    private func refreshSelectedLine() {
        if let selectedLine {
            self.selectedLine = lines.first { $0.id == selectedLine.id }
        }
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
