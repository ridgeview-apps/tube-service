import Models
import SwiftUI

public struct NotificationsLineSelectionGrid: View {

    @Binding public var selectedLineIDs: Set<TrainLineID>

    private let columns = [GridItem(.flexible()), GridItem(.flexible())]

    public init(selectedLineIDs: Binding<Set<TrainLineID>>) {
        self._selectedLineIDs = selectedLineIDs
    }

    public var body: some View {
        LazyVGrid(columns: columns, spacing: 10) {
            ForEach(TrainLineID.allCases, id: \.rawValue) { lineID in
                lineButton(lineID)
            }
        }
    }

    private func lineButton(_ lineID: TrainLineID) -> some View {
        let isSelected = selectedLineIDs.contains(lineID)
        return Button {
            if isSelected {
                selectedLineIDs.remove(lineID)
            } else {
                selectedLineIDs.insert(lineID)
            }
        } label: {
            HStack(spacing: 6) {
                Text(lineID.name)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(isSelected ? lineID.textColor : .primary)
                    .minimumScaleFactor(0.8)
                    .lineLimit(1)
                Spacer(minLength: 0)
                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(lineID.textColor)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .frame(maxWidth: .infinity)
            .background(isSelected ? lineID.backgroundColor : Color(.systemFill))
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .buttonStyle(.plain)
    }
}


// MARK: - Previews

#if DEBUG
    #Preview {
        @Previewable @State var selection: Set<TrainLineID> = [.victoria, .jubilee]
        NotificationsLineSelectionGrid(selectedLineIDs: $selection)
            .padding()
    }
#endif
