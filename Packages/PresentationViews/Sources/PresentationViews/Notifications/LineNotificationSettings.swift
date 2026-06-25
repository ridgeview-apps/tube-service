import Models

public struct LineNotificationSettings: Equatable, Sendable {
    public var isEnabled: Bool
    public var schedulePreset: NotificationSchedulePreset
    public var notifyRecoveries: Bool

    public init(
        isEnabled: Bool = true,
        schedulePreset: NotificationSchedulePreset = .weekdayPeak,
        notifyRecoveries: Bool = true
    ) {
        self.isEnabled = isEnabled
        self.schedulePreset = schedulePreset
        self.notifyRecoveries = notifyRecoveries
    }
}
