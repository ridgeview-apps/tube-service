import DataStores
import Models
import PresentationViews
import Shared
import SwiftUI

@MainActor
struct LineStatusScreen: View {
    @Environment(LineStatusDataStore.self) var model
    @Environment(UserPreferencesDataStore.self) var userPreferences
    
    @State private var selectedLine: Line?
    @State private var selectedFilterOption: LineStatusFilterOption = .today
    @State private var selectedDate: Date = .now
    
    var body: some View {
        NavigationSplitView {
            statusListView
        } detail: {
            statusDetailView
        }
        .onSceneDidBecomeActive {
            fetchLineStatusesIfStale(for: selectedFilterOption)
        }
    }
    
    private var statusListView: some View {
        LineStatusListView(loadingState: loadingState,
                           lines: lines,
                           favouriteLineIDs: userPreferences.favouriteLineIDs,
                           refreshDate: refreshDate,
                           selectedLine: $selectedLine,
                           selectedFilterOption: $selectedFilterOption,
                           selectedDate: $selectedDate)
        .navigationTitle("line.status.navigation.title")
        .refreshable {
            refreshDataForCurrentFilterOption()
        }
        .withSettingsToolbarButton()
        .onAppear {
            fetchLineStatusesIfStale(for: selectedFilterOption)
        }
        .onChange(of: lines) {
            refreshSelectedLine()
        }
        .onChange(of: selectedFilterOption) { _, newValue in
            selectedLine = nil
            fetchLineStatusesIfStale(for: newValue)
        }
        .onChange(of: selectedDate) {
            fetchLineStatusesIfStale(for: selectedFilterOption)
        }
        .onReceive(NotificationCenter.default.publisher(for: .NSCalendarDayChanged)) { _ in
            selectedFilterOption = .today
            selectedDate = .now
        }
    }
    
    private var statusDetailView: some View {
        NavigationStack {
            if let selectedLine {
                LineStatusDetailScreen(line: selectedLine)
            } else {
                if selectedFilterOption == .today || lines.hasDisruptions {
                    Text("line.status.no.selection")
                }
            }
        }
    }
    
    private var loadingState: LoadingState {
        return model.fetchedData(for: currentFetchType)?.fetchState.loadingState ?? .loaded
    }
    
    private var lines: [Line] {
        return (model.fetchedData(for: currentFetchType)?.lines ?? []).sortedByStatusSeverity()
    }
    
    private var refreshDate: Date? {
        return model.fetchedData(for: currentFetchType)?.fetchedAt
    }
    
    private func fetchLineStatusesIfStale(for filterOption: LineStatusFilterOption) {
        Task {
            await model.refreshLineStatusesIfStale(for: currentFetchType)
        }
    }
    
    private func refreshSelectedLine() {
        if let selectedLine {
            self.selectedLine = lines.first { $0.id == selectedLine .id }
        }
    }
    
    private func refreshDataForCurrentFilterOption() {
        Task {
            await model.refreshLineStatuses(for: currentFetchType)
        }
    }
    
    private var currentFetchType: LineStatusDataStore.FetchType {
        switch selectedFilterOption {
        case .today:
            return .today
        case .tomorrow:
            guard let startDate = Calendar.london.startOfTomorrow(),
                  let endDate = Calendar.london.startOfNextDay(after: startDate) else {
                assertionFailure("Failed to calculate tomorrow's date range (falling back to today instead)")
                return .today
            }
            return .range(.init(start: startDate, end: endDate))
        case .thisWeekend:
            guard let weekendDateRange = Calendar.london.thisOrNextWeekendDateInterval(for: .now) else {
                assertionFailure("Failed to calculate next weekend dates (falling back to today instead)")
                return .today
            }
            return .range(weekendDateRange)
        case .other:
            if Calendar.london.isDateInToday(selectedDate) {
                return .today
            } else {
                let startDate = selectedDate
                guard let endDate = Calendar.london.startOfNextDay(after: selectedDate) else {
                    assertionFailure("Failed to calculate next day - falling back to today instead")
                    return .today
                }
                return .range(.init(start: startDate, end: endDate))
            }
        }
    }
}

private extension DataFetchState {
    
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
struct LineStatusScreen_Previews: PreviewProvider {
    static var previews: some View {
        LineStatusScreen()
            .withStubbedEnvironment()
    }
}
#endif
