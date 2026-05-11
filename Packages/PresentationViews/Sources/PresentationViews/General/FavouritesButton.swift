import SwiftUI

public struct FavouritesButton: View {
    public enum Style: String {
        case small
        case large
    }
    
    @Binding public var isSelected: Bool
    public let style: Style
    
    private let confirmOnDelete: Bool
    
    @State private var showsConfirmDeleteAlert = false
    
    public init(
        style: Style,
        isSelected: Binding<Bool>,
        confirmOnDelete: Bool = true
    ) {
        self.style = style
        self._isSelected = isSelected
        self.confirmOnDelete = confirmOnDelete
    }

    public var body: some View {
        Button {
            buttonTapped()
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
        .confirmationDialog(
            .favouritesButtonAlertConfirmTitle,
            isPresented: $showsConfirmDeleteAlert,
            titleVisibility: .visible
        ) {
            Button(.globalCancel, role: .cancel) {}
            Button(.globalRemove, role: .destructive) {
                toggleFavourite()
            }
        }
        .accessibility(identifier: "acc.id.favourites.button.\(style.rawValue)")
        .applyingStyle(style)
    }
    
    private func buttonTapped() {
        if isSelected && confirmOnDelete {
            showsConfirmDeleteAlert = true
        } else {
            toggleFavourite()
        }
    }
    
    private func toggleFavourite() {
        withAnimation {
            isSelected.toggle()
        }
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
            FavouritesButton(
                style: style,
                isSelected: $isSelected
            )
        }
    }
    
    return Group {
        WrapperView(style: .small)
        WrapperView(style: .large)
    }
}
