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
    @State private var showingConfirmation = false

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
                    .contentTransition(.symbolEffect(.replace))
                    .imageScale(.large)
            case .large:
                largeStyleLabel
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
        .sensoryFeedback(.success, trigger: isSelected) { oldValue, newValue in
            let wasAdded = !oldValue && newValue
            return wasAdded
        }
        .sensoryFeedback(.warning, trigger: isSelected) { oldValue, newValue in
            let wasRemoved = oldValue && !newValue
            return wasRemoved
        }
        .accessibility(identifier: "acc.id.favourites.button.\(style.rawValue)")
        .applyingStyle(style)
    }

    @ViewBuilder
    private var largeStyleLabel: some View {
        HStack {
            if showingConfirmation {
                Image(systemName: "checkmark.circle.fill")
                    .transition(.scale.combined(with: .opacity))
                Text(.favouritesButtonTitleAdded)
                    .transition(.push(from: .bottom))
            } else if isSelected {
                Image(systemName: "star.fill")
                    .transition(.scale.combined(with: .opacity))
                Text(.favouritesButtonTitleRemove)
                    .transition(.push(from: .bottom))
            } else {
                Image(systemName: "star")
                    .transition(.scale.combined(with: .opacity))
                Text(.favouritesButtonTitleAdd)
                    .transition(.push(from: .top))
            }
        }
        .foregroundStyle(showingConfirmation ? .green : Color.accentColor)
    }

    private func buttonTapped() {
        if isSelected && confirmOnDelete {
            showsConfirmDeleteAlert = true
        } else {
            toggleFavourite()
        }
    }

    private func toggleFavourite() {
        let wasSelected = isSelected

        withAnimation(.snappy(duration: 0.35)) {
            isSelected.toggle()
        }

        if !wasSelected {
            withAnimation(.snappy(duration: 0.35)) {
                showingConfirmation = true
            }

            Task {
                try? await Task.sleep(for: .seconds(1.2))
                withAnimation(.snappy(duration: 0.35)) {
                    showingConfirmation = false
                }
            }
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
