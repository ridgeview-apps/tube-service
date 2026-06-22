import Models
import SwiftUI

public struct NotificationsLineSelectionView: View {

    @State private var selectedLineIDs: Set<TrainLineID>
    public let onContinue: (Set<TrainLineID>) -> Void

    public init(initialSelection: Set<TrainLineID>, onContinue: @escaping (Set<TrainLineID>) -> Void) {
        _selectedLineIDs = State(initialValue: initialSelection)
        self.onContinue = onContinue
    }

    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text(.notificationsLineSelectionSubtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 20)

                NotificationsLineSelectionGrid(selectedLineIDs: $selectedLineIDs)
                    .padding(.horizontal, 20)
            }
            .padding(.top, 12)
            .padding(.bottom, 20)
        }
        .safeAreaInset(edge: .bottom) {
            Button {
                onContinue(selectedLineIDs)
            } label: {
                Text(.globalContinue)
                    .frame(maxWidth: .infinity)
                    .frame(height: 20)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .disabled(selectedLineIDs.isEmpty)
            .padding(20)
            .background(.bar)
        }
        .navigationTitle(Text(.notificationsLineSelectionNavigationTitle))
        .navigationBarTitleDisplayMode(.inline)
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
