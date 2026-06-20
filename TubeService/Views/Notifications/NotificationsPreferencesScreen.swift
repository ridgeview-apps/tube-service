import DataStores
import Models
import PresentationViews
import SwiftUI

@MainActor
struct NotificationsPreferencesScreen: View {

    @Environment(NotificationsDataStore.self) var notifications
    @Environment(\.dismiss) var dismiss

    @State private var selectedLineIDs: Set<TrainLineID>
    @State private var selectedPreset: NotificationSchedulePreset

    let preferences: NotificationPreferences

    init(preferences: NotificationPreferences) {
        self.preferences = preferences
        let lineIDs = Set(preferences.lineIds.compactMap { TrainLineID(rawValue: $0) })
        _selectedLineIDs = State(initialValue: lineIDs)
        _selectedPreset = State(initialValue: preferences.schedulePreset)
    }

    var body: some View {
        Form {
            linesSection
            scheduleSection
            disableSection
        }
        .navigationTitle(Text(L10n.settingsNotificationsRowTitle))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(String(localized: L10n.globalDone)) {
                    Task { await saveChanges() }
                }
                .disabled(selectedLineIDs.isEmpty || notifications.isSavingPreferences)
            }
        }
    }


    // MARK: - Sections

    private var linesSection: some View {
        Section(header: Text(L10n.notificationsPreferencesLinesSectionTitle)) {
            ForEach(TrainLineID.allCases, id: \.rawValue) { lineID in
                Button {
                    if selectedLineIDs.contains(lineID) {
                        selectedLineIDs.remove(lineID)
                    } else {
                        selectedLineIDs.insert(lineID)
                    }
                } label: {
                    HStack {
                        Circle()
                            .fill(lineID.backgroundColor)
                            .frame(width: 12, height: 12)
                        Text(lineID.name)
                        Spacer()
                        if selectedLineIDs.contains(lineID) {
                            Image(systemName: "checkmark")
                                .foregroundStyle(Color.accentColor)
                        }
                    }
                }
                .foregroundStyle(.primary)
            }
        }
    }

    private var scheduleSection: some View {
        Section(header: Text(L10n.notificationsScheduleNavigationTitle)) {
            scheduleRow(
                preset: .weekdayPeak,
                title: L10n.notificationsScheduleWeekdayPeakTitle,
                description: L10n.notificationsScheduleWeekdayPeakDescription
            )
            scheduleRow(
                preset: .weekdayAllDay,
                title: L10n.notificationsScheduleWeekdayAllDayTitle,
                description: L10n.notificationsScheduleWeekdayAllDayDescription
            )
            scheduleRow(
                preset: .weekends,
                title: L10n.notificationsScheduleWeekendsTitle,
                description: L10n.notificationsScheduleWeekendsDescription
            )
            scheduleRow(
                preset: .anytime,
                title: L10n.notificationsScheduleAnytimeTitle,
                description: L10n.notificationsScheduleAnytimeDescription
            )
        }
    }

    private var disableSection: some View {
        Section {
            Button(role: .destructive) {
                Task { await disableNotifications() }
            } label: {
                Text(L10n.notificationsPreferencesDisableButtonTitle)
            }
        }
    }


    // MARK: - Helpers

    private func scheduleRow(
        preset: NotificationSchedulePreset,
        title: LocalizedStringResource,
        description: LocalizedStringResource
    ) -> some View {
        Button {
            selectedPreset = preset
        } label: {
            HStack(alignment: .top, spacing: 12) {
                Image(
                    systemName: selectedPreset == preset
                        ? "checkmark.circle.fill"
                        : "circle"
                )
                .foregroundStyle(selectedPreset == preset ? Color.accentColor : .secondary)
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.body)
                    Text(description)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .foregroundStyle(.primary)
    }

    private func saveChanges() async {
        let update = NotificationPreferencesUpdate(
            enabled: true,
            lineIds: selectedLineIDs.map(\.rawValue),
            severityThreshold: preferences.severityThreshold,
            notifyRecoveries: preferences.notifyRecoveries,
            schedulePreset: selectedPreset,
            customSchedules: []
        )
        await notifications.updatePreferences(update)
        dismiss()
    }

    private func disableNotifications() async {
        await notifications.disableDevice()
        dismiss()
    }
}


// MARK: - Previews

#if DEBUG
    #Preview {
        PreviewEnvironment {
            NavigationStack {
                NotificationsPreferencesScreen(
                    preferences: NotificationPreferences(
                        deviceId: "preview-device",
                        enabled: true,
                        lineIds: ["victoria", "central"],
                        severityThreshold: .minorDelays,
                        notifyRecoveries: true,
                        schedulePreset: .weekdayPeak,
                        customSchedules: [],
                        createdAt: .now,
                        updatedAt: .now
                    )
                )
            }
        }
    }
#endif
