import Foundation
import Models
import Shared
import UserNotifications

@MainActor
@Observable
public final class NotificationsDataStore {

    // MARK: - Public state

    public internal(set) var preferences: NotificationPreferences?
    public internal(set) var authorizationStatus: UNAuthorizationStatus = .notDetermined
    public internal(set) var isSavingPreferences = false

    private var pendingPreferencesUpdate: NotificationPreferencesUpdate?

    // MARK: - Private state

    private let api: NotificationsAPIClientType
    private let keychain: any KeychainService
    private let userDefaults: UserDefaults
    private let pushNotificationEnvironment: PushNotificationEnvironment

    private var device: NotificationDevice?
    private var isRegistering = false

    private static let keychainDeviceIdKey = "push_device_id"
    private var cachedDeviceId: String?


    // MARK: - Init

    public init(
        api: NotificationsAPIClientType,
        userDefaults: UserDefaults = .standard,
        pushNotificationEnvironment: PushNotificationEnvironment
    ) {
        self.api = api
        self.keychain = SecurityKeychain(service: "com.ridgeviewapps.tubeservice.notifications")
        self.userDefaults = userDefaults
        self.preferences = userDefaults.notificationPreferences
        self.pushNotificationEnvironment = pushNotificationEnvironment
    }

    // Internal init allows test/stub code within the package to inject a custom keychain.
    init(
        api: NotificationsAPIClientType,
        keychain: any KeychainService,
        userDefaults: UserDefaults = .standard,
        pushNotificationEnvironment: PushNotificationEnvironment
    ) {
        self.api = api
        self.keychain = keychain
        self.userDefaults = userDefaults
        self.preferences = userDefaults.notificationPreferences
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

    public func registerDevice(pushToken: String, appVersion: String? = nil) async {
        guard !isRegistering else { return }
        isRegistering = true
        defer { isRegistering = false }
        do {
            device = try await api.registerDevice(deviceId: deviceId, pushToken: pushToken, appVersion: appVersion).decodedModel
            if let pending = pendingPreferencesUpdate {
                pendingPreferencesUpdate = nil
                await updatePreferences(pending)
            } else if preferences == nil {
                await fetchInitialPreferences()
            }
        } catch {
            AppLogger.notifications.error("Failed to register device: \(error)")
        }
    }

    public func disableDevice() async {
        do {
            device = try await api.disableDevice(deviceId: deviceId).decodedModel
            preferences = nil
            userDefaults.notificationPreferences = nil
        } catch {
            AppLogger.notifications.error("Failed to disable device: \(error)")
        }
    }

    public func deleteDevice() async {
        do {
            try await api.deleteDevice(deviceId: deviceId)
            device = nil
            preferences = nil
            userDefaults.notificationPreferences = nil
            keychain.delete(key: Self.keychainDeviceIdKey)
            cachedDeviceId = nil
        } catch {
            AppLogger.notifications.error("Failed to delete device: \(error)")
        }
    }


    public func updateAuthorizationStatus() async {
        authorizationStatus = await pushNotificationEnvironment.readAuthStatus()
        pushNotificationEnvironment.registerForRemoteNotifications()
    }

    public func requestAuthorization() async {
        do {
            _ = try await pushNotificationEnvironment.requestAuthorization()
        } catch {
            AppLogger.notifications.error("Authorization request failed: \(error)")
        }
        await updateAuthorizationStatus()
    }

    public func schedulePreferencesUpdate(_ update: NotificationPreferencesUpdate) {
        pendingPreferencesUpdate = update
    }


    // MARK: - Preferences

    private func fetchInitialPreferences() async {
        do {
            preferences = try await api.fetchPreferences(deviceId: deviceId).decodedModel
            userDefaults.notificationPreferences = preferences
        } catch {
            AppLogger.notifications.error("Failed to fetch notification preferences: \(error)")
        }
    }

    public func updatePreferences(_ update: NotificationPreferencesUpdate) async {
        guard !isSavingPreferences else { return }
        let previousPreferences = preferences
        isSavingPreferences = true
        defer { isSavingPreferences = false }
        do {
            preferences = try await api.updatePreferences(deviceId: deviceId, update: update).decodedModel
            userDefaults.notificationPreferences = preferences
        } catch {
            AppLogger.notifications.error("Failed to update notification preferences: \(error)")
            preferences = previousPreferences
        }
    }
}
