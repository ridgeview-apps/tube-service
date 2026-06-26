import Models
import SwiftUI

extension NotificationSchedulePreset {

    static let allDisplayCases: [NotificationSchedulePreset] = [
        .weekdayPeak, .weekdayAllDay, .weekends, .anytime
    ]

    var title: LocalizedStringResource {
        switch self {
        case .weekdayPeak: L10n.notificationsScheduleWeekdayPeakTitle
        case .weekdayAllDay: L10n.notificationsScheduleWeekdayAllDayTitle
        case .weekends: L10n.notificationsScheduleWeekendsTitle
        case .anytime: L10n.notificationsScheduleAnytimeTitle
        case .custom: L10n.notificationsScheduleAnytimeTitle
        }
    }

    var description: LocalizedStringResource? {
        switch self {
        case .weekdayPeak: L10n.notificationsScheduleWeekdayPeakDescription
        default: nil
        }
    }
}
