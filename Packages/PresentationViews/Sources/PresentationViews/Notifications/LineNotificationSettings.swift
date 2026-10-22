import Models

public struct LineNotificationSettings: Hashable, Sendable, Identifiable {
    public var id: TrainLineID { lineID }

    public let lineID: TrainLineID
    public var isEnabled: Bool
    public var schedulePreset: NotificationSchedulePreset

    public init(
        lineID: TrainLineID,
        isEnabled: Bool,
        schedulePreset: NotificationSchedulePreset
    ) {
        self.lineID = lineID
        self.isEnabled = isEnabled
        self.schedulePreset = schedulePreset
    }

    public static func defaultValue(
        lineID: TrainLineID,
        isEnabled: Bool = true,
        schedulePreset: NotificationSchedulePreset = .weekdayPeak
    ) -> Self {
        .init(
            lineID: lineID,
            isEnabled: isEnabled,
            schedulePreset: schedulePreset
        )
    }
}
