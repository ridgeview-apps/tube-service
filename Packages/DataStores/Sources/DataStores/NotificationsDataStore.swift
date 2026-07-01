import Foundation
import Models
import Shared
import UserNotifications

@MainActor
@Observable
public final class NotificationsDataStore {

    // MARK: - Public state

    public internal(set) var preferences: NotificationPreferences? {
        didSet { userDefaults.notificationPreferences = preferences }
    }
    public private(set) var device: NotificationDevice?
    public private(set) var hasCompletedOnboarding: Bool {
        didSet { userDefaults.hasCompletedNotificationsOnboarding = hasCompletedOnboarding }
    }

    public var isPermissionDenied: Bool { authorizationStatus == .denied }

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

    private static let keychainDeviceIdKey = "push_device_id"
    private static let keychainPushTokenKey = "push_registered_token"
    private var cachedDeviceId: String?
    private var queuedPreferencesUpdate: NotificationPreferencesUpdate?

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
        self.preferences = userDefaults.notificationPreferences
        self.hasCompletedOnboarding = userDefaults.hasCompletedNotificationsOnboarding
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
        guard !isRegistering,
            pushToken != keychain.read(key: Self.keychainPushTokenKey)
        else { return }
        isRegistering = true
        defer { isRegistering = false }
        do {
            device = try await api.registerDevice(deviceId: deviceId, pushToken: pushToken, appVersion: appVersion).decodedModel
            keychain.write(key: Self.keychainPushTokenKey, value: pushToken)
            if let queuedPreferences = queuedPreferencesUpdate {
                queuedPreferencesUpdate = nil
                await updatePreferences(with: queuedPreferences)
            } else if preferences == nil {
                await fetchInitialPreferences()
            }
        } catch {
            AppLogger.notifications.error("Failed to register device: \(error)")
        }
    }


    // MARK: - Device Management

    public func disableDevice() async {
        do {
            device = try await api.disableDevice(deviceId: deviceId).decodedModel
        } catch {
            AppLogger.notifications.error("Failed to disable device: \(error)")
        }
    }

    public func enableDevice() async {
        do {
            device = try await api.enableDevice(deviceId: deviceId).decodedModel
            if preferences == nil {
                await fetchInitialPreferences()
            }
        } catch {
            AppLogger.notifications.error("Failed to enable device: \(error)")
        }
    }

    public func deleteDevice() async {
        do {
            try await api.deleteDevice(deviceId: deviceId)
            device = nil
            preferences = nil
            hasCompletedOnboarding = false
            keychain.delete(key: Self.keychainDeviceIdKey)
            keychain.delete(key: Self.keychainPushTokenKey)
            cachedDeviceId = nil
        } catch {
            AppLogger.notifications.error("Failed to delete device: \(error)")
        }
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

    public func queuePreferencesUpdate(_ update: NotificationPreferencesUpdate) {
        queuedPreferencesUpdate = update
    }

    private func fetchInitialPreferences() async {
        do {
            preferences = try await api.fetchPreferences(deviceId: deviceId).decodedModel
        } catch {
            AppLogger.notifications.error("Failed to fetch notification preferences: \(error)")
        }
    }

    public func updatePreferences(with update: NotificationPreferencesUpdate) async {
        guard !isSavingPreferences else { return }
        let previousPreferences = preferences
        isSavingPreferences = true
        defer { isSavingPreferences = false }
        do {
            preferences = try await api.updatePreferences(deviceId: deviceId, update: update).decodedModel
            if !hasCompletedOnboarding { hasCompletedOnboarding = true }
        } catch {
            AppLogger.notifications.error("Failed to update notification preferences: \(error)")
            preferences = previousPreferences
        }
    }

    public func savePreferences(update: NotificationPreferencesUpdate, isMuted: Bool) async {
        guard let device else {
            await updatePreferences(with: update)
            return
        }
        let currentlyMuted = !device.enabled
        if !isMuted, currentlyMuted {
            await enableDevice()
        }
        await updatePreferences(with: update)
        if isMuted, !currentlyMuted {
            await disableDevice()
        }
    }
}
