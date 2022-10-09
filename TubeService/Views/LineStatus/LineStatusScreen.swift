import Models
import PresentationViews
import Shared
import SwiftUI

struct LineStatusScreen: View {
    @EnvironmentObject var model: LineStatusModel
    
    @State private var selectedLine: Line?
    @State private var selectedFilterOption: LineStatusFilterOption = .today
    @State private var selectedFutureDate: Date?
    
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
                           refreshDate: refreshDate,
                           selectedLine: $selectedLine,
                           selectedFilterOption: $selectedFilterOption,
                           selectedFutureDate: $selectedFutureDate)
            .navigationTitle("line.status.navigation.title")
            .refreshable {
                refreshDataForCurrentFilterOption()
            }
            .withSettingsToolbarButton()
            .onAppear {
                fetchLineStatusesIfStale(for: selectedFilterOption)
            }
            .onChange(of: selectedFilterOption) { newValue in
                selectedLine = nil
                fetchLineStatusesIfStale(for: newValue)
            }
            .onChange(of: selectedFutureDate) { _ in
                fetchLineStatusesIfStale(for: selectedFilterOption)
            }
            .onReceive(NotificationCenter.default.publisher(for: .NSCalendarDayChanged)) { _ in
                selectedFilterOption = .today
                selectedFutureDate = nil
            }
    }
    
    private var statusDetailView: some View {
        NavigationStack {
            if let selectedLine {
                LineStatusDetailView(line: selectedLine)
                    .navigationTitle(selectedLine.id.name)
            } else {
                Text("line.status.no.selection")
            }
        }
    }
    
    private var loadingState: LoadingState {
        guard let currentFetchType else { return .loaded }
        return model.fetchedData(for: currentFetchType)?.fetchState.loadingState ?? .loaded
    }
    
    private var lines: [Line] {
        guard let currentFetchType else { return [] }
        return model.fetchedData(for: currentFetchType)?.lines ?? []
    }
    
    private var refreshDate: Date? {
        guard let currentFetchType else { return nil }
        return model.fetchedData(for: currentFetchType)?.fetchedAt
    }
    
    private func fetchLineStatusesIfStale(for filterOption: LineStatusFilterOption) {
        Task {
            guard let currentFetchType else { return }
            await model.refreshLineStatusesIfStale(for: currentFetchType)
        }
    }
    
    private func refreshDataForCurrentFilterOption() {
        Task {
            guard let currentFetchType else { return }
            await model.refreshLineStatuses(for: currentFetchType)
        }
    }
    
    private var currentFetchType: LineStatusModel.FetchType? {
        switch selectedFilterOption {
        case .today:
            return .today
        case .thisWeekend:
            guard let dateInterval = Calendar.london.thisOrNextWeekendDateInterval(for: .now) else {
                assertionFailure("Failed to calculate next weekend dates (falling back to today instead)")
                return .today
            }
            return .range(dateInterval)
        case .future:
            guard let selectedFutureDate,
                  !Calendar.london.isDateInToday(selectedFutureDate),
                  let nextDay = Calendar.london.startOfNextDay(after: selectedFutureDate) else {
                return nil
            }
            let dateInterval = DateInterval(start: selectedFutureDate, end: nextDay)
            return .range(dateInterval)
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
