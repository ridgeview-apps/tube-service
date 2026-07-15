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

    @State private var isAnimating = false

    func body(content: Content) -> some View {
        if #available(iOS 17.0, *) {
            content
                .symbolEffect(.pulse, options: .repeating, value: isAnimating)
                .onAppear {
                    isAnimating = true
                }
        } else {
            content
        }
    }
}

private struct BounceOnceSymbolEffectModifier: ViewModifier {

    @State private var isAnimating = false

    func body(content: Content) -> some View {
        if #available(iOS 18.0, *) {
            content
                .symbolEffect(.bounce.wholeSymbol, value: isAnimating)
                .onAppear {
                    withAnimation {
                        isAnimating = true
                    }
                }
        } else {
            content
        }
    }
}
