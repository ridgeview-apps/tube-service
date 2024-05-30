import SwiftUI

public struct FavouritesButton: View {
    public enum Style: String {
        case small
        case large
    }
    
    @Binding public var isSelected: Bool
    public let style: Style
    
    public init(style: Style,
                isSelected: Binding<Bool>) {
        self.style = style
        self._isSelected = isSelected
    }

    public var body: some View {
        Button {
            withAnimation {
                isSelected.toggle()
            }
        } label: {
            switch style {
            case .small:
                Image(systemName: isSelected ? "star.fill" : "star")
                    .imageScale(.large)
            case .large:
                HStack {
                    Image(systemName: isSelected ? "minus.circle" : "plus.circle")
                    if isSelected {
                        Text(.favouritesButtonTitleRemove)
                    } else {
                        Text(.favouritesButtonTitleAdd)
                    }
                }
            }
        }
        .accessibility(identifier: "acc.id.favourites.button.\(style.rawValue)")
        .applyingStyle(style)
    }
}

private extension View {

    @ViewBuilder func applyingStyle(_ style: FavouritesButton.Style) -> some View {
        switch style {
        case .small:
            self.buttonStyle(.borderless)
        case .large:
            self.buttonStyle(.primary)
        }
    }
}

#Preview {
    struct WrapperView: View {
        @State var isSelected = false
        let style: FavouritesButton.Style
        
        var body: some View {
            FavouritesButton(style: style, isSelected: $isSelected)
        }
    }
    
    return Group {
        WrapperView(style: .small)
        WrapperView(style: .large)
    }
}
