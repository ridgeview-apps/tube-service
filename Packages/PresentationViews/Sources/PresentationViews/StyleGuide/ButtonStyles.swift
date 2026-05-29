import SwiftUI

public struct PrimaryActionButtonStyle: ButtonStyle {

    @Environment(\.isEnabled) var isEnabled

    public func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .font(.subheadline.weight(.medium))
            .withDefaultMaxWidth()
            .padding(.vertical, 14)
            .background(.quaternary.opacity(0.5), in: RoundedRectangle(cornerRadius: 10))
            .foregroundStyle(isEnabled ? Color.accentColor : .secondary)
            .opacity(configuration.isPressed ? 0.75 : 1)
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .animation(.snappy(duration: 0.15), value: configuration.isPressed)
    }
}

// MARK: PrimaryActionButtonStyle (syntactic sugar)

public extension ButtonStyle where Self == PrimaryActionButtonStyle {
    static var primary: PrimaryActionButtonStyle { PrimaryActionButtonStyle() }
}

private struct WrapperView: View {
    var body: some View {
        Button("Hello World") { }
            .buttonStyle(.primary)
    }
}
#Preview("Primary button") {
    VStack {
        Button("Standard") { }
        Button("Disabled") { }.disabled(true)
    }
    .buttonStyle(.primary)
}
