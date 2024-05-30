import SwiftUI

struct SwapValuesButton<Value>: View {
    
    @Binding var isSwapped: Bool
    @Binding var valueA: Value
    @Binding var valueB: Value
    
    init(isSwapped: Binding<Bool>,
         valueA: Binding<Value>,
         valueB: Binding<Value>) {
        self._isSwapped = isSwapped
        self._valueA = valueA
        self._valueB = valueB
    }
    
    var body: some View {
        Button {
            withAnimation {
                let oldValueA = valueA
                valueA = valueB
                valueB = oldValueA
                isSwapped.toggle()
            }
        } label: {
            Image(systemName: "arrow.up.arrow.down")
                .accessibilityLabel(Text(.swapButtonAccessibilityTitle))
        }
    }
}


// MARK: - Animation view modifiers

public enum SwapValuesViewPosition {
    case firstPairItem, secondPairItem
}

public struct SwapValuesTaggedViewID<PairedViewID: Hashable>: Hashable {
    let position: SwapValuesViewPosition
    let pairID: PairedViewID

    static func firstPairItem(_ pairID: PairedViewID) -> SwapValuesTaggedViewID<PairedViewID> {
        .init(position: .firstPairItem, pairID: pairID)
    }
    
    static func secondPairItem(_ pairID: PairedViewID) -> SwapValuesTaggedViewID<PairedViewID> {
        .init(position: .secondPairItem, pairID: pairID)
    }
    
    var swappedViewID: SwapValuesTaggedViewID<PairedViewID> {
        switch position {
        case .firstPairItem:
            return .init(position: .secondPairItem, pairID: pairID)
        case .secondPairItem:
            return .init(position: .firstPairItem, pairID: pairID)
        }
    }
}

struct SwapValuesSettings<TagID: Hashable> {
    let viewID: SwapValuesTaggedViewID<TagID>
    let isSwapped: Bool
    let namespace: Namespace.ID
}

private struct SwapValuesButtonGeometryEffectID<TagID: Hashable>: ViewModifier {
    
    let settings: SwapValuesSettings<TagID>
        
    func body(content: Content) -> some View {
        if settings.isSwapped {
            content
                .matchedGeometryEffect(id: settings.viewID, in: settings.namespace)
        } else {
            content
                .matchedGeometryEffect(id: settings.viewID.swappedViewID, in: settings.namespace)
                
        }
    }
}

extension View {
    func swapValuesGeometryEffectID<TagID: Hashable>(_ settings: SwapValuesSettings<TagID>) -> some View {
        self.modifier(SwapValuesButtonGeometryEffectID(settings: settings))
    }
    
    
    func swapValuesGeometryEffectID<TagID: Hashable>(_ viewID: SwapValuesTaggedViewID<TagID>,
                                                     isSwapped: Bool,
                                                     in namespace: Namespace.ID) -> some View {
        self.swapValuesGeometryEffectID(
            .init(viewID: viewID, isSwapped: isSwapped, namespace: namespace)
        )
    }
}


// MARK: - Previews
private struct Previewer: View {
    private struct PreviewCell: View {
        @State var value1 = "This is value1"
        @State var value2 = "This is value2"
        @State var isSwapped = false
        let cellID: String
        
        @Namespace private var animationNamespace

        var body: some View {
            HStack {
                VStack {
                    Text("\(cellID)-\(value1)")
                        .swapValuesGeometryEffectID(.firstPairItem(cellID),
                                                    isSwapped: isSwapped,
                                                    in: animationNamespace)
                    Text("\(cellID)-\(value2)")
                        .swapValuesGeometryEffectID(.secondPairItem(cellID),
                                                    isSwapped: isSwapped,
                                                    in: animationNamespace)
                }
                SwapValuesButton(isSwapped: $isSwapped,
                                 valueA: $value1,
                                 valueB: $value2)
            }
        }
    }
    
    var body: some View {
        VStack {
            PreviewCell(cellID: "cell1")
            PreviewCell(cellID: "cell2")
        }
    }
}

#Preview {
    Previewer()
}
