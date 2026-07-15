import SwiftUI

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
