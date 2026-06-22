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
        await store.registerDevice(pushToken: "test-push-token")

        // Then
        #expect(api.registerDeviceCallCount == 1)
    }

    @Test
    func registerDeviceAlsoFetchesPreferences() async {
        // Given
        let api = StubNotificationsAPIClient()
        let store = makeStore(api: api)

        // When
        await store.registerDevice(pushToken: "test-push-token")

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
        await store.registerDevice(pushToken: "test-push-token")

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
        await store.registerDevice(pushToken: "test-push-token")

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
    func deleteDeviceClearsState() async {
        // Given
        let api = StubNotificationsAPIClient()
        let store = makeStore(api: api)
        await store.registerDevice(pushToken: "test-push-token")
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
        let api = StubNotificationsAPIClient()
        let keychain = InMemoryKeychain()
        let store = NotificationsDataStore(
            api: api,
            keychain: keychain,
            pushNotificationEnvironment: PushNotificationEnvironment(readAuthStatus: { .authorized }, requestAuthorization: { true }, registerForRemoteNotifications: {})
        )
        await store.registerDevice(pushToken: "test-push-token")
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
        await store.registerDevice(pushToken: "test-push-token")

        // When
        let update = NotificationPreferencesUpdate(lineIds: ["victoria", "jubilee"], schedulePreset: .weekends)
        await store.updatePreferences(update)

        // Then
        #expect(store.preferences?.lineIds == ["victoria", "jubilee"])
        #expect(store.preferences?.schedulePreset == .weekends)
        #expect(!store.isSavingPreferences)
        #expect(api.updatePreferencesCallCount == 1)
    }

    @Test
    func updatePreferencesFailureRollsBack() async {
        // Given
        let api = StubNotificationsAPIClient()
        let store = makeStore(api: api)
        await store.registerDevice(pushToken: "test-push-token")
        let originalPreferences = store.preferences

        // When – update fails
        api.updatePreferencesError = HTTPError.invalidRequestURL
        let update = NotificationPreferencesUpdate(lineIds: ["victoria"], schedulePreset: .anytime)
        await store.updatePreferences(update)

        // Then – preferences roll back to what they were before the update
        #expect(store.preferences == originalPreferences)
        #expect(!store.isSavingPreferences)
    }


    // MARK: - Authorization status

    @Test
    func updateAuthorizationStatusReflectsInjectedStatus() async {
        // Given
        let store = makeStore(authorizationStatus: .denied)

        // When
        await store.updateAuthorizationStatus()

        // Then
        #expect(store.authorizationStatus == .denied)
    }


    // MARK: - Pending preferences update

    @Test
    func scheduledPreferencesUpdateIsAppliedAfterRegistration() async {
        // Given
        let api = StubNotificationsAPIClient()
        let store = makeStore(api: api)
        let update = NotificationPreferencesUpdate(lineIds: ["victoria"], schedulePreset: .weekends)

        // When – schedule an update before the APNs token arrives
        store.schedulePreferencesUpdate(update)
        await store.registerDevice(pushToken: "test-push-token")

        // Then – update is applied instead of fetching defaults
        #expect(api.updatePreferencesCallCount == 1)
        #expect(api.fetchPreferencesCallCount == 0)
        #expect(store.preferences?.lineIds == ["victoria"])
        #expect(store.preferences?.schedulePreset == .weekends)
    }

    @Test
    func scheduledPreferencesUpdateIsConsumedOnce() async {
        // Given
        let api = StubNotificationsAPIClient()
        let store = makeStore(api: api)
        let update = NotificationPreferencesUpdate(lineIds: ["victoria"], schedulePreset: .weekends)
        store.schedulePreferencesUpdate(update)

        // When – register twice (second registration is a no-op due to isRegistering guard,
        // but if called after the first completes it should not re-apply the pending update)
        await store.registerDevice(pushToken: "test-push-token")
        await store.registerDevice(pushToken: "test-push-token")

        // Then – update was only applied once
        #expect(api.updatePreferencesCallCount == 1)
    }


    // MARK: - Helpers

    private func makeStore(
        api: StubNotificationsAPIClient = StubNotificationsAPIClient(),
        authorizationStatus: UNAuthorizationStatus = .authorized
    ) -> NotificationsDataStore {
        NotificationsDataStore(
            api: api,
            keychain: InMemoryKeychain(),
            authorizationProvider: PushNotificationEnvironment(readAuthStatus: { authorizationStatus }, requestAuthorization: { true }, registerForRemoteNotifications: {})
        )
    }
}


// MARK: - In-memory keychain for tests

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
