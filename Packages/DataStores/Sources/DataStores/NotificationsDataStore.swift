import Foundation
import Models

@MainActor
@Observable
public final class NotificationsDataStore {

    // MARK: - State

    private let api: NotificationsAPIClientType
    private let keychain: any KeychainService

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

    public init(api: NotificationsAPIClientType) {
        self.api = api
        self.keychain = SecurityKeychain(service: "com.ridgeviewapps.tubeservice.notifications")
    }

    // Internal init allows test/stub code within the package to inject a custom keychain.
    init(api: NotificationsAPIClientType, keychain: any KeychainService) {
        self.api = api
        self.keychain = keychain
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
            registrationError = error
        }
    }

    public func disableDevice() async {
        do {
            device = try await api.disableDevice(deviceId: deviceId).decodedModel
        } catch {
            // Treat errors silently; device state unchanged on failure
        }
    }

    public func deleteDevice() async {
        do {
            try await api.deleteDevice(deviceId: deviceId)
            device = nil
            preferences = nil
        } catch {
            // Device may already be deleted; treat as success
        }
    }


    // MARK: - Preferences

    public func fetchPreferences() async {
        guard !isFetchingPreferences else { return }
        isFetchingPreferences = true
        defer { isFetchingPreferences = false }
        do {
            preferences = try await api.fetchPreferences(deviceId: deviceId).decodedModel
        } catch {
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
        } catch {
            preferences = previousPreferences
        }
    }
}
