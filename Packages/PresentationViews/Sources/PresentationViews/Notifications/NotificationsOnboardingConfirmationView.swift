import Models
import SwiftUI

public struct NotificationsOnboardingConfirmationView: View {

    public let selectedLineIDs: Set<TrainLineID>
    public let selectedSchedulePreset: NotificationSchedulePreset
    public let onDone: () -> Void

    public init(
        selectedLineIDs: Set<TrainLineID>,
        selectedSchedulePreset: NotificationSchedulePreset,
        onDone: @escaping () -> Void
    ) {
        self.selectedLineIDs = selectedLineIDs
        self.selectedSchedulePreset = selectedSchedulePreset
        self.onDone = onDone
    }

    public var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                VStack(spacing: 16) {
                    ZStack {
                        Circle()
                            .fill(Color.green.opacity(0.15))
                            .frame(width: 88, height: 88)

                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 44))
                            .foregroundStyle(.green)
                    }

                    VStack(spacing: 8) {
                        Text(L10n.notificationsConfirmationTitle)
                            .font(.title2.weight(.bold))
                            .multilineTextAlignment(.center)

                        Text(L10n.notificationsConfirmationDescription)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                }

                selectedLinesCard
                scheduleCard
            }
            .padding(20)
        }
        .navigationTitle(Text(L10n.notificationsConfirmationNavigationTitle))
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(String(localized: L10n.globalDone)) {
                    onDone()
                }
            }
        }
    }

    private var scheduleCard: some View {
        HStack(spacing: 12) {
            Image(systemName: selectedSchedulePreset.systemImage)
                .font(.title3.weight(.semibold))
                .foregroundStyle(Color.accentColor)
                .frame(width: 28)

            VStack(alignment: .leading, spacing: 2) {
                Text(L10n.notificationsConfirmationScheduleLabel)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(selectedSchedulePreset.title)
                    .font(.subheadline.weight(.medium))
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardStyle()
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
            NotificationsOnboardingConfirmationView(
                selectedLineIDs: [.victoria, .jubilee, .central],
                selectedSchedulePreset: .weekdayPeak,
                onDone: {}
            )
        }
    }
#endif
