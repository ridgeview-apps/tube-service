import Models
import SwiftUI

/// Edits one day's schedule, and optionally copies it to other days.
///
/// Changes apply on Done rather than on Back, so the merged times show in the day's row once it's confirmed.
struct NotificationDayScheduleEditorView: View {

    private enum Option: CaseIterable {
        case off
        case allDay
        case peakHours
        case customTimes
    }

    /// A time window being edited. Dates, as that's what the pickers edit, and identifiable,
    /// as windows can share times until they're merged.
    private struct EditableWindow: Identifiable {
        let id = UUID()
        var start: Date
        var end: Date

        init(_ window: NotificationScheduleWindow) {
            start = window.startTime.referenceDate
            end = window.endTime.referenceDate
        }

        var window: NotificationScheduleWindow {
            NotificationScheduleWindow(startTime: .init(start), endTime: .init(end))
        }
    }

    private let day: NotificationWeekday
    /// Called with the day's schedule and the other days to copy it to.
    private let onDone: (NotificationDaySchedule, Set<NotificationWeekday>) -> Void

    @State private var option: Option
    @State private var windows: [EditableWindow]
    @State private var otherDays: Set<NotificationWeekday> = []

    @Environment(\.dismiss) private var dismiss

    private let oneMinute: TimeInterval = 60
    private let startOfDay = NotificationTimeOfDay(hour: 0, minute: 0).referenceDate
    private let endOfDay = NotificationTimeOfDay.endOfDay.referenceDate

    init(
        day: NotificationWeekday,
        schedule: NotificationDaySchedule,
        onDone: @escaping (NotificationDaySchedule, Set<NotificationWeekday>) -> Void
    ) {
        self.day = day
        self.onDone = onDone
        switch schedule {
        case .off:
            _option = State(initialValue: .off)
            _windows = State(initialValue: [])
        case .allDay:
            _option = State(initialValue: .allDay)
            _windows = State(initialValue: [])
        case .times where schedule == .peakHours:
            _option = State(initialValue: .peakHours)
            _windows = State(initialValue: [])
        case .times(let windows):
            _option = State(initialValue: .customTimes)
            _windows = State(initialValue: windows.map(EditableWindow.init))
        }
    }

