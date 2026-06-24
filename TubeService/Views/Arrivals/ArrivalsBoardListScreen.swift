import DataStores
import Models
import PresentationViews
import SwiftUI

struct ArrivalsBoardListScreen: View {
    let stationName: String
    let lineGroup: Station.LineGroup

    @State private var store = ArrivalsBoardStore(tflAPI: AppDependencies.current.tflAPI)

    @AppStorage(
        UserDefaults.Keys.userPreferences.rawValue,
        store: AppDependencies.current.userDefaults.value
    )
    private var userPreferences: UserPreferences = .default

    var body: some View {
        ArrivalsBoardListView(
            boardStates: boardStates,
            lineGroupName: lineGroup.name,
            refreshDate: store.fetchedAt,
            loadingState: loadingState,
            isFavourite: isFavouriteLineGroup
        )
        .navigationTitle(stationName)
        .toolbar {
            FavouritesButton(style: .small, isSelected: isFavouriteLineGroup)
        }
        .refreshable {
            await store.refresh(for: lineGroup)
            store.resetAutoRefreshTimer(for: lineGroup)
        }
        .onAppear {
            store.startAutoRefresh(for: lineGroup)
        }
        .onDisappear {
            store.stopAutoRefresh()
        }
    }

    private var boardStates: [ArrivalsBoardState] {
        switch store.boardData {
        case .predictions(let predictions):
            return predictions.toPlatformBoardStates()
        case .departures(let lineID, let items):
            return items.toPlatformBoardStates(forLineID: lineID)
        case nil:
            return []
        }
    }

    private var loadingState: LoadingState {
        if store.isFetching { return .loading }
        if let error = store.fetchError { return .failure(errorMessage: error.toUIErrorMessage()) }
        return .loaded
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
    #Preview {
        NavigationStack {
            PreviewEnvironment {
                ArrivalsBoardListScreen(
                    stationName: ModelStubs.stations.first!.name,
                    lineGroup: ModelStubs.stations.first!.lineGroups[0]
                )
            }
        }
    }
#endif
