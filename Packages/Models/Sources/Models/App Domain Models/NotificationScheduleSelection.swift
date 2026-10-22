import Foundation

/// When a line's alerts are sent: a set of days, with the same time slot on each of them.
///
/// Always maps to exactly one API `NotificationSchedule`. Server schedules that can't be expressed this way
/// (several schedules, or windows other than peak hours) fall back to `.default`.
public struct NotificationScheduleSelection: Hashable, Sendable {
    /// Never empty in practice: the API requires at least one day, so the UI won't deselect the last one.
    public var days: Set<NotificationWeekday>
    public var timeSlot: NotificationTimeSlot

    public init(days: Set<NotificationWeekday>, timeSlot: NotificationTimeSlot) {
        self.days = days
        self.timeSlot = timeSlot
    }

    public static let `default` = NotificationScheduleSelection(days: Set(NotificationWeekday.weekdays), timeSlot: .peak)

    public init(schedules: [NotificationSchedule]) {
        guard
            schedules.count == 1,
            let schedule = schedules.first,
            !schedule.days.isEmpty,
            let timeSlot = NotificationTimeSlot(schedule: schedule)
        else {
            self = .default
            return
        }
        self.init(days: Set(schedule.days), timeSlot: timeSlot)
    }

    /// Days are sent in week order (Mon–Sun) so the payload is stable.
    public var schedule: NotificationSchedule {
        NotificationSchedule(
            days: NotificationWeekday.allCases.filter(days.contains),
            allDay: timeSlot == .allDay,
            windows: timeSlot.windows
        )
    }
}

public enum NotificationTimeSlot: Hashable, Sendable, CaseIterable {
    /// TfL peak hours: 06:30–09:30 and 16:00–19:00.
    case peak
    case allDay

    public var windows: [NotificationScheduleWindow] {
        switch self {
        case .peak:
            [
                NotificationScheduleWindow(startTime: .init(hour: 6, minute: 30), endTime: .init(hour: 9, minute: 30)),
                NotificationScheduleWindow(startTime: .init(hour: 16, minute: 0), endTime: .init(hour: 19, minute: 0))
            ]
        case .allDay:
            []
        }
    }

    /// Matches regardless of window order, and ignores any windows sent alongside `all_day`.
    init?(schedule: NotificationSchedule) {
        if schedule.allDay {
            self = .allDay
        } else if Set(schedule.windows) == Set(Self.peak.windows), schedule.windows.count == Self.peak.windows.count {
            self = .peak
        } else {
            return nil
        }
    }
}

extension NotificationWeekday {
    public static let weekdays: [NotificationWeekday] = [.monday, .tuesday, .wednesday, .thursday, .friday]
    public static let weekend: [NotificationWeekday] = [.saturday, .sunday]
}
