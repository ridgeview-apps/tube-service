import DataStores
import Models
import Observation
import PresentationViews

extension LineNotificationSettings {
    func toNotificationLinePreferenceUpdate() -> NotificationLinePreferenceUpdate {
        NotificationLinePreferenceUpdate(
            lineId: lineID.rawValue,
            enabled: isEnabled,
            // Recovery alerts aren't user-configurable, so they're always on.
            notifyRecoveries: true,
            severityThreshold: .minorDelays,
            schedules: schedulePreset.schedules
        )
    }
}

extension [LineNotificationSettings] {

    func toNotificationPreferencesUpdate() -> NotificationPreferencesUpdate {
        .init(
            lines: self.map { $0.toNotificationLinePreferenceUpdate() }
        )
    }
}
