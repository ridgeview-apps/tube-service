import SwiftUI

/// An Edit / Done button for section headers.
struct EditModeButton: View {

    @Binding var editMode: EditMode

    var body: some View {
        SectionHeaderButton(title: editMode.isEditing ? .globalDone : .globalEdit) {
            withAnimation { editMode = editMode.isEditing ? .inactive : .active }
        }
    }
}

/// A text button for section headers, which are often barely taller than their text. The font comes from the
/// surrounding header.
struct SectionHeaderButton: View {

    let title: LocalizedStringResource
    let action: () -> Void

    @Environment(\.isEnabled) private var isEnabled

    var body: some View {
        Button(action: action) {
            // Pad out the tap target, and cancel the padding outside the button to leave the layout unchanged
            Text(title)
                .padding(.vertical, 12)
                .padding(.horizontal, 16)
                .contentShape(.rect)
        }
        .buttonStyle(.borderless)
        .foregroundStyle(isEnabled ? AnyShapeStyle(.tint) : AnyShapeStyle(.tertiary))
        .padding(.vertical, -12)
        .padding(.horizontal, -16)
    }
}
