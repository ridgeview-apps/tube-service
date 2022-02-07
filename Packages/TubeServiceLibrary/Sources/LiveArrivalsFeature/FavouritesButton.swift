import SwiftUI

struct FavouritesButton: View {
    @Binding var isFavourite: Bool
    private(set) var accessibilityId: String = "favourites.button"

    var body: some View {
        Button(action: {
            self.isFavourite.toggle()
        }) {
            Image(systemName: self.isFavourite ? "star.fill" : "star")
                .imageScale(.large)
        }
        .accessibility(identifier: accessibilityId)
    }
}
