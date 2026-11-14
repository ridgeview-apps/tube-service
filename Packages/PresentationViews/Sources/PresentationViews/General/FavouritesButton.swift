import Shared
import SwiftUI

public struct FavouritesButton: View {
    public enum Style: String {
        case small
        case large
    }

    /// Named in the copy, as both screens use the same ★ and the Station screen pushes the line screen
    public enum Kind {
        case station
        case line
    }

    @Binding public var isSelected: Bool
    public let style: Style
    public let kind: Kind

    private let confirmOnDelete: Bool

    @State private var showsConfirmDeleteAlert = false
    @State private var showingConfirmation = false

    public init(
        _ kind: Kind,
        style: Style,
        isSelected: Binding<Bool>,
        confirmOnDelete: Bool = true
    ) {
        self.style = style
        self.kind = kind
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
                    .accessibilityLabel(Text(isSelected ? kind.removeTitle : kind.addTitle))
            case .large:
                largeStyleLabel
            }
        }
        .confirmationDialog(
            kind.removeConfirmTitle,
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
        .accessibilityIdentifier(AccessibilityID.FavouritesButton.button(style.rawValue))
        .applyingStyle(style, tint: largeStyleTint)
    }

    // Red while it would remove a favourite, matching the other destructive Remove buttons
    private var largeStyleTint: Color {
        if showingConfirmation { return .green }
        return isSelected ? .red : .accentColor
    }

    @ViewBuilder
    private var largeStyleLabel: some View {
        HStack {
            if showingConfirmation {
                Image(systemName: "checkmark.circle.fill")
                    .transition(.scale.combined(with: .opacity))
                Text(kind.addedTitle)
                    .transition(.push(from: .bottom))
            } else if isSelected {
                Image(systemName: "star.fill")
                    .transition(.scale.combined(with: .opacity))
                Text(kind.removeTitle)
                    .transition(.push(from: .bottom))
            } else {
                Image(systemName: "star")
                    .transition(.scale.combined(with: .opacity))
                Text(kind.addTitle)
                    .transition(.push(from: .top))
            }
        }
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

private extension FavouritesButton.Kind {

    var addTitle: LocalizedStringResource {
        switch self {
        case .station: .favouritesButtonStationAdd
        case .line: .favouritesButtonLineAdd
        }
    }

    var addedTitle: LocalizedStringResource {
        switch self {
        case .station: .favouritesButtonStationAdded
        case .line: .favouritesButtonLineAdded
        }
    }

    var removeTitle: LocalizedStringResource {
        switch self {
        case .station: .favouritesButtonStationRemove
        case .line: .favouritesButtonLineRemove
        }
    }

    var removeConfirmTitle: LocalizedStringResource {
        switch self {
        case .station: .favouritesButtonStationRemoveConfirm
        case .line: .favouritesButtonLineRemoveConfirm
        }
    }
}

private extension View {

    @ViewBuilder func applyingStyle(_ style: FavouritesButton.Style, tint: Color) -> some View {
        switch style {
        case .small:
            self.buttonStyle(.borderless)
        case .large:
            self.buttonStyle(.primary(tint: tint))
        }
    }
}

#Preview {
    struct WrapperView: View {
        @State var isSelected = false
        let style: FavouritesButton.Style

        var body: some View {
            FavouritesButton(
                .station,
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
