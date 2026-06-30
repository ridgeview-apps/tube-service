import DataStores
import Models
import Observation
import PresentationViews

extension NotificationLinePreference {
    func toLineNotificationSettings() -> LineNotificationSettings? {
        guard let trainLineID = TrainLineID(rawValue: lineId) else {
            assertionFailure("Invalid train line ID \(String(describing: lineId)) detected")
            return nil
        }
        return LineNotificationSettings(
            lineID: trainLineID,
            isEnabled: enabled,
            schedulePreset: schedulePreset,
            notifyRecoveries: notifyRecoveries
        )
    }
}

extension [NotificationLinePreference] {

    func toLineNotificationSettings() -> [LineNotificationSettings] {
        self.compactMap { $0.toLineNotificationSettings() }
    }
}
