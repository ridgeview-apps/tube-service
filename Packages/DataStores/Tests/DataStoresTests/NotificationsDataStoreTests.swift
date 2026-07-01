import Foundation
import Models
import Testing
import UserNotifications

@testable import DataStores


@MainActor
struct NotificationsDataStoreTests {

    // MARK: - Registration

    @Test
    func registerDeviceSuccess() async throws {
        // Given
        let api = StubNotificationsAPIClient()
        let store = makeStore(api: api)

        // When
        await store.registerDevice(pushToken: "test-push-token", appVersion: nil)

        // Then
        #expect(api.registerDeviceCallCount == 1)
    }

    @Test
    func registerDeviceAlsoFetchesPreferences() async {
        // Given
        let api = StubNotificationsAPIClient()
        let store = makeStore(api: api)

        // When
        await store.registerDevice(pushToken: "test-push-token", appVersion: nil)

        // Then – preferences are fetched automatically after a successful registration
        #expect(store.preferences != nil)
        #expect(api.fetchPreferencesCallCount == 1)
    }

    @Test
    func registerDeviceFailureDoesNotFetchPreferences() async {
        // Given
        let api = StubNotificationsAPIClient()
        api.registerDeviceError = HTTPError.invalidRequestURL
        let store = makeStore(api: api)

        // When
        await store.registerDevice(pushToken: "test-push-token", appVersion: nil)

        // Then
        #expect(store.preferences == nil)
        #expect(api.registerDeviceCallCount == 1)
        #expect(api.fetchPreferencesCallCount == 0)
    }

    @Test
    func registerDevicePreferencesFetchFailureKeepsPreferencesNil() async {
        // Given
        let api = StubNotificationsAPIClient()
        api.fetchPreferencesError = HTTPError.invalidRequestURL
        let store = makeStore(api: api)

        // When
        await store.registerDevice(pushToken: "test-push-token", appVersion: nil)

        // Then – device registered but preferences remain nil if fetch fails
        #expect(api.registerDeviceCallCount == 1)
        #expect(api.fetchPreferencesCallCount == 1)
        #expect(store.preferences == nil)
    }


    // MARK: - Device management

    @Test
    func disableDeviceCallsAPI() async {
        // Given
        let api = StubNotificationsAPIClient()
        let store = makeStore(api: api)

        // When
        await store.disableDevice()

        // Then
        #expect(api.disableDeviceCallCount == 1)
    }

    @Test
    func enableDeviceCallsAPI() async {
        // Given
        let api = StubNotificationsAPIClient()
        let store = makeStore(api: api)

        // When
        await store.enableDevice()

        // Then
        #expect(api.enableDeviceCallCount == 1)
    }

    @Test
    func enableDeviceFetchesPreferencesWhenNil() async {
        // Given
        let api = StubNotificationsAPIClient()
        let store = makeStore(api: api)

        // When
        await store.enableDevice()

        // Then – preferences are fetched after enabling since they were nil
        #expect(api.fetchPreferencesCallCount == 1)
        #expect(store.preferences != nil)
    }

    @Test
    func enableDeviceDoesNotFetchPreferencesWhenAlreadyLoaded() async {
        // Given
        let api = StubNotificationsAPIClient()
        let store = makeStore(api: api)
        await store.registerDevice(pushToken: "test-push-token", appVersion: nil)
        #expect(store.preferences != nil)

        // When – disable then re-enable; preferences were cleared by disable
        await store.disableDevice()
        #expect(store.preferences == nil)
        await store.enableDevice()

        // Then – preferences are re-fetched after enable
        #expect(api.fetchPreferencesCallCount == 2)  // once after register, once after enable
    }

    @Test
    func deleteDeviceClearsState() async {
        // Given
        let api = StubNotificationsAPIClient()
        let store = makeStore(api: api)
        await store.registerDevice(pushToken: "test-push-token", appVersion: nil)
        #expect(store.preferences != nil)

        // When
        await store.deleteDevice()

        // Then
        #expect(store.preferences == nil)
        #expect(api.deleteDeviceCallCount == 1)
    }

    @Test
    func deleteDeviceClearsKeychainDeviceId() async {
        // Given
        let keychain = InMemoryKeychain()
        let store = makeStore(keychain: keychain)
        await store.registerDevice(pushToken: "test-push-token", appVersion: nil)
        #expect(keychain.read(key: "push_device_id") != nil)

        // When
        await store.deleteDevice()

        // Then – keychain entry is cleared so a fresh device ID is generated on re-registration
        #expect(keychain.read(key: "push_device_id") == nil)
    }


    // MARK: - Preferences

