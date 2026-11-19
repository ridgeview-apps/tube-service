import Foundation

/// When a line's notifications are sent: a schedule for each day of the week.
///
/// Reads any server schedules without loss, and saves days with the same schedule as one API `NotificationSchedule`.
public struct NotificationScheduleSelection: Hashable, Sendable {
    /// Days that are off have no entry, so equal schedules compare equal however they were built.
    private var daySchedules: [NotificationWeekday: NotificationDaySchedule] = [:]

    public init(_ daySchedules: [NotificationWeekday: NotificationDaySchedule]) {
        for (day, schedule) in daySchedules {
            self[day] = schedule
        }
    }

    public init(days: some Sequence<NotificationWeekday>, schedule: NotificationDaySchedule) {
        self.init(Dictionary(uniqueKeysWithValues: Set(days).map { ($0, schedule) }))
    }

    public static let `default` = NotificationSchedulePreset.weekdayPeakHours.selection

    /// Merges a day's times as they're stored, so the user sees the merged result and the API never gets overlaps.
    public subscript(day: NotificationWeekday) -> NotificationDaySchedule {
        get { daySchedules[day] ?? .off }
        set {
            let schedule = newValue.normalized
            daySchedules[day] = schedule == .off ? nil : schedule
        }
    }

    /// The API requires at least one day, so a selection with none can't be saved.
    public var hasAnyDayOn: Bool {
        !daySchedules.isEmpty
    }

    /// A day in several schedules gets all their times, or all day if any of them is all day.
    public init(schedules: [NotificationSchedule]) {
        for schedule in schedules {
            for day in schedule.days {
                switch (self[day], NotificationDaySchedule(schedule)) {
                case (.allDay, _), (_, .allDay):
                    self[day] = .allDay
                case (.times(let existing), .times(let added)):
                    self[day] = .times(existing + added)
                case (.off, let added), (let added, .off):
                    self[day] = added
                }
            }
        }
    }

    /// The days that are on, grouped by schedule. Groups are ordered by their first day, with days in week order
    /// (Mon–Sun), so the result is stable and no day is in two groups.
    public var dayGroups: [(schedule: NotificationDaySchedule, days: [NotificationWeekday])] {
        var groups: [(schedule: NotificationDaySchedule, days: [NotificationWeekday])] = []
        for day in NotificationWeekday.allCases where self[day] != .off {
            if let index = groups.firstIndex(where: { $0.schedule == self[day] }) {
                groups[index].days.append(day)
            } else {
                groups.append((self[day], [day]))
            }
        }
        return groups
    }

    /// One schedule per day group, so the payload is stable and no day is in two schedules.
    public var schedules: [NotificationSchedule] {
        dayGroups.compactMap { group in
            switch group.schedule {
            case .off: nil
            case .allDay: .allDay(group.days)
            case .times(let windows): NotificationSchedule(days: group.days, allDay: false, windows: windows)
            }
        }
    }
}

/// When notifications are sent on one day.
public enum NotificationDaySchedule: Hashable, Sendable {
    case off
    case allDay
    /// Sorted and merged once stored in a `NotificationScheduleSelection`, which treats no times as off.
    case times([NotificationScheduleWindow])

    /// TfL peak hours: 06:30–09:30 and 16:00–19:00.
    public static let peakHours = Self.times([
        NotificationScheduleWindow(startTime: .init(hour: 6, minute: 30), endTime: .init(hour: 9, minute: 30)),
        NotificationScheduleWindow(startTime: .init(hour: 16, minute: 0), endTime: .init(hour: 19, minute: 0))
    ])

    /// Ignores any windows sent alongside `all_day`.
    init(_ schedule: NotificationSchedule) {
        self = schedule.allDay ? .allDay : .times(schedule.windows)
    }

    /// The API rejects overlapping or duplicate windows, so they're merged, along with adjacent ones.
    /// Empty and backwards windows are dropped, because the API rejects those too.
    var normalized: Self {
        guard case .times(let windows) = self else { return self }

        var merged: [NotificationScheduleWindow] = []
        for window in windows.filter({ $0.startTime < $0.endTime }).sorted(by: { $0.startTime < $1.startTime }) {
            if let last = merged.last, window.startTime <= last.endTime {
                merged[merged.count - 1] = NotificationScheduleWindow(
                    startTime: last.startTime,
                    endTime: max(last.endTime, window.endTime)
                )
            } else {
                merged.append(window)
            }
        }
        return merged.isEmpty ? .off : .times(merged)
    }
}

/// The common schedules, offered by name. Matched by equality, so a custom schedule that happens to equal
/// one is shown as that preset.
public enum NotificationSchedulePreset: Hashable, Sendable, CaseIterable {
    case weekdayPeakHours
    case weekdaysAllDay
    case everyDayPeakHours
    case everyDayAllDay

    public var selection: NotificationScheduleSelection {
        switch self {
        case .weekdayPeakHours: .init(days: NotificationWeekday.weekdays, schedule: .peakHours)
        case .weekdaysAllDay: .init(days: NotificationWeekday.weekdays, schedule: .allDay)
        case .everyDayPeakHours: .init(days: NotificationWeekday.allCases, schedule: .peakHours)
        case .everyDayAllDay: .init(days: NotificationWeekday.allCases, schedule: .allDay)
        }
    }

    public init?(matching selection: NotificationScheduleSelection) {
        guard let preset = Self.allCases.first(where: { $0.selection == selection }) else { return nil }
        self = preset
    }
}

extension NotificationWeekday {
    public static let weekdays: [NotificationWeekday] = [.monday, .tuesday, .wednesday, .thursday, .friday]
    public static let weekend: [NotificationWeekday] = [.saturday, .sunday]
}
