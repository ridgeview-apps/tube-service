import Foundation

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

    public mutating func reset() {
        device = nil
        preferences = nil
        hasCompletedOnboarding = false
        hasUserDeletedDevice = true
    }
}
