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
        .navigationTitle(Text(L10n.settingsNotificationsRowTitle))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(L10n.globalDone) {
                    Task { await saveChanges() }
                }
                .disabled(selectedLineIDs.isEmpty || notifications.isSavingPreferences)
            }
        }
    }


    // MARK: - Views

    private var linesSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(L10n.notificationsPreferencesLinesSectionTitle)
                .font(.footnote.weight(.semibold))
                .foregroundStyle(.secondary)
                .textCase(.uppercase)
            Text("Select the lines you'd like to receive disruption alerts for.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            NotificationsLineSelectionGrid(selectedLineIDs: $selectedLineIDs)
                .padding(.top, 4)
        }
    }

    private var scheduleSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(L10n.notificationsScheduleNavigationTitle)
                .font(.footnote.weight(.semibold))
                .foregroundStyle(.secondary)
                .textCase(.uppercase)
        }
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
                            .init(
                                lineId: "victoria",
                                enabled: true,
                                severityThreshold: .minorDelays,
                                notifyRecoveries: true,
                                schedulePreset: .weekends,
                                customSchedules: []
                            ),
                            .init(
                                lineId: "central",
                                enabled: true,
                                severityThreshold: .minorDelays,
                                notifyRecoveries: true,
                                schedulePreset: .weekends,
                                customSchedules: []
                            )
                        ],
                        createdAt: .now,
                        updatedAt: .now
                    )
                )
            }
        }
    }
#endif
