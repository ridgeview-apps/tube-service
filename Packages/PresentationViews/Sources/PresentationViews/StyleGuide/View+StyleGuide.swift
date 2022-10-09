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
        self.background(backgroundColor)
            .cornerRadius(cornerRadius)
            .shadow(color: .primary.opacity(0.14), radius: 4, x: 0, y: 2)
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
