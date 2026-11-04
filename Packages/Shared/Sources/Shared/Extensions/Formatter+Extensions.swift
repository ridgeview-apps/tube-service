import Foundation

/// Formats dates like a `DateFormatter` with `doesRelativeDateFormatting` (e.g. "today, 11:23"), but relative to a
/// given time instead of the system clock, so a fixed clock (e.g. in UI tests) gives the same text.
public struct RelativeDateFormatter {

    private let calendar: Calendar
    private let absoluteFormatter: DateFormatter
    private let dateOnlyFormatter: DateFormatter
    private let dayFormatter: RelativeDateTimeFormatter

    public init(
        dateStyle: DateFormatter.Style,
        timeStyle: DateFormatter.Style,
        context: Formatter.Context = .standalone,
        locale: Locale = .current,
        timeZone: TimeZone = .current
    ) {
        var calendar = Calendar.current
        calendar.locale = locale
        calendar.timeZone = timeZone
        self.calendar = calendar

        absoluteFormatter = DateFormatter()
        dateOnlyFormatter = DateFormatter()
        for formatter in [absoluteFormatter, dateOnlyFormatter] {
            formatter.locale = locale
            formatter.timeZone = timeZone
            formatter.dateStyle = dateStyle
            formatter.formattingContext = context
        }
        absoluteFormatter.timeStyle = timeStyle
        dateOnlyFormatter.timeStyle = .none

        dayFormatter = RelativeDateTimeFormatter()
        dayFormatter.locale = locale
        dayFormatter.calendar = calendar
        dayFormatter.dateTimeStyle = .named
        dayFormatter.formattingContext = context
    }

    public func string(from date: Date, relativeTo now: Date) -> String {
        let absolute = absoluteFormatter.string(from: date)
        guard
            let dayOffset = calendar.dateComponents(
                [.day],
                from: calendar.startOfDay(for: now),
                to: calendar.startOfDay(for: date)
            ).day,
            (-1...1).contains(dayOffset),
            // Swaps the date for "today", "yesterday" or "tomorrow", keeping the locale's own layout of date and time.
            let dateRange = absolute.range(of: dateOnlyFormatter.string(from: date))
        else {
            return absolute
        }
        let dayName = dayFormatter.localizedString(from: DateComponents(day: dayOffset))
        return absolute.replacingCharacters(in: dateRange, with: dayName)
    }
}

public extension Formatter {

    static let fullDateStyle: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .none
        return formatter
    }()

    static let longDateStyle: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()

    static let shortTimeStyle: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter
    }()
}

public extension DateIntervalFormatter {
    static let longDateIntervalStyle: DateIntervalFormatter = {
        let formatter = DateIntervalFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
}