    var body: some View {
        List {
            // Checkmark rows rather than an inline Picker, which renders no options in a List here.
            Section {
                ForEach(Option.allCases, id: \.self) { option in
                    checkmarkRow(isSelected: self.option == option) {
                        self.option = option
                    } label: {
                        optionLabel(option)
                    }
                }
            }

            if option == .customTimes {
                customTimesSection
            }

            alsoApplySection
        }
        .navigationTitle(day.fullSymbol)
        .navigationBarTitleDisplayMode(.inline)
        // Back would leave it unclear whether the edits were kept, so the day is left by Cancel or Done.
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button(role: .cancel) {
                    dismiss()
                }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button(role: .confirm) {
                    onDone(schedule, otherDays)
                    dismiss()
                }
            }
        }
        .onChange(of: option) { oldOption, newOption in
            guard newOption == .customTimes, windows.isEmpty else { return }
            windows = startingWindows(from: oldOption).map(EditableWindow.init)
        }
        .animation(.default, value: option)
    }

    private var schedule: NotificationDaySchedule {
        switch option {
        case .off: .off
        case .allDay: .allDay
        case .peakHours: .peakHours
        case .customTimes: .times(windows.map(\.window))
        }
    }

    // MARK: - Options

    @ViewBuilder
    private func optionLabel(_ option: Option) -> some View {
        switch option {
        case .off:
            Text(.notificationsScheduleDayOffTitle)
        case .allDay:
            Text(.notificationsScheduleTimeSlotAllDayTitle)
        case .peakHours:
            VStack(alignment: .leading, spacing: 2) {
                Text(.notificationsScheduleTimeSlotPeakTitle)
                if let times = NotificationDaySchedule.peakHours.timesDescription {
                    Text(times)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
        case .customTimes:
            Text(.notificationsScheduleDayCustomTimesTitle)
        }
    }

    /// Switching from peak hours starts from its times, so they can be tweaked.
    private func startingWindows(from option: Option) -> [NotificationScheduleWindow] {
        if option == .peakHours, case .times(let peakWindows) = NotificationDaySchedule.peakHours {
            return peakWindows
        }
        return [
            NotificationScheduleWindow(startTime: .init(hour: 7, minute: 0), endTime: .init(hour: 9, minute: 0))
        ]
    }

    // MARK: - Custom Times

    private var customTimesSection: some View {
        Section {
            ForEach($windows) { $window in
                windowRow($window)
            }
            .onDelete { offsets in
                windows.remove(atOffsets: offsets)
            }

            Button {
                windows.append(nextWindow())
            } label: {
                Label {
                    Text(.notificationsScheduleDayAddTimeButton)
                } icon: {
                    Image(systemName: "plus")
                }
            }
        }
    }

    /// Each picker is limited by the other, so a window always ends after it starts: the API has no overnight
    /// windows.
    private func windowRow(_ window: Binding<EditableWindow>) -> some View {
        HStack {
            DatePicker(
                selection: window.start,
                in: startOfDay...window.wrappedValue.end.addingTimeInterval(-oneMinute),
                displayedComponents: .hourAndMinute
            ) {
                Text(.notificationsScheduleDayStartTimeLabel)
            }

            Image(systemName: "arrow.right")
                .foregroundStyle(.secondary)
                .accessibilityHidden(true)

            DatePicker(
                selection: window.end,
                in: window.wrappedValue.start.addingTimeInterval(oneMinute)...endOfDay,
                displayedComponents: .hourAndMinute
            ) {
                Text(.notificationsScheduleDayEndTimeLabel)
            }

            Spacer()
        }
        .labelsHidden()
    }

    /// An hour starting where the last window ends, or midday when that would run past midnight.
    private func nextWindow() -> EditableWindow {
        let oneHour: TimeInterval = 60 * 60
        let start = windows.map(\.end).max() ?? NotificationTimeOfDay(hour: 7, minute: 0).referenceDate
        let end = start.addingTimeInterval(oneHour)
        guard end <= endOfDay else {
            return EditableWindow(
                NotificationScheduleWindow(startTime: .init(hour: 12, minute: 0), endTime: .init(hour: 13, minute: 0))
            )
        }
        return EditableWindow(NotificationScheduleWindow(startTime: .init(start), endTime: .init(end)))
    }

    // MARK: - Also Apply To

    private var alsoApplySection: some View {
        Section {
            ForEach(NotificationWeekday.allCases.filter { $0 != day }, id: \.self) { otherDay in
                checkmarkRow(isSelected: otherDays.contains(otherDay)) {
                    if otherDays.contains(otherDay) {
                        otherDays.remove(otherDay)
                    } else {
                        otherDays.insert(otherDay)
                    }
                } label: {
                    Text(otherDay.fullSymbol)
                }
            }
        } header: {
            Text(.notificationsScheduleDayAlsoApplyHeader)
        }
    }

    // MARK: - Rows

    private func checkmarkRow(
        isSelected: Bool,
        action: @escaping () -> Void,
        @ViewBuilder label: () -> some View
    ) -> some View {
        Button(action: action) {
            HStack {
                label()
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark")
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.accentColor)
                }
            }
            .contentShape(Rectangle())
        }
        // Reads as a choice rather than an action.
        .tint(.primary)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}

// MARK: - Previews

#if DEBUG
    #Preview("Custom times") {
        NavigationStack {
            NotificationDayScheduleEditorView(
                day: .wednesday,
                schedule: .times([
                    .init(startTime: .init(hour: 7, minute: 0), endTime: .init(hour: 9, minute: 0)),
                    .init(startTime: .init(hour: 17, minute: 30), endTime: .init(hour: 18, minute: 30))
                ]),
                onDone: { print($0, $1) }
            )
        }
    }

    #Preview("Peak hours") {
        NavigationStack {
            NotificationDayScheduleEditorView(day: .monday, schedule: .peakHours, onDone: { print($0, $1) })
        }
    }
#endif
