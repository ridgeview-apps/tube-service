import SwiftUI

public struct RowButton<Label: View>: View {
    private(set) var alignment: Alignment
    private(set) var action: () -> Void
    private(set) var label: () -> Label
    
    public init(
        alignment: Alignment = .leading,
        action: @escaping () -> Void,
        label: @escaping () -> Label
    ) {
        self.alignment = alignment
        self.action = action
        self.label = label
    }

    public var body: some View {
        Button(action: action) {
            self.label()
                .frame(maxWidth: .infinity, alignment: alignment)
                .contentShape(Rectangle())
        }
    }
}
