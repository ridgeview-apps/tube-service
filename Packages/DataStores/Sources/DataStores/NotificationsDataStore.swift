import Foundation
import Models
import Shared
import UserNotifications


@MainActor
@Observable
public final class NotificationsDataStore {

    // MARK: - Public state

    public var isConfigured: Bool { state.isConfigured }
    public var isDevicePaused: Bool { device?.enabled == false }
    public var linePreferences: [NotificationLinePreference] { state.preferences?.lines ?? [] }
    public var isPermissionDenied: Bool { authorizationStatus == .denied }

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
            deviceEnabled: device?.enabled,
            appVariant: device?.appVariant,
            configuredLineCount: preferences?.lines.count ?? 0,
            registrationState: state.registrationState.description,
            lastRegistrationError: lastRegistrationError
        )
    }

    public var hasConfiguredLines: Bool {
        guard let preferences else { return false }
        return !preferences.lines.isEmpty
    }

    public func isNotifying(for lineID: TrainLineID) -> Bool {
        preferences?.lines.contains(where: { $0.lineId == lineID.rawValue && $0.enabled }) ?? false
    }

    public var canReceivePushNotifications: Bool {
        switch authorizationStatus {
        case .authorized, .provisional, .ephemeral:
            true
        case .notDetermined, .denied:
            false
        @unknown default:
            false
        }
    }

    // MARK: - Private state

    private let api: NotificationsAPIClientType
    private let keychain: any KeychainService
    private let userDefaults: UserDefaults
    private let pushNotificationEnvironment: PushNotificationEnvironment

    private(set) var state: NotificationState {
        didSet { userDefaults.notificationState = state }
    }

    private var preferences: NotificationPreferences? { state.preferences }
    private var device: NotificationDevice? { state.device }

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
            try await applyPendingPreferencesUpdate()
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
        case .pendingSync:
            return true
        case .registered:
            return pushToken != keychain.read(key: Self.keychainPushTokenKey)
        }
    }

    private func applyPendingPreferencesUpdate() async throws {
        guard case .pendingSync(let update) = state.registrationState else { return }
        try await savePreferences(update: update)
        state.registrationState = .registered
    }


    // MARK: - Device Management

    public func disableDevice() async throws {
        do {
            state.device = try await api.disableDevice(deviceId: deviceId).decodedModel
        } catch {
            AppLogger.notifications.error("Failed to disable device: \(error)")
            throw error
        }
    }

    public func enableDevice() async throws {
        do {
            state.device = try await api.enableDevice(deviceId: deviceId).decodedModel
        } catch {
            AppLogger.notifications.error("Failed to enable device: \(error)")
            throw error
        }
    }

    public func deleteDevice() async throws {
        do {
            try await api.deleteDevice(deviceId: deviceId)
        } catch {
            AppLogger.notifications.error("Failed to delete device: \(error)")
            throw error
        }
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

    public func completeOnboarding(with update: NotificationPreferencesUpdate) {
        state.registrationState = .pendingSync(update)
    }

    public func savePreferences(update: NotificationPreferencesUpdate) async throws {
        guard !isSavingPreferences else { return }
        isSavingPreferences = true
        defer { isSavingPreferences = false }
        do {
            state.preferences = try await api.updatePreferences(deviceId: deviceId, update: update).decodedModel
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
