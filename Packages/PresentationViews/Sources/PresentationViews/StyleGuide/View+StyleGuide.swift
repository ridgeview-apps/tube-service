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
                   borderColor: Color = .defaultCellBackground,
                   borderWidth: CGFloat = 0.5) -> some View {
        self.modifier(
            CardStyle(cornerRadius: cornerRadius,
                                backgroundColor: backgroundColor,
                                borderColor: borderColor,
                                borderWidth: borderWidth)
        )
    }
    
    func defaultListRowStyle(edgeInsets: EdgeInsets = .zero,
                             listRowSeparator separatorVisibility: Visibility = .hidden,
                             backgroundColor: Color = .defaultBackground) -> some View {
        self
            .listRowBackground(backgroundColor)
            .listRowInsets(edgeInsets)
            .listRowSeparator(separatorVisibility)
            
    }
    
    func styledTabItem(imageName: String,
                       title: LocalizedStringResource,
                       accessibilityID: String) -> some View {
        tabItem {
            VStack {
                Image(systemName: imageName)
                    .imageScale(.large)
                Text(title)
            }
            .accessibilityIdentifier(accessibilityID)
        }        
    }
    
    func defaultScrollContentBackgroundColor() -> some View {
        self
            .scrollContentBackground(.hidden)
            .background(Color.defaultBackground)
    }
    
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
    
    func withDefaultMaxWidth(alignment: Alignment = .center) -> some View {
        self.frame(maxWidth: 600, alignment: alignment)
    }

    func readSize(onChange: @escaping (CGSize) -> Void) -> some View {
        background(
            GeometryReader { geometryProxy in
                Color.clear.preference(key: SizePreferenceKey.self, value: geometryProxy.size)
            }
        )
        .onPreferenceChange(SizePreferenceKey.self, perform: onChange)
    }
    
    @ViewBuilder
    func withHardScrollEdgeEffectStyle(for edges: Edge.Set = .all) -> some View {
        if #available(iOS 26.0, *) {
            scrollEdgeEffectStyle(.hard, for: edges)
        } else {
            self
        }
    }
    
    @ViewBuilder
    func withScrollEdgeEffectHidden(_ hidden: Bool = true, for edges: Edge.Set = .all) -> some View {
        if #available(iOS 26.0, *) {
            scrollEdgeEffectHidden(hidden, for: edges)
        } else {
            self
        }
    }
    
    @ViewBuilder
    func withRegularGlassEffect() -> some View {
        if #available(iOS 26.0, *) {
            glassEffect(.regular)
        } else {
            self
        }
    }
}

extension ForEach where Content: View {
    
    func onDeleteItem<Element>(in array: [Element],
                               action: @escaping (Element) -> Void) -> some View {
        onDelete { offsets in
            let index = offsets[offsets.startIndex]
            if array.indices.contains(index) {
                let itemToDelete = array[index]
                action(itemToDelete)
            }
        }
    }
}

private struct SizePreferenceKey: PreferenceKey {
  static var defaultValue: CGSize = .zero
  static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
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

struct HLine: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: rect.minX, y: rect.midY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        }
    }
}

struct VLine: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: rect.midX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
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

struct ClearButton: ViewModifier {
    @Binding var text: String
    
    func body(content: Content) -> some View {
        HStack {
            content
            
            if !text.isEmpty {
                Button {
                    text = ""
                } label: {
                    Image(systemName: "multiply.circle.fill")
                        .foregroundStyle(.gray)
                }
                .buttonStyle(.borderless)
            }
        }
    }
}

extension View {
    func clearButton(text: Binding<String>) -> some View {
        modifier(ClearButton(text: text))
    }
}
