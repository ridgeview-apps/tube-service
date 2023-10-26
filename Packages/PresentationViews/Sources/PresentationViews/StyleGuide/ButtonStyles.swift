import SwiftUI

public struct PrimaryActionButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) var isEnabled
    @ScaledMetric private var dynamicTextScale: CGFloat = 1
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .frame(maxWidth: 600, minHeight: 44 * dynamicTextScale)
            .background(.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .saturation(isEnabled ? 1 : 0)
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
    }.buttonStyle(.primary)
}
