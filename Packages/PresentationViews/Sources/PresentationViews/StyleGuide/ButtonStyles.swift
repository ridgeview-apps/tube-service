import SwiftUI

public struct PrimaryActionButtonStyle: ButtonStyle {
    private static let accentBlue = Color(red: 0.13, green: 0.47, blue: 0.85)

    @Environment(\.isEnabled) var isEnabled

    public func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .font(.body.weight(.medium))
            .padding(.vertical, 14)
            .padding(.horizontal, 20)
            .withDefaultMaxWidth()
            .background(isEnabled ? Self.accentBlue : Color.gray.opacity(0.3))
            .foregroundStyle(isEnabled ? .white : .secondary)
            .clipShape(.rect(cornerRadius: 12))
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
