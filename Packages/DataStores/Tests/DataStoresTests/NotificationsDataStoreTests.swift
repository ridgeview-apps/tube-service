import Foundation
import Models
import Testing

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


    // MARK: - Preferences

    @Test
    func fetchPreferencesSuccess() async {
        // Given
        let api = StubNotificationsAPIClient()
        let store = makeStore(api: api)

        // When
        #expect(store.preferences == nil)
        await store.fetchPreferences()

        // Then
        #expect(store.preferences != nil)
        #expect(!store.isFetchingPreferences)
        #expect(api.fetchPreferencesCallCount == 1)
    }

    @Test
    func fetchPreferencesFailurePreservesExisting() async {
        // Given
        let api = StubNotificationsAPIClient()
        let store = makeStore(api: api)
        await store.fetchPreferences()
        let originalPreferences = store.preferences
        #expect(originalPreferences != nil)

        // When – simulate failure on second fetch
        api.fetchPreferencesError = HTTPError.invalidRequestURL
        await store.fetchPreferences()

        // Then – existing preferences are preserved, not cleared
        #expect(store.preferences == originalPreferences)
    }

    @Test
    func updatePreferencesSuccess() async {
        // Given
        let api = StubNotificationsAPIClient()
        let store = makeStore(api: api)
        await store.fetchPreferences()

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
        await store.fetchPreferences()
        let originalPreferences = store.preferences

        // When – update fails
        api.updatePreferencesError = HTTPError.invalidRequestURL
        let update = NotificationPreferencesUpdate(lineIds: ["victoria"], schedulePreset: .anytime)
        await store.updatePreferences(update)

        // Then – preferences roll back to what they were before the update
        #expect(store.preferences == originalPreferences)
        #expect(!store.isSavingPreferences)
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

    private func makeStore(api: StubNotificationsAPIClient = StubNotificationsAPIClient()) -> NotificationsDataStore {
        .init(api: api, keychain: InMemoryKeychain())
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
