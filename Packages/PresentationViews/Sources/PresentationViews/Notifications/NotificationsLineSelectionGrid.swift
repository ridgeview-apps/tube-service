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
            ForEach(TrainLineID.allCases.sorted(by: { $0.name < $1.name }), id: \.rawValue) { lineID in
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
            HStack(spacing: 0) {
                lineID.backgroundColor
                    .frame(width: 5)
                HStack(spacing: 8) {
                    Text(lineID.name)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.primary)
                        .minimumScaleFactor(0.75)
                        .lineLimit(1)
                    Spacer(minLength: 0)
                    Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundStyle(isSelected ? lineID.backgroundColor : Color(.tertiaryLabel))
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 10)
                .frame(maxWidth: .infinity)
                .background(Color(.systemFill))
            }
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
