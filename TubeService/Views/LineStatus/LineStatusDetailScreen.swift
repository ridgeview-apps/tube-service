import DataStores
import Models
import PresentationViews
import Shared
import SwiftUI

@MainActor
struct LineStatusDetailScreen: View {
    
    @Environment(UserPreferencesDataStore.self) var userPreferences: UserPreferencesDataStore
    
    let line: Line
    
    var body: some View {
        LineStatusDetailView(line: line, isFavourite: isFavouriteLine(for: line.id))
            .navigationTitle(line.id.name)
            .toolbar {
                FavouritesButton(style: .small, isSelected: isFavouriteLine(for: line.id))
            }
    }
    
    private func isFavouriteLine(for lineID: LineID) -> Binding<Bool> {
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
