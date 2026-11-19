import Foundation
import Models
import SwiftUI

extension NotificationSchedulePreset {

    var title: LocalizedStringResource {
        switch self {
        case .weekdaysPeakHours: .notificationsSchedulePresetWeekdaysPeakHours
        case .weekdaysAllDay: .notificationsSchedulePresetWeekdaysAllDay
        case .everyDayAllDay: .notificationsSchedulePresetEveryDayAllDay
        }
    }

    /// The peak times, one window per line so a range never wraps. `nil` for all-day presets, as the title
    /// already says everything.
    var timesDescription: String? {
        switch self {
        case .weekdaysPeakHours: NotificationDaySchedule.peakHours.timesLines
        case .weekdaysAllDay, .everyDayAllDay: nil
        }
    }
}

extension NotificationDaySchedule {

    /// e.g. "Off", "Peak hours" or "7:00–9:00 AM".
    var summary: String {
        if self == .peakHours {
            String(localized: .notificationsScheduleTimeSlotPeakTitle)
        } else if let timesDescription {
            timesDescription
        } else if self == .allDay {
            String(localized: .notificationsScheduleTimeSlotAllDayTitle)
        } else {
            String(localized: .notificationsScheduleDayOffTitle)
        }
    }

    /// e.g. "6:30–9:30 AM and 4:00–7:00 PM". `nil` unless there are times, as the title already says everything.
    var timesDescription: String? {
        guard case .times(let windows) = self, !windows.isEmpty else { return nil }
        return windows.map(\.formatted).formatted(.list(type: .and).locale(.copy))
    }

    /// e.g. "6:30–9:30 AM" and "4:00–7:00 PM" on separate lines. `nil` unless there are times.
    var timesLines: String? {
        guard case .times(let windows) = self, !windows.isEmpty else { return nil }
        return windows.map(\.formatted).joined(separator: "\n")
    }
}

extension NotificationScheduleSelection {

    var preset: NotificationSchedulePreset? {
        NotificationSchedulePreset(matching: self)
    }

    /// The preset's name, or a line per group of days that share a schedule, e.g. "Mon–Fri · Peak hours".
    var summary: String {
        if let preset {
            return String(localized: preset.title)
        }
        return
            dayGroups
            .map { group in
                String(
                    localized: .notificationsScheduleSummary(
                        Self.daysDescription(for: Set(group.days)),
                        group.schedule.summary
                    )
                )
            }
            .joined(separator: "\n")
    }

    /// e.g. "Mon–Fri", "Mon, Wed and Sat–Sun" or "Every day".
    static func daysDescription(for days: Set<NotificationWeekday>) -> String {
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
            .formatted(.list(type: .and).locale(.copy))
    }
}

// MARK: - Formatting helpers

extension NotificationScheduleWindow {

    fileprivate var formatted: String {
        (startTime.referenceDate..<endTime.referenceDate).formatted(.interval.hour().minute())
    }
}

extension NotificationTimeOfDay {

    /// The latest time a window can end, as windows can't run past midnight.
    static let endOfDay = Self(hour: 23, minute: 59)

    /// The time from a date picker, which edits `referenceDate`.
    init(_ date: Date) {
        let components = Calendar.current.dateComponents([.hour, .minute], from: date)
        self.init(hour: components.hour ?? 0, minute: components.minute ?? 0)
    }

    /// The time on a fixed, DST-free date, for formatting and date pickers.
    var referenceDate: Date {
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
        Calendar.current.shortWeekdaySymbols[calendarSymbolIndex]
    }

    /// The locale's full weekday name, e.g. "Monday".
    var fullSymbol: String {
        Calendar.current.weekdaySymbols[calendarSymbolIndex]
    }

    /// `Calendar`'s weekday symbols start on Sunday, whereas `allCases` starts on Monday.
    private var calendarSymbolIndex: Int {
        (index + 1) % 7
    }
}
