import SwiftUI

struct RowButton<Label: View>: View {
    private(set) var alignment: Alignment = .leading
    private(set) var action: () -> Void
    private(set) var label: () -> Label
    
    var body: some View {
        Button(action: action) {
            self.label()
                .frame(maxWidth: .infinity, alignment: alignment)
                .contentShape(Rectangle())
        }
    }
}
