import DataStores
import Models
import PresentationViews
import Shared
import SwiftUI

struct ArrivalsBoardListScreen: View {
    let stationName: String
    let lineGroup: Station.LineGroup
    
    @State private var loadingState: LoadingState = .loaded
    @State private var loadedBoardID: Station.LineGroup.ID?
    @State private var boardStates: [ArrivalsBoardState] = []
    @State private var refreshDate: Date?
    @State private var autoRefreshTimer: ObservableTimer?
    
    private let timerSecondsInterval = 20.0
        
    @Environment(\.transportAPI) var transportAPI

    @AppStorage(UserDefaults.Keys.userPreferences.rawValue, store: .standard)
    private var userPreferences: UserPreferences = .default
    
    var body: some View {
        ArrivalsBoardListView(boardStates: boardStates,
                              lineGroupName: lineGroup.name,
                              refreshDate: refreshDate,
                              loadingState: loadingState,
                              isFavourite: isFavouriteLineGroup)
        .navigationTitle(stationName)
        .toolbar {
            FavouritesButton(style: .small, isSelected: isFavouriteLineGroup)
        }
        .refreshable {
            refreshData(startNewTimer: true)
        }
        .onAppear {
            refreshData(startNewTimer: true)
        }
        .onDisappear {
            autoRefreshTimer?.invalidate()
        }
        .onChange(of: autoRefreshTimer?.firedAt) {
            refreshData(startNewTimer: false)
        }

    }
    
    private func refreshData(startNewTimer: Bool) {
        guard loadingState != .loading else {
            return
        }
        
        let boardIDHasChanged = loadedBoardID != lineGroup.id // e.g. split view selection
        if boardIDHasChanged {
            boardStates = []
        }
        
        loadingState = .loading
        
        Task {
            do {
                boardStates = try await fetchBoards()
                refreshDate = .now
                loadedBoardID = lineGroup.id
                loadingState = .loaded
            } catch {
                loadingState = .failure(errorMessage: error.toUIErrorMessage())
            }
            
            if startNewTimer {
                autoRefreshTimer?.invalidate()
                autoRefreshTimer = .repeating(every: timerSecondsInterval)
            }
        }
    }
    
    private func fetchBoards() async throws -> [ArrivalsBoardState] {
        switch lineGroup.arrivalsDataType {
        case let .arrivalDepartures(lineIDs):
            guard let lineID = lineIDs.first else { return [] } // ArrivalDepartures are only for a single line
            return try await transportAPI.fetchArrivalDepartures(forLineGroup: lineGroup)
                                         .decodedModel
                                         .removingDuplicates()
                                         .filter { $0.scheduledTimeOfDeparture != nil }
                                         .toPlatformBoardStates(forLineID: lineID)
        case .arrivalPredictions:
            return try await transportAPI.fetchArrivalPredictions(forLineGroup: lineGroup)
                                         .decodedModel
                                         .toPlatformBoardStates()
        }
    }
    
    private var isFavouriteLineGroup: Binding<Bool> {
        .init {
            userPreferences.containsFavouriteLineGroup(lineGroup.id)
        } set: { isFavourite in
            if isFavourite {
                userPreferences.addFavouriteLineGroup(lineGroup.id)
            } else {
                userPreferences.removeFavouriteLineGroup(lineGroup.id)
            }
        }
    }    
}


// MARK: - Previews

import ModelStubs

#if DEBUG
struct ArrivalsBoardListScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ArrivalsBoardListScreen(stationName: ModelStubs.stations.first!.name,
                                    lineGroup: ModelStubs.stations.first!.lineGroups[0])
            .withStubbedEnvironment()
            
        }
    }
}
#endif
