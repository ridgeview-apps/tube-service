import SwiftUI

// swiftlint:disable large_tuple
public typealias TextShadowSettings = (color: Color, radius: CGFloat, x: CGFloat, y: CGFloat)
// swiftlint:enable large_tuple

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
                   backgroundColor: Color = .defaultCellBackground,
                   borderColor: Color = .clear,
                   borderWidth: CGFloat = 1) -> some View {
        self.modifier(
            CardStyle(cornerRadius: cornerRadius,
                                backgroundColor: backgroundColor,
                                borderColor: borderColor,
                                borderWidth: borderWidth)
        )
    }
    
    func defaultListRowStyle(edgeInsets: EdgeInsets = .init(top: 0, leading: 16, bottom: 0, trailing: 16),
                             listRowSeparator separatorVisibility: Visibility = .hidden,
                             backgroundColor: Color = .defaultBackground) -> some View {
        self
            .listRowBackground(backgroundColor)
            .listRowInsets(edgeInsets)
            .listRowSeparator(separatorVisibility)
            
    }
    
    func styledTabItem(imageName: String,
                       title: LocalizedStringKey,
                       accessibilityID: String) -> some View {
        tabItem {
            VStack {
                Image(systemName: imageName)
                    .imageScale(.large)
                Text(title)
            }
        }
        .accessibilityIdentifier(accessibilityID)
    }
    
    func defaultScrollContentBackgroundColor() -> some View {
        self
            .scrollContentBackground(.hidden)
            .background(Color.defaultBackground)
    }
    
    func pulsatingSymbol() -> some View {
        self.modifier(PulsatingSymbolEffectModifier())
    }
    
    func withDefaultMaxWidth() -> some View {
        self.frame(maxWidth: 600)
    }
}

public extension EdgeInsets {
    static let zero = EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
}

private struct CardStyle: ViewModifier {
    var cornerRadius: CGFloat = 4
    var backgroundColor: Color = .defaultCellBackground
    var borderColor: Color = .clear
    var borderWidth: CGFloat = 1
    
    @Environment(\.colorScheme) var colorScheme
    
    public func body(content: Content) -> some View {
        content
            .background(backgroundColor)
            .cornerRadius(cornerRadius)
            .shadow(color: .primary.opacity(0.14),
                    radius: colorScheme == .dark ? 0: 4,
                    x: 0,
                    y: colorScheme == .dark ? 0 : 2)
            .overlay {
                if borderColor != .clear {
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(borderColor, lineWidth: borderWidth)
                }
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
