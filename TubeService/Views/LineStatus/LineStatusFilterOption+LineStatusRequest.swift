import DataStores
import Foundation
import PresentationViews
import Shared

extension LineStatusFilterOption {
    /// - Parameters:
    ///   - date: The date picked for `.future` (other options ignore it).
    ///   - now: The current time, which `.today`, `.tomorrow` and `.thisWeekend` are relative to.
    func toLineStatusRequest(
        for date: Date,
        weekendDayFilter: WeekendDayFilter = .both,
        now: Date
    ) -> LineStatusDataStore.LineStatusRequest {
        switch self {
        case .today:
            return .live
        case .tomorrow:
            guard let startDate = Calendar.london.startOfNextDay(after: now),
                let endDate = Calendar.london.startOfNextDay(after: startDate)
            else {
                assertionFailure("Failed to calculate tomorrow's date range (falling back to today instead)")
                return .live
            }
            return .planned(.init(start: startDate, end: endDate))
        case .thisWeekend:
            // "This weekend" is always relative to today, never the future-date selection.
            guard let weekendInterval = Calendar.london.weekendInterval(onOrAfter: now) else {
                assertionFailure("Failed to calculate next weekend dates (falling back to today instead)")
                return .live
            }
            switch weekendDayFilter {
            case .both:
                return .planned(weekendInterval)
            case .saturday:
                guard let endOfSaturday = Calendar.london.startOfNextDay(after: weekendInterval.start) else {
                    return .planned(weekendInterval)
                }
                return .planned(.init(start: weekendInterval.start, end: endOfSaturday))
            case .sunday:
                guard let startOfSunday = Calendar.london.startOfNextDay(after: weekendInterval.start) else {
                    return .planned(weekendInterval)
                }
                return .planned(.init(start: startOfSunday, end: weekendInterval.end))
            }
        case .future:
            if Calendar.london.isDate(date, inSameDayAs: now) {
                return .live
            }
            guard let endDate = Calendar.london.startOfNextDay(after: date) else {
                assertionFailure("Failed to calculate next day - falling back to today instead")
                return .live
            }
            return .planned(.init(start: date, end: endDate))
        }
    }
}
