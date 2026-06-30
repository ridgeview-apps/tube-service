import Models

public struct LineNotificationSettings: Hashable, Sendable, Identifiable {
    public var id: TrainLineID { lineID }

    public let lineID: TrainLineID
    public var isEnabled: Bool
    public var schedulePreset: NotificationSchedulePreset
    public var notifyRecoveries: Bool

    public init(
        lineID: TrainLineID,
        isEnabled: Bool,
        schedulePreset: NotificationSchedulePreset,
        notifyRecoveries: Bool
    ) {
        self.lineID = lineID
        self.isEnabled = isEnabled
        self.schedulePreset = schedulePreset
        self.notifyRecoveries = notifyRecoveries
    }

    public static func defaultValue(
        lineID: TrainLineID,
        isEnabled: Bool = true,
        schedulePreset: NotificationSchedulePreset = .weekdayPeak,
        notifyRecoveries: Bool = true
    ) -> Self {
        .init(
            lineID: lineID,
            isEnabled: isEnabled,
            schedulePreset: schedulePreset,
            notifyRecoveries: notifyRecoveries
        )
    }
}
