import Foundation
import Models
import Shared
import UserNotifications

public enum NotificationsDataStoreError: LocalizedError, Equatable {
    case deviceNotRegistered
    case saveInProgress

    public var errorDescription: String? {
        switch self {
        case .deviceNotRegistered:
            return "Device not yet registered for notifications. Please try again."
        case .saveInProgress:
            return "A save is already in progress. Please try again."
        }
    }
}

@MainActor
@Observable
public final class NotificationsDataStore {

    // MARK: - Public state

    public var preferences: NotificationPreferences? { state.preferences }
    public var device: NotificationDevice? { state.device }
    public var hasCompletedOnboarding: Bool { state.hasCompletedOnboarding }

    private var state: NotificationState {
        didSet { userDefaults.notificationState = state }
    }

    public var isPermissionDenied: Bool { authorizationStatus == .denied }

    public struct DebugInfo {
        public let pushToken: String?
        public let deviceId: String?
        public let authorizationStatus: UNAuthorizationStatus
        public let deviceEnabled: Bool?
        public let appVariant: String?
        public let configuredLineCount: Int
        public let hasCompletedOnboarding: Bool
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
            hasCompletedOnboarding: hasCompletedOnboarding,
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

    private(set) var authorizationStatus: UNAuthorizationStatus = .notDetermined

    // MARK: - Private state

    private let api: NotificationsAPIClientType
    private let keychain: any KeychainService
    private let userDefaults: UserDefaults
    private let pushNotificationEnvironment: PushNotificationEnvironment

    private var isRegistering = false
    private var isSavingPreferences = false
    private var lastRegistrationError: String?

    private static let keychainDeviceIdKey = "push_device_id"
    private static let keychainPushTokenKey = "push_registered_token"
    private var cachedDeviceId: String?
    private var pendingPreferencesUpdate: NotificationPreferencesUpdate?

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
        if let cached = cachedDeviceId { return cached }
        if let existing = keychain.read(key: Self.keychainDeviceIdKey) {
            cachedDeviceId = existing
            return existing
        }
        let new = UUID().uuidString
        keychain.write(key: Self.keychainDeviceIdKey, value: new)
        cachedDeviceId = new
        return new
    }


    // MARK: - Registration

    public func registerDevice(pushToken: String, appVersion: String?) async {
        guard !isRegistering else { return }
        guard !state.hasUserDeletedDevice || pendingPreferencesUpdate != nil else { return }
        guard pushToken != keychain.read(key: Self.keychainPushTokenKey) else {
            await syncPreferences()
            return
        }
        isRegistering = true
        defer { isRegistering = false }
        do {
            state.device = try await api.registerDevice(deviceId: deviceId, pushToken: pushToken, appVersion: appVersion).decodedModel
            keychain.write(key: Self.keychainPushTokenKey, value: pushToken)
            state.hasUserDeletedDevice = false
            lastRegistrationError = nil
            await syncPreferences()
        } catch {
            lastRegistrationError = error.localizedDescription
            AppLogger.notifications.error("Failed to register device: \(error)")
        }
    }

    private func syncPreferences() async {
        if let update = pendingPreferencesUpdate {
            do {
                try await updatePreferences(with: update)
                pendingPreferencesUpdate = nil
            } catch {
                AppLogger.notifications.error("Failed to apply pending preferences: \(error)")
            }
        } else {
            await fetchInitialPreferencesIfNeeded()
        }
    }

    private func fetchInitialPreferencesIfNeeded() async {
        guard preferences == nil else { return }
        await fetchInitialPreferences()
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
        await fetchInitialPreferencesIfNeeded()
    }

    public func deleteDevice() async throws {
        do {
            try await api.deleteDevice(deviceId: deviceId)
        } catch {
            AppLogger.notifications.error("Failed to delete device: \(error)")
            throw error
        }
        state.device = nil
        state.preferences = nil
        state.hasCompletedOnboarding = false
        state.hasUserDeletedDevice = true
        keychain.delete(key: Self.keychainDeviceIdKey)
        keychain.delete(key: Self.keychainPushTokenKey)
        cachedDeviceId = nil
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
        state.hasUserDeletedDevice = false
        pendingPreferencesUpdate = update
        state.hasCompletedOnboarding = true
    }

    private func fetchInitialPreferences() async {
        do {
            state.preferences = try await api.fetchPreferences(deviceId: deviceId).decodedModel
        } catch {
            AppLogger.notifications.error("Failed to fetch notification preferences: \(error)")
        }
    }

    public func updatePreferences(with update: NotificationPreferencesUpdate) async throws {
        guard !isSavingPreferences else { throw NotificationsDataStoreError.saveInProgress }
        let previousPreferences = preferences
        isSavingPreferences = true
        defer { isSavingPreferences = false }
        do {
            state.preferences = try await api.updatePreferences(deviceId: deviceId, update: update).decodedModel
        } catch {
            AppLogger.notifications.error("Failed to update notification preferences: \(error)")
            state.preferences = previousPreferences
            if case HTTPError.statusCode(404, _) = error {
                keychain.delete(key: Self.keychainPushTokenKey)
                pushNotificationEnvironment.registerForRemoteNotifications()
            }
            throw error
        }
    }

    public func savePreferences(update: NotificationPreferencesUpdate, deviceEnabled: Bool) async throws {
        guard let device else {
            throw NotificationsDataStoreError.deviceNotRegistered
        }
        let currentlyEnabled = device.enabled
        if deviceEnabled, !currentlyEnabled {
            try await enableDevice()
        }
        try await updatePreferences(with: update)
        if !deviceEnabled, currentlyEnabled {
            try await disableDevice()
        }
    }
}
