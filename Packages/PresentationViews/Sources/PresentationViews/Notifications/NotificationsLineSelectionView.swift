import Models
import SwiftUI

public struct NotificationsLineSelectionView: View {

    @State private var selectedLineIDs: Set<TrainLineID>
    public let onContinue: (Set<TrainLineID>) -> Void

    private let columns = [GridItem(.flexible()), GridItem(.flexible())]

    public init(initialSelection: Set<TrainLineID>, onContinue: @escaping (Set<TrainLineID>) -> Void) {
        _selectedLineIDs = State(initialValue: initialSelection)
        self.onContinue = onContinue
    }

    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text(L10n.notificationsLineSelectionSubtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 20)

                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(TrainLineID.allCases, id: \.rawValue) { lineID in
                        lineButton(lineID)
                    }
                }
                .padding(.horizontal, 20)
            }
            .padding(.top, 12)
            .padding(.bottom, 20)
        }
        .safeAreaInset(edge: .bottom) {
            Button {
                onContinue(selectedLineIDs)
            } label: {
                Text(L10n.globalContinue)
                    .frame(maxWidth: .infinity)
                    .frame(height: 20)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .disabled(selectedLineIDs.isEmpty)
            .padding(20)
            .background(.bar)
        }
        .navigationTitle(Text(L10n.notificationsLineSelectionNavigationTitle))
        .navigationBarTitleDisplayMode(.inline)
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
        NavigationStack {
            NotificationsLineSelectionView(
                initialSelection: [.victoria, .jubilee],
                onContinue: { _ in }
            )
        }
    }
#endif
