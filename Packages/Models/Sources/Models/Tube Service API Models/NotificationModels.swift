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

/// A wall-clock time in the preferences' timezone, sent over the wire as `HH:mm`.
public struct NotificationTimeOfDay: Hashable, Comparable, Sendable {
    public let hour: Int
    public let minute: Int

    public init(hour: Int, minute: Int) {
        self.hour = hour
        self.minute = minute
    }

    public static func < (lhs: Self, rhs: Self) -> Bool {
        (lhs.hour, lhs.minute) < (rhs.hour, rhs.minute)
    }
}

extension NotificationTimeOfDay: Codable {
    public init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        let string = try container.decode(String.self)
        // Accepts `HH:MM`, `HH:MM:SS` and `HH:MM:SS.ffffff`; seconds are ignored.
        let components = string.split(separator: ":")
        guard
            components.count >= 2,
            let hour = Int(components[0]), (0..<24).contains(hour),
            let minute = Int(components[1]), (0..<60).contains(minute)
        else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid time of day: \(string)")
        }
        self.init(hour: hour, minute: minute)
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(String(format: "%02d:%02d", hour, minute))
    }
}

public struct NotificationScheduleWindow: Codable, Hashable, Sendable {
    public let startTime: NotificationTimeOfDay
    public let endTime: NotificationTimeOfDay

    public init(startTime: NotificationTimeOfDay, endTime: NotificationTimeOfDay) {
        self.startTime = startTime
        self.endTime = endTime
    }
}

public struct NotificationSchedule: Codable, Hashable, Sendable {
    public let days: [NotificationWeekday]
    public let allDay: Bool
    /// Always empty when `allDay` is `true`.
    public let windows: [NotificationScheduleWindow]

    public init(days: [NotificationWeekday], allDay: Bool, windows: [NotificationScheduleWindow]) {
        self.days = days
        self.allDay = allDay
        self.windows = windows
    }

    public static func allDay(_ days: [NotificationWeekday]) -> Self {
        .init(days: days, allDay: true, windows: [])
    }

    private enum CodingKeys: String, CodingKey {
        case days, allDay, windows
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        days = try container.decode([NotificationWeekday].self, forKey: .days)
        allDay = try container.decodeIfPresent(Bool.self, forKey: .allDay) ?? false
        windows = try container.decodeIfPresent([NotificationScheduleWindow].self, forKey: .windows) ?? []
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
    public let schedules: [NotificationSchedule]

    public init(
        lineId: String,
        enabled: Bool,
        severityThreshold: NotificationSeverityThreshold,
        notifyRecoveries: Bool,
        schedules: [NotificationSchedule]
    ) {
        self.lineId = lineId
        self.enabled = enabled
        self.severityThreshold = severityThreshold
        self.notifyRecoveries = notifyRecoveries
        self.schedules = schedules
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
    public let severityThreshold: NotificationSeverityThreshold
    public let schedules: [NotificationSchedule]

    public init(
        lineId: String,
        enabled: Bool,
        notifyRecoveries: Bool,
        severityThreshold: NotificationSeverityThreshold,
        schedules: [NotificationSchedule]
    ) {
        self.lineId = lineId
        self.enabled = enabled
        self.notifyRecoveries = notifyRecoveries
        self.severityThreshold = severityThreshold
        self.schedules = schedules
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

/// The fields to change on one line in a merge patch. `nil` fields are omitted from the
/// request and keep their stored values; a new line must set every field.
public struct NotificationLinePreferencePatch: Encodable, Hashable, Sendable {
    public var enabled: Bool?
    public var severityThreshold: NotificationSeverityThreshold?
    public var notifyRecoveries: Bool?
    public var schedules: [NotificationSchedule]?

    public init(
        enabled: Bool? = nil,
        severityThreshold: NotificationSeverityThreshold? = nil,
        notifyRecoveries: Bool? = nil,
        schedules: [NotificationSchedule]? = nil
    ) {
        self.enabled = enabled
        self.severityThreshold = severityThreshold
        self.notifyRecoveries = notifyRecoveries
        self.schedules = schedules
    }
}

/// An RFC 7396 merge patch of the per-line preferences, keyed by line ID.
/// Only the lines listed change; a `nil` value is sent as `null` and removes that line.
public struct NotificationPreferencesPatch: Encodable, Hashable, Sendable {
    public var lines: [String: NotificationLinePreferencePatch?]

    public init(lines: [String: NotificationLinePreferencePatch?]) {
        self.lines = lines
    }
}
