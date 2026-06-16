import DataStores
import Models
import PresentationViews
import Shared
import SwiftUI

@MainActor
struct LineStatusDetailScreen: View {

    @Environment(PurchaseStore.self) var purchases
    @Environment(LineStatusDataStore.self) var model
    @Environment(\.showSheet) var showSheet
    @Environment(\.openURL) var openURL

    @AppStorage(
        UserDefaults.Keys.userPreferences.rawValue,
        store: AppDependencies.current.userDefaults.value
    )
    private var userPreferences: UserPreferences = .default

    @State private var isShowingStatusHistory = false

    let line: Line
    let request: LineStatusDataStore.LineStatusRequest


    private var loadingState: LoadingState {
        return model.statusResult(for: .live)?.fetchState.loadingState ?? .loaded
    }

    private var refreshDate: Date? {
        return model.statusResult(for: .live)?.fetchedAt
    }

    private var statusHistoryAccess: LineStatusHistoryButton.Access {
        purchases.hasTubeServicePlus ? .unlocked : .locked
    }

    private var statusContext: LineStatusDetailView.StatusContext {
        switch request {
        case .live: .live
        case .planned: .planned
        }
    }

    private var historyOperationalDate: Date? {
        switch request {
        case .live: return nil
        case .planned(let interval): return interval.start
        }
    }

    var body: some View {
        LineStatusDetailView(
            line: line,
            isFavourite: isFavouriteLine(for: line.id),
            loadingState: loadingState,
            refreshDate: refreshDate,
            statusHistoryAccess: statusHistoryAccess,
            statusContext: statusContext,
            onAction: handleDetailViewAction
        )
        .navigationTitle(line.id.name)
        .navigationDestination(isPresented: $isShowingStatusHistory) {
            LineStatusHistoryScreen(lineID: line.id, operationalDate: historyOperationalDate)
        }
        .toolbar {
            FavouritesButton(style: .small, isSelected: isFavouriteLine(for: line.id))
        }

    }

    private func handleDetailViewAction(_ action: LineStatusDetailView.Action) {
        switch action {
        case .linkTapped(let link):
            openURL(link.url)
        case .statusHistoryTapped:
            isShowingStatusHistory = true
        }
    }

    private func isFavouriteLine(for lineID: TrainLineID) -> Binding<Bool> {
        .init {
            userPreferences.containsFavouriteLine(lineID)
        } set: { isFavourite in
            if isFavourite {
                userPreferences.addFavouriteLine(lineID)
            } else {
                userPreferences.removeFavouriteLine(lineID)
            }
        }
    }
}
