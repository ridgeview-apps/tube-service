import SwiftUI

struct ExpansionInfoButton: View {
    
    let style: Style
    @Binding var isExpanded: Bool    
    
    enum Style {
        case pullDown
        case list
    }
    
    var body: some View {
        Button(action: {
            self.isExpanded.toggle()
        }) {
            HStack {
                self.expansionButtonImage
            }
            .imageScale(self.imageScale)
            .frame(alignment: .bottom)
        }
        .rotationEffect(isExpanded ? .init(degrees: 180) : .init(degrees: 0))
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
