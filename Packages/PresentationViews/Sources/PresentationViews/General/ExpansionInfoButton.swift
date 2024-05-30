import SwiftUI

public struct ExpansionInfoButton: View {
    
    public let style: Style
    public let title: LocalizedStringResource?
    public var titleAlignment: Alignment = .leading
    @Binding public var isExpanded: Bool
    
    public init(style: Style,
                title: LocalizedStringResource? = nil,
                isExpanded: Binding<Bool>) {
        self.style = style
        self.title = title
        self._isExpanded = isExpanded
    }
    
    
    public enum Style {
        case pullDown
        case list
        
        var expandedRotationAngle: CGFloat {
            switch self {
            case .pullDown: 180
            case .list: 90
            }
        }
    }
    
    public var body: some View {
        Button {
            withAnimation {
                isExpanded.toggle()
            }
        } label: {
            HStack(spacing: 4) {
                expansionButtonImage
                    .rotationEffect(isExpanded ? .init(degrees: style.expandedRotationAngle) : .init(degrees: 0))
                if let title {
                    Text(title)
                        .frame(maxWidth: .infinity, alignment: titleAlignment)
                }
            }
            .imageScale(imageScale)
            .frame(alignment: .bottom)
        }
        .buttonStyle(.borderless)
    }
    
    private var expansionButtonImage: Image {
        switch style {
        case .pullDown:
            return Image(systemName: "arrowtriangle.down.circle")
        case .list:
            return Image(systemName: "chevron.right")
        }
    }
    
    private var imageScale: Image.Scale {
        switch style {
        case .pullDown:
            return .large
        case .list:
            return .small
        }
    }
}

// MARK: - Previews

struct ExpansionInfoButton_Previews: PreviewProvider {
    
    struct ExpansionInfoButtonPreview: View {
        @State private(set) var style: ExpansionInfoButton.Style
        @State private(set) var isExpanded = false
        var title: LocalizedStringResource?
        
        var body: some View {
            ExpansionInfoButton(style: style,
                                title: title,
                                isExpanded: $isExpanded)
        }
    }
    
    static var previews: some View {
        VStack {
            ExpansionInfoButtonPreview(style: .pullDown,
                                       isExpanded: true)
            ExpansionInfoButtonPreview(style: .pullDown,
                                       isExpanded: false)
            ExpansionInfoButtonPreview(style: .pullDown,
                                       title: "Show more")
        }
    }
}
