import Foundation
import Models
import Shared

@MainActor
@Observable
public final class NotificationsDataStore {

    // MARK: - State

    private let api: NotificationsAPIClientType
    private let keychain: any KeychainService
    private let userDefaults: UserDefaults

    public internal(set) var device: NotificationDevice?
    public internal(set) var preferences: NotificationPreferences?
    public internal(set) var isRegistering = false
    public internal(set) var isFetchingPreferences = false
    public internal(set) var isSavingPreferences = false
    public internal(set) var registrationError: Error?

    /// Preferences to apply immediately after the next successful device registration.
    /// Set by the onboarding flow so choices survive the async APNs token delivery.
    public var pendingPreferencesUpdate: NotificationPreferencesUpdate?

    private static let keychainDeviceIdKey = "device_id"

    // Lazily cached to avoid hitting Keychain on every access.
    private var cachedDeviceId: String?


    // MARK: - Init

    public init(api: NotificationsAPIClientType, userDefaults: UserDefaults = .standard) {
        self.api = api
        self.keychain = SecurityKeychain(service: "com.ridgeviewapps.tubeservice.notifications")
        self.userDefaults = userDefaults
        self.preferences = userDefaults.notificationPreferences
    }

    // Internal init allows test/stub code within the package to inject a custom keychain.
    init(api: NotificationsAPIClientType, keychain: any KeychainService, userDefaults: UserDefaults = .standard) {
        self.api = api
        self.keychain = keychain
        self.userDefaults = userDefaults
        self.preferences = userDefaults.notificationPreferences
    }


    // MARK: - Device ID

    /// A stable UUID persisted in the Keychain. Survives app reinstalls.
    public var deviceId: String {
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
        registrationError = nil
        defer { isRegistering = false }
        do {
            device = try await api.registerDevice(deviceId: deviceId, pushToken: pushToken, appVersion: appVersion).decodedModel
            if let pending = pendingPreferencesUpdate {
                pendingPreferencesUpdate = nil
                await updatePreferences(pending)
            } else if preferences == nil {
                await fetchPreferences()
            }
        } catch {
            AppLogger.notifications.error("Failed to register Device \(error)")
            registrationError = error
        }
    }

    public func disableDevice() async {
        do {
            device = try await api.disableDevice(deviceId: deviceId).decodedModel
        } catch {
            AppLogger.notifications.error("Failed to disable device \(error)")
        }
    }

    public func deleteDevice() async {
        do {
            try await api.deleteDevice(deviceId: deviceId)
            device = nil
            preferences = nil
            userDefaults.notificationPreferences = nil
        } catch {
            AppLogger.notifications.error("Failed to delete device \(error)")
        }
    }


    // MARK: - Preferences

    public func fetchPreferences() async {
        guard !isFetchingPreferences else { return }
        isFetchingPreferences = true
        defer { isFetchingPreferences = false }
        do {
            preferences = try await api.fetchPreferences(deviceId: deviceId).decodedModel
            userDefaults.notificationPreferences = preferences
        } catch {
            AppLogger.notifications.error("Failed to fetch notification preferences \(error)")
            // Keep existing preferences on error
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
            AppLogger.notifications.error("Failed to update notification preferences \(error)")
            preferences = previousPreferences
        }
    }
}
