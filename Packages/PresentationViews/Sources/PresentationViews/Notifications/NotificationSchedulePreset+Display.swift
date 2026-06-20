import Models
import SwiftUI

extension NotificationSchedulePreset {

    var title: LocalizedStringResource {
        switch self {
        case .weekdayPeak: L10n.notificationsScheduleWeekdayPeakTitle
        case .weekdayAllDay: L10n.notificationsScheduleWeekdayAllDayTitle
        case .weekends: L10n.notificationsScheduleWeekendsTitle
        case .anytime: L10n.notificationsScheduleAnytimeTitle
        case .custom: L10n.notificationsScheduleAnytimeTitle
        }
    }

    var systemImage: String {
        switch self {
        case .weekdayPeak: "person.2.wave.2"
        case .weekdayAllDay: "sun.max"
        case .weekends: "calendar"
        case .anytime: "bell.fill"
        case .custom: "slider.horizontal.3"
        }
    }
}
