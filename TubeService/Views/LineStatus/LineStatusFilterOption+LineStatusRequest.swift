import DataStores
import Foundation
import PresentationViews
import Shared

extension LineStatusFilterOption {
    func toLineStatusRequest(
        for date: Date = .now,
        weekendDayFilter: WeekendDayFilter = .both
    ) -> LineStatusDataStore.LineStatusRequest {
        switch self {
        case .today:
            return .live
        case .tomorrow:
            guard let startDate = Calendar.london.startOfTomorrow(),
                let endDate = Calendar.london.startOfNextDay(after: startDate)
            else {
                assertionFailure("Failed to calculate tomorrow's date range (falling back to today instead)")
                return .live
            }
            return .planned(.init(start: startDate, end: endDate))
        case .thisWeekend:
            guard let weekendInterval = Calendar.london.thisOrNextWeekendDateInterval(for: date) else {
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
            if Calendar.london.isDateInToday(date) {
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
