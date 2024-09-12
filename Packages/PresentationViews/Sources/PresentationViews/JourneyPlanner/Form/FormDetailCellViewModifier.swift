import Foundation
import SwiftUI

struct FormDetailCellViewModifier: ViewModifier {
    
    let title: LocalizedStringResource?
    let alignment: VerticalAlignment
    let errors: [String]?
    
    func body(content: Content) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            if let title {
                Text(title)
                    .font(.caption)
            }
            content
            if let errors, !errors.isEmpty {
                HStack(alignment: .top, spacing: 4) {
                    Image(systemName: "exclamationmark.circle.fill")
                        .imageScale(.small)
                    VStack(alignment: .leading) {
                        ForEach(errors, id: \.self) { error in
                            Text(error)
                                .font(.footnote)
                        }
                    }
                }
                .foregroundStyle(.adaptiveRed)
            }
        }
    }
}

extension View {
    func formDetailCell(title: LocalizedStringResource? = nil,
                        alignment: VerticalAlignment = .firstTextBaseline,
                        errors: [String]? = nil) -> some View {
        modifier(FormDetailCellViewModifier(title: title,
                                            alignment: alignment,
                                            errors: errors))
    }
}


// MARK: - Previews
#Preview {
    VStack(alignment: .leading, spacing: 20) {
        Text("Text detail")
            .formDetailCell(title: "Text cell title")
        Text("Error detail")
            .formDetailCell(title: "Error cell citle",
                            errors: ["Error message 1", "Error message 2"])
        Button("Button example") {}
            .formDetailCell(title: "Button cell title")
        Toggle("", isOn: .constant(true))
            .formDetailCell(title: "Toggle example", alignment: .center)
    }
}
