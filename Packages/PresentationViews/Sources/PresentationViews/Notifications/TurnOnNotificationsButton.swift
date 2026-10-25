import SwiftUI

/// The "Turn on notifications" call to action, shared by onboarding and adding a single line.
/// Use `turnOnNotificationsBar(isShown:isDisabled:action:)` so it's always pinned to the bottom of the screen.
struct TurnOnNotificationsButton: View {

    let isDisabled: Bool
    let action: () -> Void

    @State private var bellBounce = false

    var body: some View {
        Button(action: action) {
            Label {
                Text(.notificationsLineConfigTurnOnButton)
            } icon: {
                Image(systemName: "bell.and.waves.left.and.right.fill")
                    .symbolEffect(.bounce, value: bellBounce)
            }
            .labelStyle(.titleAndIcon)
            .font(.body)
            .fontWeight(.semibold)
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
        .controlSize(.large)
        .disabled(isDisabled)
        .padding(.horizontal, 20)
        .padding(.bottom, 8)
        .onAppear { bellBounce = true }
    }
}

private struct TurnOnNotificationsBarModifier: ViewModifier {

    let isShown: Bool
    let isDisabled: Bool
    let action: () -> Void

    func body(content: Content) -> some View {
        if #available(iOS 26, *) {
            // Extends the scroll edge effect behind the button, matching the navigation bar.
            content.safeAreaBar(edge: .bottom) { bar }
        } else {
            content.safeAreaInset(edge: .bottom) {
                bar.background(.regularMaterial)
            }
        }
    }

    @ViewBuilder
    private var bar: some View {
        if isShown {
            TurnOnNotificationsButton(isDisabled: isDisabled, action: action)
        }
    }
}

extension View {

    /// Pins `TurnOnNotificationsButton` below the view.
    /// - Parameter isShown: Whether the screen offers the button at all; editing existing lines saves from the toolbar.
    func turnOnNotificationsBar(
        isShown: Bool = true,
        isDisabled: Bool,
        action: @escaping () -> Void
    ) -> some View {
        modifier(TurnOnNotificationsBarModifier(isShown: isShown, isDisabled: isDisabled, action: action))
    }
}


// MARK: - Previews

#Preview {
    List(0..<30) { index in
        Text(verbatim: "Row \(index)")
    }
    .turnOnNotificationsBar(isDisabled: false) {}
}
