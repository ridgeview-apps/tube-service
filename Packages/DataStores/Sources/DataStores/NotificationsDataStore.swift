import Foundation
import Models
import Shared
import UserNotifications


@MainActor
@Observable
public final class NotificationsDataStore {

    // MARK: - Public state

    public var isConfigured: Bool { state.isConfigured }
    public var isDevicePaused: Bool { state.device?.enabled == false }
    public var linePreferences: [NotificationLinePreference] { state.preferences?.lines ?? [] }
    public var isPermissionDenied: Bool { authorizationStatus == .denied }

    public var hasConfiguredLines: Bool {
        !linePreferences.isEmpty
    }

    public func isNotifying(for lineID: TrainLineID) -> Bool {
        linePreferences.contains(where: { $0.lineId == lineID.rawValue && $0.enabled })
    }

    public var canReceivePushNotifications: Bool {
        [.authorized, .provisional, .ephemeral].contains(authorizationStatus)
    }

    // MARK: - Private state

    private let api: NotificationsAPIClientType
    private let keychain: any KeychainService
    private let userDefaults: UserDefaults
    private let pushNotificationEnvironment: PushNotificationEnvironment

    private(set) var state: NotificationState {
        didSet { userDefaults.notificationState = state }
    }

    private var authorizationStatus: UNAuthorizationStatus = .notDetermined
    private var isRegisteringDevice = false
    private var isSavingPreferences = false
    private var lastRegistrationError: String?

    private static let keychainDeviceIdKey = "push_device_id"
    private static let keychainPushTokenKey = "push_registered_token"

    // MARK: - Init

    public init(
        api: NotificationsAPIClientType,
        pushNotificationEnvironment: PushNotificationEnvironment,
        userDefaults: UserDefaults,
        keychain: any KeychainService = SecurityKeychain(service: "com.ridgeviewapps.tubeservice.notifications"),
    ) {
        self.api = api
        self.keychain = keychain
        self.userDefaults = userDefaults
        self.state = userDefaults.notificationState
        self.pushNotificationEnvironment = pushNotificationEnvironment
    }


    // MARK: - Device ID

    private var deviceId: String {
        if let existing = keychain.read(key: Self.keychainDeviceIdKey) {
            return existing
        }
        let new = UUID().uuidString
        keychain.write(key: Self.keychainDeviceIdKey, value: new)
        return new
    }


    // MARK: - Registration

    public func handlePushToken(_ pushToken: String, appVersion: String?) async {
        guard shouldRegisterDevice(with: pushToken) else { return }

        isRegisteringDevice = true
        defer { isRegisteringDevice = false }
        do {
            state.device = try await api.registerDevice(deviceId: deviceId, pushToken: pushToken, appVersion: appVersion).decodedModel
            keychain.write(key: Self.keychainPushTokenKey, value: pushToken)
            lastRegistrationError = nil
            try await applyOnboardingPreferencesIfNeeded()
        } catch {
            lastRegistrationError = error.localizedDescription
            AppLogger.notifications.error("handlePushToken failed: \(error)")
        }
    }

    private func shouldRegisterDevice(with pushToken: String) -> Bool {
        if isRegisteringDevice {
            return false
        }

        switch state.registrationState {
        case .notRegistered:
            return false
        case .onboarded:
            return true
        case .registered:
            return pushToken != keychain.read(key: Self.keychainPushTokenKey)
        }
    }

    private func applyOnboardingPreferencesIfNeeded() async throws {
        guard case .onboarded(let preferences) = state.registrationState else { return }
        try await savePreferences(with: preferences)
        state.registrationState = .registered
    }


    // MARK: - Device Management

    public func disableDevice() async throws {
        state.device = try await api.disableDevice(deviceId: deviceId).decodedModel
    }

    public func enableDevice() async throws {
        state.device = try await api.enableDevice(deviceId: deviceId).decodedModel
    }

    public func deleteDevice() async throws {
        try await api.deleteDevice(deviceId: deviceId)
        state.reset()
        keychain.delete(key: Self.keychainDeviceIdKey)
        keychain.delete(key: Self.keychainPushTokenKey)
    }


    // MARK: - Authorization

    public func refreshAuthorizationStatus() async {
        authorizationStatus = await pushNotificationEnvironment.readAuthStatus()
        if canReceivePushNotifications {
            pushNotificationEnvironment.registerForRemoteNotifications()
        }
    }

    public func requestAuthorizationAndRefreshStatus() async {
        do {
            _ = try await pushNotificationEnvironment.requestAuthorization()
        } catch {
            AppLogger.notifications.error("Authorization request failed: \(error)")
        }
        await refreshAuthorizationStatus()
    }


    // MARK: - Preferences

    public func completeOnboarding(with preferences: NotificationPreferencesUpdate) {
        state.registrationState = .onboarded(preferences)
    }

    public func savePreferences(with preferences: NotificationPreferencesUpdate) async throws {
        guard !isSavingPreferences else { return }
        isSavingPreferences = true
        defer { isSavingPreferences = false }
        do {
            state.preferences = try await api.updatePreferences(deviceId: deviceId, update: preferences).decodedModel
        } catch {
            AppLogger.notifications.error("Failed to update notification preferences: \(error)")
            if case HTTPError.statusCode(404, _) = error {
                keychain.delete(key: Self.keychainPushTokenKey)
                pushNotificationEnvironment.registerForRemoteNotifications()
            }
            throw error
        }
    }
}

// MARK: - Debug

extension NotificationsDataStore {
    public struct DebugInfo {
        public let pushToken: String?
        public let deviceId: String?
        public let authorizationStatus: UNAuthorizationStatus
        public let deviceEnabled: Bool?
        public let appVariant: String?
        public let configuredLineCount: Int
        public let registrationState: String
        public let lastRegistrationError: String?
    }

    public var debugInfo: DebugInfo {
        DebugInfo(
            pushToken: keychain.read(key: Self.keychainPushTokenKey),
            deviceId: keychain.read(key: Self.keychainDeviceIdKey),
            authorizationStatus: authorizationStatus,
            deviceEnabled: state.device?.enabled,
            appVariant: state.device?.appVariant,
            configuredLineCount: linePreferences.count,
            registrationState: state.registrationState.description,
            lastRegistrationError: lastRegistrationError
        )
    }
}
