import SwiftUI

public struct PrimaryActionButtonStyle: ButtonStyle {

    @Environment(\.isEnabled) var isEnabled

    public func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .font(.subheadline.weight(.semibold))
            .withDefaultMaxWidth()
            .frame(minHeight: 48)
            .padding(.horizontal, 18)
            .background(
                Color.accentColor.opacity(isEnabled ? 0.12 : 0.06),
                in: Capsule()
            )
            .overlay {
                Capsule()
                    .strokeBorder(Color.accentColor.opacity(isEnabled ? 0.18 : 0.08), lineWidth: 1)
            }
            .foregroundStyle(isEnabled ? Color.accentColor : .secondary)
            .opacity(configuration.isPressed ? 0.82 : 1)
            .scaleEffect(configuration.isPressed ? 0.985 : 1)
            .animation(.snappy(duration: 0.15), value: configuration.isPressed)
    }
}

// MARK: PrimaryActionButtonStyle (syntactic sugar)

public extension ButtonStyle where Self == PrimaryActionButtonStyle {
    static var primary: PrimaryActionButtonStyle { PrimaryActionButtonStyle() }
}

private struct WrapperView: View {
    var body: some View {
        Button("Hello World") {}
            .buttonStyle(.primary)
    }
}
#Preview("Primary button") {
    VStack {
        Button("Standard") {}
        Button("Disabled") {}.disabled(true)
    }
    .buttonStyle(.primary)
}
