import UserNotifications

public struct PushNotificationEnvironment: Sendable {
    public var readAuthStatus: @Sendable () async -> UNAuthorizationStatus
    public var requestAuthorization: @Sendable () async throws -> Bool
    public var registerForRemoteNotifications: @MainActor @Sendable () -> Void

    public init(
        readAuthStatus: @escaping @Sendable () async -> UNAuthorizationStatus,
        requestAuthorization: @escaping @Sendable () async throws -> Bool,
        registerForRemoteNotifications: @escaping @MainActor @Sendable () -> Void
    ) {
        self.readAuthStatus = readAuthStatus
        self.requestAuthorization = requestAuthorization
        self.registerForRemoteNotifications = registerForRemoteNotifications
    }
}
