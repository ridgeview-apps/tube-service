import Models
import SwiftUI

struct AddLineMenu: View {
    let lineIDs: [TrainLineID]
    let label: LocalizedStringResource
    let onSelect: (TrainLineID) -> Void

    @Environment(\.lineSelectionZoomNamespace) private var zoomNamespace

    var body: some View {
        Menu {
            ForEach(lineIDs, id: \.self) { lineID in
                Button {
                    onSelect(lineID)
                } label: {
                    Label(lineID.name, systemImage: "circle.fill")
                }
                .tint(lineID.backgroundColor)
            }
        } label: {
            Label(String(localized: label), systemImage: "plus.circle.fill")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.tint)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(16)
        }
        .matchedTransitionSourceIfPresent(id: "addLineMenu", in: zoomNamespace)
    }
}