    @Test
    func updatePreferencesSuccess() async {
        // Given
        let api = StubNotificationsAPIClient()
        let store = makeStore(api: api)
        await store.registerDevice(pushToken: "test-push-token", appVersion: nil)

        // When
        let update = NotificationPreferencesUpdate(lines: [
            makePreferenceUpdate(lineId: "victoria", schedulePreset: .weekends),
            makePreferenceUpdate(lineId: "jubilee", schedulePreset: .weekends)
        ])
        await store.updatePreferences(with: update)

        // Then
        #expect(store.preferences?.lines.map(\.lineId).sorted() == ["jubilee", "victoria"])
        #expect(store.preferences?.lines.allSatisfy { $0.schedulePreset == .weekends } == true)
        #expect(api.updatePreferencesCallCount == 1)
    }

    @Test
    func updatePreferencesFailureRollsBack() async {
        // Given
        let api = StubNotificationsAPIClient()
        let store = makeStore(api: api)
        await store.registerDevice(pushToken: "test-push-token", appVersion: nil)
        let originalPreferences = store.preferences

        // When – update fails
        api.updatePreferencesError = HTTPError.invalidRequestURL
        let update = NotificationPreferencesUpdate(lines: [
            makePreferenceUpdate(lineId: "victoria", schedulePreset: .anytime)
        ])
        await store.updatePreferences(with: update)

        // Then – preferences roll back to what they were before the update
        #expect(store.preferences == originalPreferences)
    }


    // MARK: - Authorization status

    @Test
    func updateAuthorizationStatusReflectsInjectedStatus() async {
        // Given
        let store = makeStore(pushNotificationEnvironment: .stub(authorizationStatus: .denied))

        // When
        await store.refreshAuthorizationStatus()

        // Then
        #expect(store.authorizationStatus == .denied)
    }


    // MARK: - Pending preferences update

    @Test
    func scheduledPreferencesUpdateIsAppliedAfterRegistration() async {
        // Given
        let api = StubNotificationsAPIClient()
        let store = makeStore(api: api)
        let update = NotificationPreferencesUpdate(lines: [
            makePreferenceUpdate(lineId: "victoria", schedulePreset: .weekends)
        ])

        // When – schedule an update before the APNs token arrives
        store.queuePreferencesUpdate(update)
        await store.registerDevice(pushToken: "test-push-token", appVersion: nil)

        // Then – update is applied instead of fetching defaults
        #expect(api.updatePreferencesCallCount == 1)
        #expect(api.fetchPreferencesCallCount == 0)
        #expect(store.preferences?.lines.map(\.lineId) == ["victoria"])
        #expect(store.preferences?.lines.first?.schedulePreset == .weekends)
    }

    @Test
    func scheduledPreferencesUpdateIsConsumedOnce() async {
        // Given
        let api = StubNotificationsAPIClient()
        let store = makeStore(api: api)
        let update = NotificationPreferencesUpdate(lines: [
            makePreferenceUpdate(lineId: "victoria", schedulePreset: .weekends)
        ])
        store.queuePreferencesUpdate(update)

        // When – register twice with the same token; second call is skipped by the token deduplication guard
        await store.registerDevice(pushToken: "test-push-token", appVersion: nil)
        await store.registerDevice(pushToken: "test-push-token", appVersion: nil)

        // Then – update was only applied once
        #expect(api.updatePreferencesCallCount == 1)
    }

    @Test
    func registerDeviceSkippedWhenTokenUnchanged() async {
        // Given
        let api = StubNotificationsAPIClient()
        let keychain = InMemoryKeychain()
        let store = makeStore(api: api, keychain: keychain)
        await store.registerDevice(pushToken: "test-push-token", appVersion: nil)
        #expect(api.registerDeviceCallCount == 1)

        // When – same token delivered again (e.g. on app resume)
        await store.registerDevice(pushToken: "test-push-token", appVersion: nil)

        // Then – backend is not called again
        #expect(api.registerDeviceCallCount == 1)
    }

    @Test
    func registerDeviceCalledAgainAfterTokenChanges() async {
        // Given
        let api = StubNotificationsAPIClient()
        let store = makeStore(api: api)
        await store.registerDevice(pushToken: "token-v1", appVersion: nil)
        #expect(api.registerDeviceCallCount == 1)

        // When – APNs rotates the token
        await store.registerDevice(pushToken: "token-v2", appVersion: nil)

        // Then – backend is called with the new token
        #expect(api.registerDeviceCallCount == 2)
    }

    @Test
    func deleteDeviceAllowsReregistrationWithSameToken() async {
        // Given
        let api = StubNotificationsAPIClient()
        let keychain = InMemoryKeychain()
        let store = makeStore(api: api, keychain: keychain)
        await store.registerDevice(pushToken: "test-push-token", appVersion: nil)
        #expect(api.registerDeviceCallCount == 1)

        // When – device is deleted (e.g. user removes account) then re-registers
        await store.deleteDevice()
        await store.registerDevice(pushToken: "test-push-token", appVersion: nil)

        // Then – backend is called again because the cached token was cleared on delete
        #expect(api.registerDeviceCallCount == 2)
    }


