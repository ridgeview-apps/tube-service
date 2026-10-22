import Foundation
import Models
import SwiftUI

extension NotificationTimeSlot {

    var title: LocalizedStringResource {
        switch self {
        case .peak: .notificationsScheduleTimeSlotPeakTitle
        case .allDay: .notificationsScheduleTimeSlotAllDayTitle
        }
    }

    /// e.g. "6:30–9:30 AM and 4:00–7:00 PM". `nil` for all day, whose title already says everything.
    var timesDescription: String? {
        guard !windows.isEmpty else { return nil }
        return windows.map(\.formatted).formatted(.list(type: .and))
    }
}

extension NotificationScheduleSelection {

    /// A compact one-line summary, e.g. "Mon–Fri · Peak hours".
    var summary: String {
        String(localized: .notificationsScheduleSummary(daysDescription, String(localized: timeSlot.title)))
    }

    var daysDescription: String {
        Self.daysDescription(for: days)
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
            .formatted(.list(type: .and))
    }
}

// MARK: - Formatting helpers

extension NotificationScheduleWindow {

    fileprivate var formatted: String {
        (startTime.referenceDate..<endTime.referenceDate).formatted(.interval.hour().minute())
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
