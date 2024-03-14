import SwiftUI

public struct ExpansionInfoButton: View {
    
    public enum Title {
        case leading(LocalizedStringKey)
        case trailing(LocalizedStringKey)
    }
    
    public let style: Style
    public let title: Title?
    @Binding public var isExpanded: Bool
    
    
    public init(style: Style,
                title: Title? = nil,
                isExpanded: Binding<Bool>) {
        self.style = style
        self.title = title
        self._isExpanded = isExpanded
    }
    
    
    public enum Style {
        case pullDown
        case list
    }
    
    public var body: some View {
        Button {
            withAnimation {
                isExpanded.toggle()
            }
        } label: {
            HStack(spacing: 4) {
                if case let .leading(title) = title {
                    Text(title, bundle: .module)
                }
                expansionButtonImage
                    .rotationEffect(isExpanded ? .init(degrees: 180) : .init(degrees: 0))
                if case let .trailing(title) = title {
                    Text(title, bundle: .module)
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
            return Image(systemName: "chevron.down")
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
        
        var body: some View {
            ExpansionInfoButton(style: style, isExpanded: $isExpanded)
        }
    }
    
    static var previews: some View {
        VStack {
            ExpansionInfoButtonPreview(style: .pullDown,
                                       isExpanded: true)
            ExpansionInfoButtonPreview(style: .pullDown,
                                       isExpanded: false)
        }
    }
}
