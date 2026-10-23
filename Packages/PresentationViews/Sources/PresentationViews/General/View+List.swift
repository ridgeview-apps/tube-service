import SwiftUI

public extension View {

    func defaultScrollContentBackgroundColor() -> some View {
        self
            .scrollContentBackground(.hidden)
            .background(Color.defaultBackground)
    }

}

extension ForEach where Content: View {

    func onDeleteItem<Element>(
        in array: [Element],
        action: @escaping (Element) -> Void
    ) -> some View {
        onDelete { offsets in
            let index = offsets[offsets.startIndex]
            if array.indices.contains(index) {
                let itemToDelete = array[index]
                action(itemToDelete)
            }
        }
    }
}
