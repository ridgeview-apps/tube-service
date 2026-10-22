import Foundation
import Models
import SwiftUI

extension NotificationSchedulePreset {

    /// The picker options: the known presets, plus the current schedule when it doesn't match any of them.
    static func displayCases(including current: NotificationSchedulePreset) -> [NotificationSchedulePreset] {
        if case .custom = current {
            knownPresets + [current]
        } else {
            knownPresets
        }
    }

    var title: LocalizedStringResource {
        switch self {
        case .weekdayPeak: L10n.notificationsScheduleWeekdayPeakTitle
        case .weekdayAllDay: L10n.notificationsScheduleWeekdayAllDayTitle
        case .weekends: L10n.notificationsScheduleWeekendsTitle
        case .anytime: L10n.notificationsScheduleAnytimeTitle
        case .custom: .notificationsScheduleCustomTitle
        }
    }

    /// Derived from `schedules` so it always reflects what's sent to the server. The all-day presets' titles
    /// already say everything, so they have no description.
    var description: String? {
        switch self {
        case .weekdayPeak:
            schedules.first?.timesDescription
        case .weekdayAllDay, .weekends, .anytime:
            nil
        case .custom(let schedules):
            schedules
                .map { String(localized: .notificationsScheduleSummary($0.daysDescription, $0.timesDescription)) }
                .formatted(.list(type: .and))
        }
    }
}

// MARK: - Schedule formatting

extension NotificationSchedule {

    /// e.g. "Mon–Fri", "Mon, Wed and Sat–Sun" or "Every day".
    fileprivate var daysDescription: String {
        let sortedDays = NotificationWeekday.allCases.filter(days.contains)
        guard sortedDays.count < NotificationWeekday.allCases.count else {
            return String(localized: .notificationsScheduleEveryDay)
        }

        // Group consecutive days into runs, so Mon, Tue, Wed becomes "Mon–Wed".
        var runs: [[NotificationWeekday]] = []
        for day in sortedDays {
            if let previous = runs.last?.last, previous.index + 1 == day.index {
                runs[runs.count - 1].append(day)
            } else {
                runs.append([day])
            }
        }

        return
            runs
            .map { run in
                guard let first = run.first, let last = run.last, run.count > 1 else {
                    return run.first?.shortSymbol ?? ""
                }
                return String(localized: .notificationsScheduleRange(first.shortSymbol, last.shortSymbol))
            }
            .formatted(.list(type: .and))
    }

    /// e.g. "6:30–9:30 AM and 4:00–7:00 PM", or "all day".
    fileprivate var timesDescription: String {
        guard !allDay else { return String(localized: .notificationsScheduleAllDay) }
        return windows.map(\.formatted).formatted(.list(type: .and))
    }
}

extension NotificationScheduleWindow {

    fileprivate var formatted: String {
        let start = startTime.referenceDate
        let end = endTime.referenceDate
        guard start < end else {
            // Overnight windows can't be expressed as a `Range`, so format each end separately.
            let style = Date.FormatStyle.dateTime.hour().minute()
            return String(localized: .notificationsScheduleRange(start.formatted(style), end.formatted(style)))
        }
        return (start..<end).formatted(.interval.hour().minute())
    }
}

extension NotificationTimeOfDay {

    /// The time on a fixed, DST-free date, for formatting only.
    fileprivate var referenceDate: Date {
        let components = DateComponents(year: 2000, month: 1, day: 1, hour: hour, minute: minute)
        return Calendar.current.date(from: components) ?? .now
    }
}

extension NotificationWeekday {

    fileprivate var index: Int {
        Self.allCases.firstIndex(of: self) ?? 0
    }

    /// The locale's abbreviated weekday name, e.g. "Mon".
    fileprivate var shortSymbol: String {
        // `shortWeekdaySymbols` starts on Sunday, whereas `allCases` starts on Monday.
        Calendar.current.shortWeekdaySymbols[(index + 1) % 7]
    }
}
