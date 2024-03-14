import Foundation
import SwiftUI

struct FormDetailCellViewModifier: ViewModifier {
    let title: LocalizedStringKey
    let alignment: VerticalAlignment
    
    func body(content: Content) -> some View {
        HStack(alignment: alignment) {
            Text(title, bundle: .module)
                .font(.footnote)
            Spacer()
            content
        }
        .frame(minHeight: 44)
    }
}

extension View {
    func formDetailCell(title: LocalizedStringKey,
                        alignment: VerticalAlignment = .firstTextBaseline) -> some View {
        modifier(FormDetailCellViewModifier(title: title,
                                            alignment: alignment))
    }
}


// MARK: - Previews
#Preview {
    VStack {
        Text("Text example")
            .formDetailCell(title: "Text cell title")
        Button("Button example") {}
            .formDetailCell(title: "Button cell title")
        Toggle("", isOn: .constant(true))
            .formDetailCell(title: "Toggle example", alignment: .center)
    }
}
