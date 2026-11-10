import SwiftUI

public extension View {

    func pulsatingSymbol() -> some View {
        self.modifier(PulsatingSymbolEffectModifier())
    }

    @ViewBuilder
    func bounceOnceSymbol(isEnabled: Bool = true) -> some View {
        if isEnabled {
            self.modifier(BounceOnceSymbolEffectModifier())
        } else {
            self
        }
    }
}

private struct PulsatingSymbolEffectModifier: ViewModifier {

    @Environment(\.pausesRepeatingAnimations) private var pausesRepeatingAnimations
    @State private var isAnimating = false

    func body(content: Content) -> some View {
        content
            .symbolEffect(.pulse, options: .repeating, value: isAnimating)
            .onAppear {
                isAnimating = !pausesRepeatingAnimations
            }
    }
}

private struct BounceOnceSymbolEffectModifier: ViewModifier {

    @State private var isAnimating = false

    func body(content: Content) -> some View {
        content
            .symbolEffect(.bounce.wholeSymbol, value: isAnimating)
            .onAppear {
                withAnimation {
                    isAnimating = true
                }
            }
    }
}
