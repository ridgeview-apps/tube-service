import SwiftUI

public struct PrimaryActionButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) var isEnabled
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .padding(12)
            .withDefaultMaxWidth()
            .background(.blue.opacity(isEnabled ? 1 : 0.4))
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .opacity(configuration.isPressed ? 0.5 : 1)
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
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
