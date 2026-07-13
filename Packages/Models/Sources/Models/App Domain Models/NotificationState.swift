import Foundation

public enum RegistrationState: Codable, CustomStringConvertible, Equatable, Sendable {
    case notRegistered
    case pendingSync(NotificationPreferencesUpdate)
    case registered

    public var description: String {
        switch self {
        case .notRegistered: "notRegistered"
        case .pendingSync: "pendingSync"
        case .registered: "registered"
        }
    }
}

public struct NotificationState: Codable, Sendable {
    public var device: NotificationDevice?
    public var preferences: NotificationPreferences?
    public var registrationState: RegistrationState

    public static let `default` = NotificationState(device: nil, preferences: nil, registrationState: .notRegistered)

    public init(
        device: NotificationDevice?,
        preferences: NotificationPreferences?,
        registrationState: RegistrationState = .notRegistered
    ) {
        self.device = device
        self.preferences = preferences
        self.registrationState = registrationState
    }

    public var isConfigured: Bool {
        switch registrationState {
        case .pendingSync, .registered: true
        case .notRegistered: false
        }
    }

    public mutating func reset() {
        device = nil
        preferences = nil
        registrationState = .notRegistered
    }
}
