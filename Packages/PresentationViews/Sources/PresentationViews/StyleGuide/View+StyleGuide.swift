import SwiftUI

public typealias TextShadowSettings = (color: Color, radius: CGFloat, x: CGFloat, y: CGFloat)

public extension View {

    func roundedBorder(
        _ color: Color,
        cornerRadius: CGFloat = 12,
        lineWidth: CGFloat = 1
    ) -> some View {
        self.clipShape(.rect(cornerRadius: cornerRadius))
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(color, lineWidth: lineWidth)
            )
    }

    func cardStyle(
        cornerRadius: CGFloat = 12,
        backgroundColor: Color = .defaultCellBackground,
        borderColor: Color = .clear,
        borderWidth: CGFloat = 0.5
    ) -> some View {
        self.modifier(
            CardStyle(
                cornerRadius: cornerRadius,
                backgroundColor: backgroundColor,
                borderColor: borderColor,
                borderWidth: borderWidth
            )
        )
    }

    func dashedCardStyle(
        cornerRadius: CGFloat = 12,
        color: Color = .secondary.opacity(0.5),
        lineWidth: CGFloat = 1.5,
        dash: [CGFloat] = [6, 4]
    ) -> some View {
        self
            .clipShape(.rect(cornerRadius: cornerRadius))
            .overlay {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .strokeBorder(
                        style: StrokeStyle(lineWidth: lineWidth, dash: dash),
                        antialiased: true
                    )
                    .foregroundStyle(color)
            }
    }

    func secondarySectionHeaderStyle(textCase: Text.Case? = nil) -> some View {
        self
            .font(.footnote.weight(.semibold))
            .foregroundStyle(.secondary)
            .textCase(textCase)
    }

}

private struct CardStyle: ViewModifier {
    var cornerRadius: CGFloat = 12
    var backgroundColor: Color = .defaultCellBackground
    var borderColor: Color = .clear
    var borderWidth: CGFloat = 0.5

    @Environment(\.colorScheme) var colorScheme

    public func body(content: Content) -> some View {
        content
            .background(backgroundColor)
            .clipShape(.rect(cornerRadius: cornerRadius))
            .shadow(
                color: .black.opacity(colorScheme == .dark ? 0 : 0.12),
                radius: 4,
                x: 0,
                y: 2
            )
            .overlay {
                if borderColor != .clear {
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(borderColor, lineWidth: borderWidth)
                }
            }
    }
}
