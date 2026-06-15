import DataStores
import Foundation
import PresentationViews
import Shared

extension LineStatusFilterOption {
    func toLineStatusRequest(for date: Date = .now) -> LineStatusDataStore.LineStatusRequest {
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
            guard let weekendDateRange = Calendar.london.thisOrNextWeekendDateInterval(for: date) else {
                assertionFailure("Failed to calculate next weekend dates (falling back to today instead)")
                return .live
            }
            return .planned(weekendDateRange)
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
