import UserNotifications

public struct AuthorizationProvider: Sendable {
    public var readAuthStatus: @Sendable () async -> UNAuthorizationStatus
    public var registerPushNotifications: @MainActor @Sendable () -> Void

    public init(
        readAuthStatus: @escaping @Sendable () async -> UNAuthorizationStatus,
        registerPushNotifications: @escaping @MainActor @Sendable () -> Void
    ) {
        self.readAuthStatus = readAuthStatus
        self.registerPushNotifications = registerPushNotifications
    }
}
