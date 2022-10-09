import Foundation

public extension Calendar {
    
    static func iso8601(in timeZone: TimeZone) -> Calendar {
        var calendar = Calendar(identifier: .iso8601)
        calendar.timeZone = timeZone
        return calendar
    }
    
    // ISO8601 calendar fixed with the London time zone (which adjusts for daylight savings).
    // This is DELIBERATE, not a date hack just to suit a majority of UK-based users. The tube itself is in London
    // hence date calculations are generally all relative to the London time zone (NOT the device's local time).
    // For example, a date picker where the user can select line statuses for tomorrow - tomorrow's "Date"
    // means the start of day in LONDON (not start of day in the user's local time zone).
    static let london: Calendar = iso8601(in: .london)
    
    func thisOrNextWeekendDateInterval(for date: Date = .now) -> DateInterval? {
        dateIntervalOfWeekend(containing: date) ?? nextWeekend(startingAfter: date)
    }
    
    func startOfNextDay(after date: Date) -> Date? {
        let startOfDay = Calendar.london.startOfDay(for: date)
        return Calendar.london.date(byAdding: .day, value: 1, to: startOfDay)
    }
    
    func startOfTomorrow() -> Date? {
        startOfNextDay(after: .now)
    }
}
