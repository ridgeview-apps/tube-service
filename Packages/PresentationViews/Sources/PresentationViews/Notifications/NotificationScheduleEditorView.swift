import Models
import SwiftUI

/// Edits a line's schedule day by day, on a copy that's only handed back on Save.
///
/// Presented by `LineScheduleCard` with the line screen's draft rather than through a `Destination`,
/// so unlike other PresentationViews views it owns its navigation chrome.
struct NotificationScheduleEditorView: View {
    private let initialSchedule: NotificationScheduleSelection
    private let onSave: (NotificationScheduleSelection) -> Void

    @State private var schedule: NotificationScheduleSelection

    @Environment(\.dismiss) private var dismiss

    init(schedule: NotificationScheduleSelection, onSave: @escaping (NotificationScheduleSelection) -> Void) {
        initialSchedule = schedule
        self.onSave = onSave
        _schedule = State(initialValue: schedule)
    }

    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(NotificationWeekday.allCases, id: \.self) { day in
                        NavigationLink(value: day) {
                            LabeledContent(day.fullSymbol, value: schedule[day].summary)
                        }
                    }
                } footer: {
                    if !schedule.hasAnyDayOn {
                        Text(.notificationsScheduleEditorNoDaysFooter)
                    }
                }
            }
            .navigationTitle(Text(.notificationsScheduleEditorTitle))
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: NotificationWeekday.self) { day in
                NotificationDayScheduleEditorView(day: day, schedule: schedule[day]) { daySchedule, otherDays in
                    for editedDay in otherDays.union([day]) {
                        schedule[editedDay] = daySchedule
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(role: .cancel) {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(role: .confirm) {
                        onSave(schedule)
                        dismiss()
                    }
                    .disabled(!schedule.hasAnyDayOn)
                }
            }
        }
        // The line screen's plain, backgroundless list style would otherwise carry into the sheet and its days.
        .listStyle(.insetGrouped)
        .scrollContentBackground(.visible)
        // A swipe would silently throw away the edits, so only Cancel closes the editor once there are any.
        .interactiveDismissDisabled(schedule != initialSchedule)
    }
}

// MARK: - Previews

#if DEBUG
    #Preview("Mixed days") {
        NotificationScheduleEditorView(
            schedule: .init([
                .monday: .peakHours,
                .tuesday: .peakHours,
                .wednesday: .times([
                    .init(startTime: .init(hour: 7, minute: 0), endTime: .init(hour: 9, minute: 0)),
                    .init(startTime: .init(hour: 17, minute: 30), endTime: .init(hour: 18, minute: 30))
                ]),
                .saturday: .allDay
            ]),
            onSave: { print($0) }
        )
    }

    #Preview("Every day off") {
        NotificationScheduleEditorView(schedule: .init([:]), onSave: { print($0) })
    }
#endif
