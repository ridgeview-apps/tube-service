import SwiftUI

public struct FavouritesButton: View {
    enum Style {
        case barButton
        case full
    }
    
    @Binding public var isSelected: Bool
    public var accessibilityID: String
    
    public init(isSelected: Binding<Bool>,
                accessibilityID: String = "favourites.button") {
        self._isSelected = isSelected
        self.accessibilityID = accessibilityID
    }

    public var body: some View {
        Button {
            isSelected.toggle()
        } label: {
            Image(systemName: isSelected ? "star.fill" : "star")
                .imageScale(.large)
        }
        .accessibility(identifier: accessibilityID)
    }
}

#Preview {
    struct WrapperView: View {
        @State var isSelected = false
        
        var body: some View {
            FavouritesButton(isSelected: $isSelected)
        }
    }
    
    return Group {
        WrapperView()
    }
}
