import Foundation

/// A client-side shorthand for a set of notification schedules.
///
/// The API only deals in raw schedules, so the presets' days and windows are defined here. Schedules that
/// don't match a known preset are preserved as `.custom` so they survive a fetch–edit–save round trip.
public enum NotificationSchedulePreset: Hashable, Sendable {
    case weekdayPeak
    case weekdayAllDay
    case weekends
    case anytime
    case custom([NotificationSchedule])

    public static let knownPresets: [NotificationSchedulePreset] = [
        .weekdayPeak, .weekdayAllDay, .weekends, .anytime
    ]

    public init(schedules: [NotificationSchedule]) {
        let normalised = Set(schedules.map(\.normalised))
        self =
            Self.knownPresets.first { Set($0.schedules.map(\.normalised)) == normalised }
            ?? .custom(schedules)
    }

    public var schedules: [NotificationSchedule] {
        switch self {
        case .weekdayPeak:
            [
                NotificationSchedule(
                    days: NotificationWeekday.weekdays,
                    allDay: false,
                    windows: [
                        NotificationScheduleWindow(
                            startTime: .init(hour: 6, minute: 30),
                            endTime: .init(hour: 9, minute: 30)
                        ),
                        NotificationScheduleWindow(
                            startTime: .init(hour: 16, minute: 0),
                            endTime: .init(hour: 19, minute: 0)
                        )
                    ]
                )
            ]
        case .weekdayAllDay:
            [.allDay(NotificationWeekday.weekdays)]
        case .weekends:
            [.allDay(NotificationWeekday.weekend)]
        case .anytime:
            [.allDay(NotificationWeekday.allCases)]
        case .custom(let schedules):
            schedules
        }
    }
}

extension NotificationWeekday {
    public static let weekdays: [NotificationWeekday] = [.monday, .tuesday, .wednesday, .thursday, .friday]
    public static let weekend: [NotificationWeekday] = [.saturday, .sunday]
}

extension NotificationSchedule {
    /// A canonical form for equivalence checks: days and windows sorted, and windows dropped when `allDay`.
    fileprivate var normalised: NotificationSchedule {
        NotificationSchedule(
            days: NotificationWeekday.allCases.filter(days.contains),
            allDay: allDay,
            windows: allDay ? [] : windows.sorted { ($0.startTime, $0.endTime) < ($1.startTime, $1.endTime) }
        )
    }
}
