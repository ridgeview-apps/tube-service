import Foundation

public enum NotificationSchedulePreset: String, Codable, CaseIterable, Hashable, Sendable {
    case anytime
    case weekdayPeak = "weekday_peak"
    case weekdayAllDay = "weekday_all_day"
    case weekends
    case custom
}

public enum NotificationSeverityThreshold: String, Codable, CaseIterable, Hashable, Sendable {
    case minorDelays = "minor_delays"
    case severeDelays = "severe_delays"
    case suspended
}

public enum NotificationWeekday: String, Codable, CaseIterable, Hashable, Sendable {
    case monday, tuesday, wednesday, thursday, friday, saturday, sunday
}

public struct NotificationScheduleWindow: Codable, Hashable, Sendable {
    public let days: [NotificationWeekday]
    public let startTime: String
    public let endTime: String

    public init(days: [NotificationWeekday], startTime: String, endTime: String) {
        self.days = days
        self.startTime = startTime
        self.endTime = endTime
    }
}

public struct NotificationDevice: Codable, Hashable, Sendable {
    public let deviceId: String
    public let platform: String
    public let enabled: Bool
    public let appVersion: String?
    public let createdAt: Date
    public let updatedAt: Date
    public let lastSeenAt: Date

    public init(
        deviceId: String,
        platform: String,
        enabled: Bool,
        appVersion: String?,
        createdAt: Date,
        updatedAt: Date,
        lastSeenAt: Date
    ) {
        self.deviceId = deviceId
        self.platform = platform
        self.enabled = enabled
        self.appVersion = appVersion
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.lastSeenAt = lastSeenAt
    }
}

public struct NotificationPreferences: Codable, Hashable, Sendable {
    public let deviceId: String
    public let enabled: Bool
    public let lineIds: [String]
    public let severityThreshold: NotificationSeverityThreshold
    public let notifyRecoveries: Bool
    public let schedulePreset: NotificationSchedulePreset
    public let customSchedules: [NotificationScheduleWindow]
    public let createdAt: Date
    public let updatedAt: Date

    public init(
        deviceId: String,
        enabled: Bool,
        lineIds: [String],
        severityThreshold: NotificationSeverityThreshold,
        notifyRecoveries: Bool,
        schedulePreset: NotificationSchedulePreset,
        customSchedules: [NotificationScheduleWindow],
        createdAt: Date,
        updatedAt: Date
    ) {
        self.deviceId = deviceId
        self.enabled = enabled
        self.lineIds = lineIds
        self.severityThreshold = severityThreshold
        self.notifyRecoveries = notifyRecoveries
        self.schedulePreset = schedulePreset
        self.customSchedules = customSchedules
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

public struct NotificationPreferencesUpdate: Codable, Hashable, Sendable {
    public let enabled: Bool
    public let lineIds: [String]
    public let severityThreshold: NotificationSeverityThreshold
    public let notifyRecoveries: Bool
    public let schedulePreset: NotificationSchedulePreset
    public let customSchedules: [NotificationScheduleWindow]

    public init(
        enabled: Bool = true,
        lineIds: [String],
        severityThreshold: NotificationSeverityThreshold = .minorDelays,
        notifyRecoveries: Bool = true,
        schedulePreset: NotificationSchedulePreset = .weekdayPeak,
        customSchedules: [NotificationScheduleWindow] = []
    ) {
        self.enabled = enabled
        self.lineIds = lineIds
        self.severityThreshold = severityThreshold
        self.notifyRecoveries = notifyRecoveries
        self.schedulePreset = schedulePreset
        self.customSchedules = customSchedules
    }
}
