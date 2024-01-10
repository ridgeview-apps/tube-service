import SwiftUI

public struct ExpansionInfoButton: View {
    
    public let style: Style
    @Binding public var isExpanded: Bool
    
    
    public init(style: Style,
                isExpanded: Binding<Bool>) {
        self.style = style
        self._isExpanded = isExpanded
    }
    
    
    public enum Style {
        case pullDown
        case list
    }
    
    public var body: some View {
        Button {
            isExpanded.toggle()
        } label: {
            HStack {
                expansionButtonImage
                    .rotationEffect(isExpanded ? .init(degrees: 180) : .init(degrees: 0))
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
