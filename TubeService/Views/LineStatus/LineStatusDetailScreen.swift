import DataStores
import Models
import PresentationViews
import Shared
import SwiftUI

@MainActor
struct LineStatusDetailScreen: View {
    
    @Environment(UserPreferencesDataStore.self) var userPreferences
    @Environment(LineStatusDataStore.self) var model
    
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
            refreshDate: refreshDate
        )
            .navigationTitle(line.id.name)
            .toolbar {
                FavouritesButton(style: .small, isSelected: isFavouriteLine(for: line.id))
            }
    }
    
    private func isFavouriteLine(for lineID: TrainLineID) -> Binding<Bool> {
        .init {
            userPreferences.isFavourite(lineID: lineID)
        } set: { isFavourite in
            if isFavourite {
                userPreferences.add(favouriteLineID: lineID)
            } else {
                userPreferences.remove(favouriteLineID: lineID)
            }
        }
    }
}
