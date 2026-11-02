import SwiftUI

/// An Edit / Done button for section headers, which are often barely taller than their text.
/// The font comes from the surrounding header.
struct EditModeButton: View {

    @Binding var editMode: EditMode

    var body: some View {
        Button {
            withAnimation { editMode = editMode.isEditing ? .inactive : .active }
        } label: {
            // Pad out the tap target, and cancel the padding outside the button to leave the layout unchanged
            Text(editMode.isEditing ? .globalDone : .globalEdit)
                .padding(.vertical, 12)
                .padding(.horizontal, 16)
                .contentShape(.rect)
        }
        .buttonStyle(.borderless)
        .foregroundStyle(.tint)
        .padding(.vertical, -12)
        .padding(.horizontal, -16)
    }
}
