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

        // When – disable then re-enable; preferences are retained across disable so no re-fetch needed
        await store.disableDevice()
        #expect(store.preferences != nil)
        await store.enableDevice()

        // Then – preferences were never cleared so fetchPreferences is only called once (after register)
        #expect(api.fetchPreferencesCallCount == 1)
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


    // MARK: - Save preferences with enable state

    @Test
    func savePreferencesWhenEnabledAndStaysEnabled() async {
        // Given – device registered (enabled = true)
        let api = StubNotificationsAPIClient()
        let store = makeStore(api: api)
        await store.registerDevice(pushToken: "test-push-token", appVersion: nil)

        // When – save with deviceEnabled: true (no change)
        await store.savePreferences(update: NotificationPreferencesUpdate(lines: []), deviceEnabled: true)

        // Then – only updatePreferences called, no enable/disable
        #expect(api.updatePreferencesCallCount == 1)
        #expect(api.enableDeviceCallCount == 0)
        #expect(api.disableDeviceCallCount == 0)
    }

    @Test
    func savePreferencesDisablingCallsUpdateThenDisable() async {
        // Given – device registered (enabled = true)
        let api = StubNotificationsAPIClient()
        let store = makeStore(api: api)
        await store.registerDevice(pushToken: "test-push-token", appVersion: nil)

        // When – save with deviceEnabled: false (disabling)
        await store.savePreferences(update: NotificationPreferencesUpdate(lines: []), deviceEnabled: false)

        // Then – updatePreferences fires before disableDevice
        #expect(api.updatePreferencesCallCount == 1)
        #expect(api.disableDeviceCallCount == 1)
        #expect(api.enableDeviceCallCount == 0)
        #expect(api.invocations.suffix(2) == ["updatePreferences", "disableDevice"])
    }

    @Test
    func savePreferencesEnablingCallsEnableThenUpdate() async {
        // Given – device disabled
        let api = StubNotificationsAPIClient()
        let store = makeStore(api: api)
        await store.registerDevice(pushToken: "test-push-token", appVersion: nil)
        await store.disableDevice()
        #expect(store.device?.enabled == false)

        // When – save with deviceEnabled: true (re-enabling)
        await store.savePreferences(update: NotificationPreferencesUpdate(lines: []), deviceEnabled: true)

        // Then – enableDevice fires before updatePreferences; no re-fetch since preferences persist across disable
        #expect(api.enableDeviceCallCount == 1)
        #expect(api.updatePreferencesCallCount == 1)
        #expect(Array(api.invocations.suffix(2)) == ["enableDevice", "updatePreferences"])
    }

    @Test
    func savePreferencesWhenAlreadyDisabledAndStaysDisabled() async {
        // Given – device disabled
        let api = StubNotificationsAPIClient()
        let store = makeStore(api: api)
        await store.registerDevice(pushToken: "test-push-token", appVersion: nil)
        await store.disableDevice()

        // When – save with deviceEnabled: false (no change)
        await store.savePreferences(update: NotificationPreferencesUpdate(lines: []), deviceEnabled: false)

        // Then – only updatePreferences called, no further enable/disable
        #expect(api.updatePreferencesCallCount == 1)
        #expect(api.disableDeviceCallCount == 1)  // only from setup
        #expect(api.enableDeviceCallCount == 0)
    }

    // MARK: - hasConfiguredLines

    @Test
    func hasConfiguredLinesIsFalseWhenPreferencesNil() {
        let store = makeStore()
        #expect(store.hasConfiguredLines == false)
    }

    @Test
    func hasConfiguredLinesIsFalseWhenLinesEmpty() async {
        // Given – stub returns empty lines (default)
        let api = StubNotificationsAPIClient()
        let store = makeStore(api: api)
        await store.registerDevice(pushToken: "test-push-token", appVersion: nil)
        #expect(store.preferences?.lines.isEmpty == true)

        // Then
        #expect(store.hasConfiguredLines == false)
    }

    @Test
    func hasConfiguredLinesIsTrueWhenLinesPresent() async {
        // Given – stub returns preferences with one line
        let api = StubNotificationsAPIClient()
        let store = makeStore(api: api)
        let update = NotificationPreferencesUpdate(lines: [makePreferenceUpdate(lineId: "victoria", schedulePreset: .anytime)])
        store.queuePreferencesUpdate(update)
        await store.registerDevice(pushToken: "test-push-token", appVersion: nil)

        // Then
        #expect(store.hasConfiguredLines == true)
    }


    // MARK: - isNotifying(for:)

    @Test
    func isNotifyingReturnsFalseWhenPreferencesNil() {
        let store = makeStore()
        #expect(store.isNotifying(for: .victoria) == false)
    }

    @Test
    func isNotifyingReturnsFalseWhenLineNotConfigured() async {
        // Given – preferences contain jubilee but not victoria
        let api = StubNotificationsAPIClient()
        let store = makeStore(api: api)
        let update = NotificationPreferencesUpdate(lines: [makePreferenceUpdate(lineId: "jubilee", schedulePreset: .anytime)])
        store.queuePreferencesUpdate(update)
        await store.registerDevice(pushToken: "test-push-token", appVersion: nil)

        // Then
        #expect(store.isNotifying(for: .victoria) == false)
    }

    @Test
    func isNotifyingReturnsFalseWhenLineDisabled() async {
        // Given – victoria is present but disabled
        let api = StubNotificationsAPIClient()
        let store = makeStore(api: api)
        let update = NotificationPreferencesUpdate(lines: [
            NotificationLinePreferenceUpdate(
                lineId: "victoria",
                enabled: false,
                notifyRecoveries: true,
                schedulePreset: .anytime,
                severityThreshold: .minorDelays,
                customSchedules: []
            )
        ])
        store.queuePreferencesUpdate(update)
        await store.registerDevice(pushToken: "test-push-token", appVersion: nil)

        // Then
        #expect(store.isNotifying(for: .victoria) == false)
    }

    @Test
    func isNotifyingReturnsTrueWhenLineEnabled() async {
        // Given – victoria is present and enabled
        let api = StubNotificationsAPIClient()
        let store = makeStore(api: api)
        let update = NotificationPreferencesUpdate(lines: [makePreferenceUpdate(lineId: "victoria", schedulePreset: .anytime)])
        store.queuePreferencesUpdate(update)
        await store.registerDevice(pushToken: "test-push-token", appVersion: nil)

        // Then
        #expect(store.isNotifying(for: .victoria) == true)
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
