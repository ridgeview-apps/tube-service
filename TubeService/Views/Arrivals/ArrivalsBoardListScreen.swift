import DataStores
import Models
import PresentationViews
import SwiftUI

struct ArrivalsBoardListScreen: View {
    let station: Station
    let lineGroup: Station.LineGroup

    @State private var store = ArrivalsBoardStore(
        tflAPI: AppDependencies.current.tflAPI,
        now: { AppDependencies.current.clock.now }
    )

    @AppStorage(
        UserDefaults.Keys.userPreferences.rawValue,
        store: AppDependencies.current.userDefaults.value
    )
    private var userPreferences: UserPreferences = .default

    var body: some View {
        ArrivalsBoardListView(
            boardStates: boardStates,
            lineGroupName: lineGroup.name,
            refreshDate: store.boardData.fetchedAt,
            loadingState: loadingState,
            isFavourite: isFavouriteStation
        )
        .navigationTitle(station.name)
        .toolbar {
            FavouritesButton(style: .small, isSelected: isFavouriteStation)
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
        switch store.boardData.value {
        case .predictions(let predictions):
            return predictions.toPlatformBoardStates()
        case .departures(let lineID, let items):
            return items.toPlatformBoardStates(forLineID: lineID)
        case nil:
            return []
        }
    }

    private var loadingState: LoadingState {
        store.boardData.fetchState.loadingState
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
}


// MARK: - Previews

import ModelStubs

#if DEBUG
    #Preview {
        NavigationStack {
            PreviewEnvironment {
                ArrivalsBoardListScreen(
                    station: ModelStubs.stations.first!,
                    lineGroup: ModelStubs.stations.first!.lineGroups[0]
                )
            }
        }
    }
#endif
