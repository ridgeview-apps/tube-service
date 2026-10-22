import Models

public struct LineNotificationSettings: Hashable, Sendable, Identifiable {
    public var id: TrainLineID { lineID }

    public let lineID: TrainLineID
    public var isEnabled: Bool
    public var schedule: NotificationScheduleSelection

    public init(
        lineID: TrainLineID,
        isEnabled: Bool,
        schedule: NotificationScheduleSelection
    ) {
        self.lineID = lineID
        self.isEnabled = isEnabled
        self.schedule = schedule
    }

    public static func defaultValue(
        lineID: TrainLineID,
        isEnabled: Bool = true,
        schedule: NotificationScheduleSelection = .default
    ) -> Self {
        .init(
            lineID: lineID,
            isEnabled: isEnabled,
            schedule: schedule
        )
    }
}
