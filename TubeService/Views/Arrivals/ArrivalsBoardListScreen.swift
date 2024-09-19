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
    @State private var autoRefreshEnabled = false
        
    @Environment(\.transportAPI) var transportAPI

    @AppStorage(UserDefaults.Keys.userPreferences.rawValue, store: .standard)
    private var userPreferences: UserPreferences = .default
    
    private let autoRefreshTimer: ObservableTimer = .repeating(every: 20)
    
    
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
        .task {
            refreshData()
        }
        .refreshable {
            refreshData()
        }
        .onChange(of: autoRefreshTimer.firedAt) {
            autoRefresh()
        }
        .onAppear {
            autoRefreshEnabled = true
        }
        .onDisappear {
            autoRefreshEnabled = false
        }
    }
    
    private func autoRefresh() {
        guard autoRefreshEnabled else {
            return
        }
        
        Task {
            refreshData()
        }
    }
    
    private func refreshData() {
        guard loadingState != .loading else {
            return
        }
        
        let boardIDHasChanged = loadedBoardID != lineGroup.id // e.g. split view selection
        if boardIDHasChanged {
            boardStates = []
        }
        
        Task {
            loadingState = .loading
            
            do {
                boardStates = try await fetchBoards()
                refreshDate = .now
                loadedBoardID = lineGroup.id
                loadingState = .loaded
            } catch {
                loadingState = .failure(errorMessage: error.toUIErrorMessage())
            }
        }
    }
    
    nonisolated private func fetchBoards() async throws -> [ArrivalsBoardState] {
        switch lineGroup.arrivalsDataType {
        case let .arrivalDepartures(lineIDs):
            guard let lineID = lineIDs.first else { return [] } // ArrivalDepartures are only for a single line
            return try await transportAPI.fetchArrivalDepartures(forLineGroup: lineGroup)
                                         .decodedModel
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
