import Foundation
import Models
import Shared
import UserNotifications


@MainActor
@Observable
public final class NotificationsDataStore {

    // MARK: - Public state

    public var isConfigured: Bool { state.isConfigured }
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
    /// The most recent line preferences save, which the next one waits for.
    private var lastLinePreferencesSave: Task<Void, Never>?
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

    /// `nil` until the device first registers.
    private var deviceId: String? {
        keychain.read(key: Self.keychainDeviceIdKey)
    }

    /// Only registration may create a device ID; every other call requires one to already exist.
    /// A new ID is persisted before it's returned, so a lost registration response retries with the same ID.
    private func readOrCreateDeviceId() -> String {
        if let deviceId {
            return deviceId
        }
        let new = UUID().uuidString
        keychain.write(key: Self.keychainDeviceIdKey, value: new)
        return new
    }

    /// Returns the ID of a device that has already registered, for calls that are meaningless otherwise.
    private func registeredDeviceId() throws -> String {
        guard let deviceId else { throw NotificationsDataStoreError.deviceNotRegistered }
        return deviceId
    }


    // MARK: - Registration

    public func handlePushToken(_ pushToken: String, appVersion: String?) async {
        guard shouldRegisterDevice(with: pushToken) else { return }

        isRegisteringDevice = true
        defer { isRegisteringDevice = false }
        do {
            state.device = try await api.registerDevice(deviceId: readOrCreateDeviceId(), pushToken: pushToken, appVersion: appVersion).decodedModel
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

    /// Sends the full set of lines chosen during onboarding. This is the only place that replaces every line;
    /// later edits go through `updateLinePreferences(with:)`.
    private func applyOnboardingPreferencesIfNeeded() async throws {
        guard case .onboarded(let preferences) = state.registrationState, !isSavingPreferences else { return }
        isSavingPreferences = true
        defer { isSavingPreferences = false }
        do {
            state.preferences = try await api.replaceAllPreferences(deviceId: registeredDeviceId(), with: preferences).decodedModel
        } catch {
            handlePreferencesSaveFailure(error)
            throw error
        }
        state.registrationState = .registered
    }


    // MARK: - Device Management

    /// Turns notifications for this device on or off on the server. The user's line settings are kept either way.
    ///
    /// Does nothing if the device isn't registered or is already in that state, so it's safe to call often. If the
    /// request fails, the error is logged and the next call tries again.
    public func setDeviceEnabled(_ isEnabled: Bool) async {
        guard let device = state.device, device.enabled != isEnabled, let deviceId else { return }
        do {
            let response =
                isEnabled
                ? try await api.enableDevice(deviceId: deviceId)
                : try await api.disableDevice(deviceId: deviceId)
            state.device = response.decodedModel
        } catch {
            AppLogger.notifications.error("Failed to set device enabled to \(isEnabled): \(error)")
        }
    }

    public func deleteDevice() async throws {
        if let deviceId {
            do {
                try await api.deleteDevice(deviceId: deviceId)
            } catch HTTPError.statusCode(404, _) {
                // The server no longer knows this device, so local cleanup can still proceed.
            }
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

    public func completeOnboarding(with preferences: NotificationPreferencesUpdate) {
        state.registrationState = .onboarded(preferences)
    }

    /// Changes only the lines in `patch`, so lines the user didn't touch keep any fields this app version doesn't know about.
    ///
    /// Saves are sent one at a time in the order they're made, so quick successive edits all reach the server
    /// and the last one wins. Each save runs in its own task, so it still completes if the caller is cancelled,
    /// e.g. when the screen that made the edit closes.
    public func updateLinePreferences(with patch: NotificationPreferencesPatch) async throws {
        let previousSave = lastLinePreferencesSave
        let save = Task {
            await previousSave?.value
            try await sendLinePreferences(patch)
        }
        lastLinePreferencesSave = Task { _ = try? await save.value }
        try await save.value
    }

    private func sendLinePreferences(_ patch: NotificationPreferencesPatch) async throws {
        isSavingPreferences = true
        defer { isSavingPreferences = false }
        do {
            state.preferences = try await api.updatePreferences(deviceId: registeredDeviceId(), with: patch).decodedModel
        } catch {
            handlePreferencesSaveFailure(error)
            throw error
        }
    }

    /// A 404 means the server no longer knows this device, so clearing the stored token forces re-registration.
    private func handlePreferencesSaveFailure(_ error: Error) {
        AppLogger.notifications.error("Failed to update notification preferences: \(error)")
        if case HTTPError.statusCode(404, _) = error {
            keychain.delete(key: Self.keychainPushTokenKey)
            pushNotificationEnvironment.registerForRemoteNotifications()
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
            deviceId: deviceId,
            authorizationStatus: authorizationStatus,
            deviceEnabled: state.device?.enabled,
            appVariant: state.device?.appVariant,
            configuredLineCount: linePreferences.count,
            registrationState: state.registrationState.description,
            lastRegistrationError: lastRegistrationError
        )
    }
}
