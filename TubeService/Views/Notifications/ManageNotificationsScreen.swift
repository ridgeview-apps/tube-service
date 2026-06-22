import DataStores
import Models
import PresentationViews
import SwiftUI

@MainActor
struct ManageNotificationsScreen: View {

    @Environment(NotificationsDataStore.self) var notifications

    @State private var selectedLineIDs: Set<TrainLineID>
    @State private var selectedPreset: NotificationSchedulePreset

    private let preferences: NotificationPreferences

    init(preferences: NotificationPreferences) {
        self.preferences = preferences
        let enabledLines = preferences.lines.filter(\.enabled)
        _selectedLineIDs = State(initialValue: Set(enabledLines.compactMap { TrainLineID(rawValue: $0.lineId) }))
        _selectedPreset = State(initialValue: enabledLines.first?.schedulePreset ?? .weekdayPeak)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                linesSection
                scheduleSection
            }
            .padding(20)
        }
        .safeAreaInset(edge: .bottom) {
            bottomActions
        }
        .navigationTitle(Text(L10n.settingsNotificationsRowTitle))
        .navigationBarTitleDisplayMode(.inline)
    }


    // MARK: - Layout views

    private var linesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(L10n.notificationsPreferencesLinesSectionTitle)
                .font(.footnote.weight(.semibold))
                .foregroundStyle(.secondary)
                .textCase(.uppercase)
            NotificationsLineSelectionGrid(selectedLineIDs: $selectedLineIDs)
        }
    }

    private var scheduleSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(L10n.notificationsScheduleNavigationTitle)
                .font(.footnote.weight(.semibold))
                .foregroundStyle(.secondary)
                .textCase(.uppercase)
            NotificationsSchedulePicker(selectedPreset: $selectedPreset)
                .cardStyle()
        }
    }

    private var bottomActions: some View {
        VStack(spacing: 12) {
            Button {
                Task { await saveChanges() }
            } label: {
                Text(L10n.globalDone)
                    .frame(maxWidth: .infinity)
                    .frame(height: 20)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .disabled(selectedLineIDs.isEmpty || notifications.isSavingPreferences)

            Button(role: .destructive) {
                Task { await disableNotifications() }
            } label: {
                Text(L10n.notificationsPreferencesDisableButtonTitle)
                    .font(.subheadline)
            }
        }
        .padding(20)
        .background(.bar)
    }


    // MARK: - Actions

    private func saveChanges() async {
        let update = NotificationPreferencesUpdate(
            lines: selectedLineIDs.map { lineID in
                let existing = preferences.lines.first { $0.lineId == lineID.rawValue }
                return NotificationLinePreferenceUpdate(
                    lineId: lineID.rawValue,
                    severityThreshold: existing?.severityThreshold ?? .minorDelays,
                    notifyRecoveries: existing?.notifyRecoveries ?? true,
                    schedulePreset: selectedPreset,
                    customSchedules: existing?.customSchedules ?? []
                )
            }
        )
        await notifications.updatePreferences(update)
    }

    private func disableNotifications() async {
        await notifications.disableDevice()
    }
}


// MARK: - Previews

#if DEBUG
    #Preview {
        PreviewEnvironment {
            NavigationStack {
                ManageNotificationsScreen(
                    preferences: NotificationPreferences(
                        deviceId: "preview-device",
                        lines: [
                            NotificationLinePreference(lineId: "victoria", schedulePreset: .weekdayPeak),
                            NotificationLinePreference(lineId: "central", schedulePreset: .weekdayPeak)
                        ],
                        createdAt: .now,
                        updatedAt: .now
                    )
                )
            }
        }
    }
#endif
