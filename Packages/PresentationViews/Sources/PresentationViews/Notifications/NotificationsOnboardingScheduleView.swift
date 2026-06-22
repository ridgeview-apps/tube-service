import Models
import SwiftUI

public struct NotificationsOnboardingScheduleView: View {

    public let selectedLineIDs: Set<TrainLineID>
    public let onDone: (NotificationSchedulePreset) -> Void

    @State private var selectedPreset: NotificationSchedulePreset

    public init(
        selectedLineIDs: Set<TrainLineID>,
        initialPreset: NotificationSchedulePreset,
        onDone: @escaping (NotificationSchedulePreset) -> Void
    ) {
        self.selectedLineIDs = selectedLineIDs
        self.onDone = onDone
        _selectedPreset = State(initialValue: initialPreset)
    }

    public var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                selectedLinesCard
                NotificationsSchedulePicker(selectedPreset: $selectedPreset)
                    .cardStyle()
            }
            .padding(20)
        }
        .safeAreaInset(edge: .bottom) {
            Button {
                onDone(selectedPreset)
            } label: {
                Text(.globalDone)
                    .frame(maxWidth: .infinity)
                    .frame(height: 20)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .padding(20)
            .background(.bar)
        }
        .navigationTitle(Text(.notificationsScheduleNavigationTitle))
        .navigationBarTitleDisplayMode(.inline)
    }

    private var selectedLinesCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(selectedLineIDs.sorted(by: { $0.name < $1.name }), id: \.rawValue) { lineID in
                HStack(spacing: 10) {
                    Circle()
                        .fill(lineID.backgroundColor)
                        .frame(width: 12, height: 12)
                    Text(lineID.name)
                        .font(.subheadline)
                }
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardStyle()
    }
}


// MARK: - Previews

#if DEBUG
    #Preview {
        NavigationStack {
            NotificationsOnboardingScheduleView(
                selectedLineIDs: [.victoria, .jubilee, .central],
                initialPreset: .weekdayPeak,
                onDone: { _ in }
            )
        }
    }
#endif
