import DataStores
import Models
import Observation
import PresentationViews

// Recovery alerts and the severity threshold aren't user-configurable, so every line uses these.
private let defaultNotifyRecoveries = true
private let defaultSeverityThreshold = NotificationSeverityThreshold.minorDelays

extension LineNotificationSettings {
    func toNotificationLinePreferenceUpdate() -> NotificationLinePreferenceUpdate {
        NotificationLinePreferenceUpdate(
            lineId: lineID.rawValue,
            enabled: isEnabled,
            notifyRecoveries: defaultNotifyRecoveries,
            severityThreshold: defaultSeverityThreshold,
            schedules: [schedule.schedule]
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

extension NotificationPreferencesPatch {

    /// Pauses or resumes a line without touching any of its other fields.
    static func setEnabled(_ isEnabled: Bool, for lineID: TrainLineID) -> Self {
        .init(lines: [lineID.rawValue: NotificationLinePreferencePatch(enabled: isEnabled)])
    }

    /// Saves only the fields the user can edit, so an existing line keeps any others it has on the server.
    static func update(_ settings: LineNotificationSettings) -> Self {
        .init(lines: [
            settings.lineID.rawValue: NotificationLinePreferencePatch(
                enabled: settings.isEnabled,
                schedules: [settings.schedule.schedule]
            )
        ])
    }

    /// Adds a line with every field set, as the API requires for a line it doesn't have yet.
    static func add(_ settings: LineNotificationSettings) -> Self {
        .init(lines: [
            settings.lineID.rawValue: NotificationLinePreferencePatch(
                enabled: settings.isEnabled,
                severityThreshold: defaultSeverityThreshold,
                notifyRecoveries: defaultNotifyRecoveries,
                schedules: [settings.schedule.schedule]
            )
        ])
    }

    static func remove(_ lineID: TrainLineID) -> Self {
        .init(lines: [lineID.rawValue: nil])
    }
}
