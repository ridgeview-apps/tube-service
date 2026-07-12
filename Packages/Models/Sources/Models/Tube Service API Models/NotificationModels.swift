import Foundation

// MARK: - Push Notification Payload

public struct LineStatusNotificationPayload: Sendable {

    public enum EventType: String, Sendable {
        case disruptionStarted = "disruption_started"
        case disruptionChanged = "disruption_changed"
        case serviceResumed = "service_resumed"
    }

    public let lineID: TrainLineID
    /// `nil` when the server sends an event type not recognised by this client version.
    public let eventType: EventType?
    public let severity: LineStatusSeverity

    public init(lineID: TrainLineID, eventType: EventType?, severity: LineStatusSeverity) {
        self.lineID = lineID
        self.eventType = eventType
        self.severity = severity
    }

    public init?(userInfo: [AnyHashable: Any]) {
        guard
            let lineIDString = userInfo["line_id"] as? String,
            let lineID = TrainLineID(rawValue: lineIDString),
            let severityInt = userInfo["severity"] as? Int,
            let severity = LineStatusSeverity(rawValue: severityInt)
        else { return nil }
        self.lineID = lineID
        self.severity = severity
        self.eventType = (userInfo["event_type"] as? String).flatMap(EventType.init(rawValue:))
    }
}

// MARK: -

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
    case monday = "mon"
    case tuesday = "tue"
    case wednesday = "wed"
    case thursday = "thu"
    case friday = "fri"
    case saturday = "sat"
    case sunday = "sun"
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
    public let appVariant: String?
    public let createdAt: Date
    public let updatedAt: Date
    public let lastSeenAt: Date

    public init(
        deviceId: String,
        platform: String,
        enabled: Bool,
        appVersion: String?,
        appVariant: String?,
        createdAt: Date,
        updatedAt: Date,
        lastSeenAt: Date
    ) {
        self.deviceId = deviceId
        self.platform = platform
        self.enabled = enabled
        self.appVersion = appVersion
        self.appVariant = appVariant
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.lastSeenAt = lastSeenAt
    }
}

public struct NotificationLinePreference: Codable, Hashable, Sendable {
    public let lineId: String
    public let enabled: Bool
    public let severityThreshold: NotificationSeverityThreshold
    public let notifyRecoveries: Bool
    public let schedulePreset: NotificationSchedulePreset
    public let customSchedules: [NotificationScheduleWindow]

    public init(
        lineId: String,
        enabled: Bool,
        severityThreshold: NotificationSeverityThreshold,
        notifyRecoveries: Bool,
        schedulePreset: NotificationSchedulePreset,
        customSchedules: [NotificationScheduleWindow]
    ) {
        self.lineId = lineId
        self.enabled = enabled
        self.severityThreshold = severityThreshold
        self.notifyRecoveries = notifyRecoveries
        self.schedulePreset = schedulePreset
        self.customSchedules = customSchedules
    }
}

public struct NotificationPreferences: Codable, Hashable, Sendable {
    public let deviceId: String
    public let timezone: String
    public let lines: [NotificationLinePreference]
    public let createdAt: Date
    public let updatedAt: Date

    public init(
        deviceId: String,
        timezone: String = "Europe/London",
        lines: [NotificationLinePreference],
        createdAt: Date,
        updatedAt: Date
    ) {
        self.deviceId = deviceId
        self.timezone = timezone
        self.lines = lines
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

public struct NotificationLinePreferenceUpdate: Codable, Hashable, Sendable {
    public let lineId: String
    public let enabled: Bool
    public let notifyRecoveries: Bool
    public let schedulePreset: NotificationSchedulePreset
    public let severityThreshold: NotificationSeverityThreshold
    public let customSchedules: [NotificationScheduleWindow]

    public init(
        lineId: String,
        enabled: Bool,
        notifyRecoveries: Bool,
        schedulePreset: NotificationSchedulePreset,
        severityThreshold: NotificationSeverityThreshold,
        customSchedules: [NotificationScheduleWindow]
    ) {
        self.lineId = lineId
        self.enabled = enabled
        self.notifyRecoveries = notifyRecoveries
        self.schedulePreset = schedulePreset
        self.severityThreshold = severityThreshold
        self.customSchedules = customSchedules
    }
}

public struct NotificationPreferencesUpdate: Codable, Hashable, Sendable {
    public let timezone: String?
    public let lines: [NotificationLinePreferenceUpdate]

    public init(
        timezone: String? = nil,
        lines: [NotificationLinePreferenceUpdate]
    ) {
        self.timezone = timezone
        self.lines = lines
    }
}

public struct NotificationState: Codable, Sendable {
    public var device: NotificationDevice?
    public var preferences: NotificationPreferences?
    public var hasCompletedOnboarding: Bool
    public var hasUserDeletedDevice: Bool

    public static let `default` = NotificationState(device: nil, preferences: nil, hasCompletedOnboarding: false)

    public init(
        device: NotificationDevice?,
        preferences: NotificationPreferences?,
        hasCompletedOnboarding: Bool,
        hasUserDeletedDevice: Bool = false
    ) {
        self.device = device
        self.preferences = preferences
        self.hasCompletedOnboarding = hasCompletedOnboarding
        self.hasUserDeletedDevice = hasUserDeletedDevice
    }
}
