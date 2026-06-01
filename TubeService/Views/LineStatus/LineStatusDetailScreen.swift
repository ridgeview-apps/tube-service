import DataStores
import Models
import PresentationViews
import Shared
import SwiftUI

@MainActor
struct LineStatusDetailScreen: View {
    
    @Environment(LineStatusDataStore.self) var model
    @Environment(\.showSheet) var showSheet
    @Environment(\.openURL) var openURL
    
    @AppStorage(
        UserDefaults.Keys.userPreferences.rawValue,
        store: AppDependencies.current.userDefaults.value
    )
    private var userPreferences: UserPreferences = .default
    
    let line: Line
    let fetchType: LineStatusDataStore.FetchType
    
    
    private var loadingState: LoadingState {
        return model.fetchedData(for: .today)?.fetchState.loadingState ?? .loaded
    }
    
    private var refreshDate: Date? {
        return model.fetchedData(for: .today)?.fetchedAt
    }
    
    var body: some View {
        LineStatusDetailView(
            line: line,
            isFavourite: isFavouriteLine(for: line.id),
            loadingState: loadingState,
            refreshDate: refreshDate,
            onAction: handleDetailViewAction
        )
        .navigationTitle(line.id.name)
        .toolbar {
            FavouritesButton(style: .small, isSelected: isFavouriteLine(for: line.id))
        }

    }
    
    private func handleDetailViewAction(_ action: LineStatusDetailView.Action) {
        switch action {
        case .linkTapped(let link):
            openURL(link.url)
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
