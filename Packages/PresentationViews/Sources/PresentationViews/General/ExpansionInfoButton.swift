import SwiftUI

public struct ExpansionInfoButton: View {
    
    public let style: Style
    public let titleState: TitleState
    @Binding public var isExpanded: Bool
    
    public init(
        style: Style = .imageAndText,
        titleState: TitleState = .showMoreLess,
        isExpanded: Binding<Bool>
    ) {
        self.style = style
        self.titleState = titleState
        self._isExpanded = isExpanded
    }
    
    private var title: LocalizedStringResource {
        isExpanded ? titleState.expanded : titleState.collapsed
    }
    
    
    public enum Style {
        case imageOnly
        case imageAndText
        
    }
    
    public var body: some View {
        Button {
            withAnimation {
                isExpanded.toggle()
            }
        } label: {
            HStack(spacing: 4) {
                if style == .imageAndText {
                    Text(title)
                }
                Image(systemName: "chevron.down")
                    .rotationEffect(rotationAngle)
            }
        }
        .accessibilityLabel(title)
        .accessibilityAddTraits(.isToggle)
    }
    
    private var rotationAngle: Angle {
        isExpanded ? .init(degrees: 180) : .init(degrees: 0)
    }
}

public extension ExpansionInfoButton {
    
    struct TitleState {
        public let collapsed: LocalizedStringResource
        public let expanded: LocalizedStringResource
        
        public init(
            collapsed: LocalizedStringResource,
            expanded: LocalizedStringResource
        ) {
            self.collapsed = collapsed
            self.expanded = expanded
        }
        
        public static let showMoreLess: TitleState = .init(
            collapsed: .expansionInfoButtonShowMoreTitle,
            expanded: .expansionInfoButtonShowLessTitle
        )
        
        public static func constant(_ value: LocalizedStringResource) -> TitleState {
            .init(collapsed: value, expanded: value)
        }
    }
}

// MARK: - Previews
#Preview {
    @Previewable @State var isExpanded = false
    VStack {
        ExpansionInfoButton(
            isExpanded: $isExpanded
        )
        ExpansionInfoButton(
            style: .imageOnly,
            isExpanded: $isExpanded
        )
        ExpansionInfoButton(
            titleState: .constant("Fixed title"),
            isExpanded: $isExpanded
        )
    }
}
