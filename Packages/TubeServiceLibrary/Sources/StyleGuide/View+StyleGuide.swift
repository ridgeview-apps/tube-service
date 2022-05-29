import SwiftUI

public extension View {
    
    func roundedBorder(_ color: Color,
                       cornerRadius: CGFloat = 4,
                       lineWidth: CGFloat = 1) -> some View {
        self.cornerRadius(cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(color, lineWidth: lineWidth)
            )
    }
    
    func cardStyle(cornerRadius: CGFloat = 4,
                   backgroundColor: Color = .defaultCellBackground) -> some View {
        modifier(CardStyle(cornerRadius: cornerRadius,
                          backgroundColor: backgroundColor))
    }    
    
    func hiddenSeparatorListRowStyle(backgroundColor: Color = .defaultBackground) -> some View {
        modifier(HiddenSeparatorListRowStyle(backgroundColor: backgroundColor))
    }
}

public struct CardStyle: ViewModifier {
    
    let cornerRadius: CGFloat
    let backgroundColor: Color

    public func body(content: Content) -> some View {
        ZStack {
            backgroundColor
            content
        }
        .cornerRadius(cornerRadius)
        .shadow(color: .primary.opacity(0.14),
                radius: 4,
                x: 0,
                y: 2)
    }
    
}

public struct HiddenSeparatorListRowStyle: ViewModifier {
    
    let backgroundColor: Color
    
    public func body(content: Content) -> some View {
        content
            .listRowSeparator(.hidden)
            .listRowBackground(backgroundColor)
    }
}