    // MARK: - Save preferences with mute state

    @Test
    func savePreferencesWhenUnmutedAndStaysUnmuted() async {
        // Given – device registered (enabled = true)
        let api = StubNotificationsAPIClient()
        let store = makeStore(api: api)
        await store.registerDevice(pushToken: "test-push-token", appVersion: nil)

        // When – save with isMuted: false (no mute change)
        await store.savePreferences(update: NotificationPreferencesUpdate(lines: []), isMuted: false)

        // Then – only updatePreferences called, no enable/disable
        #expect(api.updatePreferencesCallCount == 1)
        #expect(api.enableDeviceCallCount == 0)
        #expect(api.disableDeviceCallCount == 0)
    }

    @Test
    func savePreferencesMutingCallsUpdateThenDisable() async {
        // Given – device registered (enabled = true)
        let api = StubNotificationsAPIClient()
        let store = makeStore(api: api)
        await store.registerDevice(pushToken: "test-push-token", appVersion: nil)

        // When – save with isMuted: true (muting)
        await store.savePreferences(update: NotificationPreferencesUpdate(lines: []), isMuted: true)

        // Then – updatePreferences fires before disableDevice
        #expect(api.updatePreferencesCallCount == 1)
        #expect(api.disableDeviceCallCount == 1)
        #expect(api.enableDeviceCallCount == 0)
        #expect(api.invocations.suffix(2) == ["updatePreferences", "disableDevice"])
    }

    @Test
    func savePreferencesUnmutingCallsEnableThenUpdate() async {
        // Given – device disabled (muted)
        let api = StubNotificationsAPIClient()
        let store = makeStore(api: api)
        await store.registerDevice(pushToken: "test-push-token", appVersion: nil)
        await store.disableDevice()
        #expect(store.device?.enabled == false)

        // When – save with isMuted: false (unmuting)
        await store.savePreferences(update: NotificationPreferencesUpdate(lines: []), isMuted: false)

        // Then – enableDevice fires before updatePreferences
        // (enableDevice also triggers fetchPreferences since preferences were nil after disabling)
        #expect(api.enableDeviceCallCount == 1)
        #expect(api.updatePreferencesCallCount == 1)
        #expect(Array(api.invocations.suffix(3)) == ["enableDevice", "fetchPreferences", "updatePreferences"])
    }

    @Test
    func savePreferencesWhenAlreadyMutedAndStaysMuted() async {
        // Given – device disabled (muted)
        let api = StubNotificationsAPIClient()
        let store = makeStore(api: api)
        await store.registerDevice(pushToken: "test-push-token", appVersion: nil)
        await store.disableDevice()

        // When – save with isMuted: true (no mute change)
        await store.savePreferences(update: NotificationPreferencesUpdate(lines: []), isMuted: true)

        // Then – only updatePreferences called, no further enable/disable
        #expect(api.updatePreferencesCallCount == 1)
        #expect(api.disableDeviceCallCount == 1)  // only from setup
        #expect(api.enableDeviceCallCount == 0)
    }

    // MARK: - Helpers

    private func makeStore(
        api: StubNotificationsAPIClient = StubNotificationsAPIClient(),
        pushNotificationEnvironment: PushNotificationEnvironment = .stub(),
        keychain: KeychainService = InMemoryKeychain(),
        userDefaults: UserDefaults = .init(suiteName: UUID().uuidString)!
    ) -> NotificationsDataStore {
        NotificationsDataStore(
            api: api,
            pushNotificationEnvironment: pushNotificationEnvironment,
            userDefaults: userDefaults,
            keychain: keychain
        )
    }

    private func makePreferenceUpdate(
        lineId: String,
        schedulePreset: NotificationSchedulePreset,
        severityThreshold: NotificationSeverityThreshold = .minorDelays
    ) -> NotificationLinePreferenceUpdate {
        NotificationLinePreferenceUpdate(
            lineId: lineId,
            enabled: true,
            notifyRecoveries: true,
            schedulePreset: .weekends,
            severityThreshold: severityThreshold,
            customSchedules: []
        )
    }
}


// MARK: - In-memory keychain for tests

private extension PushNotificationEnvironment {
    static func stub(authorizationStatus: UNAuthorizationStatus = .notDetermined) -> Self {
        .init(
            readAuthStatus: { authorizationStatus },
            requestAuthorization: { true },
            registerForRemoteNotifications: {}
        )
    }
}

final class InMemoryKeychain: KeychainService, @unchecked Sendable {
    private var storage: [String: String] = [:]

    func read(key: String) -> String? { storage[key] }

    @discardableResult
    func write(key: String, value: String) -> Bool {
        storage[key] = value
        return true
    }

    func delete(key: String) { storage.removeValue(forKey: key) }
}
