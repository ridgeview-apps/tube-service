import DataStores
import Models
import Observation
import PresentationViews

extension LineNotificationSettings {
    func toNotificationLinePreferenceUpdate() -> NotificationLinePreferenceUpdate {
        NotificationLinePreferenceUpdate(
            lineId: lineID.rawValue,
            enabled: isEnabled,
            notifyRecoveries: notifyRecoveries,
            schedulePreset: schedulePreset,
            severityThreshold: .minorDelays,
            customSchedules: []
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
