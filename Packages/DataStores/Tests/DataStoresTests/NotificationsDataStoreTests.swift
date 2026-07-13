import Foundation
import Models
import Testing
import UserNotifications

@testable import DataStores


@MainActor
struct NotificationsDataStoreTests {

    // MARK: - Registration

    @Test
    func handlePushTokenSuccess() async throws {
        // Given
        let api = StubNotificationsAPIClient()
        let store = makeStore(api: api)

        // When
        await store.handlePushToken("test-push-token", appVersion: nil)

        // Then
        #expect(api.registerDeviceCallCount == 1)
    }

    @Test
    func handlePushTokenFailureDoesNotFetchPreferences() async {
        // Given
        let api = StubNotificationsAPIClient()
        api.registerDeviceError = HTTPError.invalidRequestURL
        let store = makeStore(api: api)

        // When
        await store.handlePushToken("test-push-token", appVersion: nil)

        // Then
        #expect(store.state.preferences == nil)
        #expect(api.registerDeviceCallCount == 1)
        #expect(api.fetchPreferencesCallCount == 0)
    }


    // MARK: - Device management

    @Test
    func disableDeviceCallsAPI() async throws {
        // Given
        let api = StubNotificationsAPIClient()
        let store = makeStore(api: api)

        // When
        try await store.disableDevice()

        // Then
        #expect(api.disableDeviceCallCount == 1)
    }

    @Test
    func enableDeviceCallsAPI() async throws {
        // Given
        let api = StubNotificationsAPIClient()
        let store = makeStore(api: api)

        // When
        try await store.enableDevice()

        // Then
        #expect(api.enableDeviceCallCount == 1)
    }

    @Test
    func deleteDeviceClearsState() async throws {
        // Given
        let api = StubNotificationsAPIClient()
        let store = makeStore(api: api)
        let update = NotificationPreferencesUpdate(lines: [makePreferenceUpdate(lineId: "victoria", schedulePreset: .anytime)])
        store.completeOnboarding(with: update)
        await store.handlePushToken("test-push-token", appVersion: nil)
        #expect(store.state.preferences != nil)

        // When
        try await store.deleteDevice()

        // Then
        #expect(store.state.preferences == nil)
        #expect(api.deleteDeviceCallCount == 1)
    }

    @Test
    func deleteDeviceClearsKeychainDeviceId() async throws {
        // Given
        let keychain = InMemoryKeychain()
        let store = makeStore(keychain: keychain)
        await store.handlePushToken("test-push-token", appVersion: nil)
        #expect(keychain.read(key: "push_device_id") != nil)

        // When
        try await store.deleteDevice()

        // Then – keychain entry is cleared so a fresh device ID is generated on re-registration
        #expect(keychain.read(key: "push_device_id") == nil)
    }

    @Test
    func deleteDeviceDoesNotClearStateOnFailure() async {
        // Given
        let api = StubNotificationsAPIClient()
        let store = makeStore(api: api)
        let update = NotificationPreferencesUpdate(lines: [makePreferenceUpdate(lineId: "victoria", schedulePreset: .anytime)])
        store.completeOnboarding(with: update)
        await store.handlePushToken("test-push-token", appVersion: nil)
        #expect(store.state.device != nil)
        #expect(store.state.preferences != nil)

        // When – delete fails
        api.deleteDeviceError = HTTPError.connection(URLError(.notConnectedToInternet))
        try? await store.deleteDevice()

        // Then – local state is preserved since the server-side delete didn't succeed
        #expect(store.state.device != nil)
        #expect(store.state.preferences != nil)
    }


    // MARK: - Preferences

    @Test
    func savePreferencesSuccess() async throws {
        // Given
        let api = StubNotificationsAPIClient()
        let store = makeStore(api: api)
        await store.handlePushToken("test-push-token", appVersion: nil)

        // When
        let update = NotificationPreferencesUpdate(lines: [
            makePreferenceUpdate(lineId: "victoria", schedulePreset: .weekends),
            makePreferenceUpdate(lineId: "jubilee", schedulePreset: .weekends)
        ])
        try await store.savePreferences(update: update)

        // Then
        #expect(store.state.preferences?.lines.map(\.lineId).sorted() == ["jubilee", "victoria"])
        #expect(store.state.preferences?.lines.allSatisfy { $0.schedulePreset == .weekends } == true)
        #expect(api.updatePreferencesCallCount == 1)
    }

    @Test
    func savePreferencesFailurePreservesOriginalPreferences() async throws {
        // Given
        let api = StubNotificationsAPIClient()
        let store = makeStore(api: api)
        await store.handlePushToken("test-push-token", appVersion: nil)
        let originalPreferences = store.state.preferences

        // When – update fails
        api.updatePreferencesError = HTTPError.invalidRequestURL
        let update = NotificationPreferencesUpdate(lines: [
            makePreferenceUpdate(lineId: "victoria", schedulePreset: .anytime)
        ])
        do {
            try await store.savePreferences(update: update)
        } catch {
            // expected
        }

        // Then – preferences are unchanged since the failed API call never wrote anything
        #expect(store.state.preferences == originalPreferences)
    }

    @Test
    func savePreferences404ClearsStoredPushToken() async throws {
        // Given – device registered and push token stored
        let api = StubNotificationsAPIClient()
        let keychain = InMemoryKeychain()
        let store = makeStore(api: api, keychain: keychain)
        await store.handlePushToken("test-push-token", appVersion: nil)
        #expect(keychain.read(key: "push_registered_token") == "test-push-token")

        // When – preferences update returns 404 (device not found on server)
        api.updatePreferencesError = HTTPError.statusCode(404, nil)
        do {
            try await store.savePreferences(update: NotificationPreferencesUpdate(lines: []))
        } catch {
            // expected
        }

        // Then – stored push token is cleared so the next APNs delivery forces re-registration
        #expect(keychain.read(key: "push_registered_token") == nil)
    }

    // MARK: - Authorization status

    @Test
    func updateAuthorizationStatusReflectsInjectedStatus() async {
        // Given
        let store = makeStore(pushNotificationEnvironment: .stub(authorizationStatus: .denied))

        // When
        await store.refreshAuthorizationStatus()

        // Then
        #expect(store.isPermissionDenied == true)
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
        store.completeOnboarding(with: update)
        await store.handlePushToken("test-push-token", appVersion: nil)

        // Then – update is applied instead of fetching defaults
        #expect(api.updatePreferencesCallCount == 1)
        #expect(api.fetchPreferencesCallCount == 0)
        #expect(store.state.preferences?.lines.map(\.lineId) == ["victoria"])
        #expect(store.state.preferences?.lines.first?.schedulePreset == .weekends)
    }

    @Test
    func scheduledPreferencesUpdateIsConsumedOnce() async {
        // Given
        let api = StubNotificationsAPIClient()
        let store = makeStore(api: api)
        let update = NotificationPreferencesUpdate(lines: [
            makePreferenceUpdate(lineId: "victoria", schedulePreset: .weekends)
        ])
        store.completeOnboarding(with: update)

        // When – register twice with the same token; second call is skipped by the token deduplication guard
        await store.handlePushToken("test-push-token", appVersion: nil)
        await store.handlePushToken("test-push-token", appVersion: nil)

        // Then – update was only applied once
        #expect(api.updatePreferencesCallCount == 1)
    }

    @Test
    func handlePushTokenSkippedWhenTokenUnchanged() async {
        // Given
        let api = StubNotificationsAPIClient()
        let keychain = InMemoryKeychain()
        let store = makeStore(api: api, keychain: keychain)
        await store.handlePushToken("test-push-token", appVersion: nil)
        #expect(api.registerDeviceCallCount == 1)

        // When – same token delivered again (e.g. on app resume)
        await store.handlePushToken("test-push-token", appVersion: nil)

        // Then – backend is not called again
        #expect(api.registerDeviceCallCount == 1)
    }

    @Test
    func handlePushTokenCalledAgainAfterTokenChanges() async {
        // Given
        let api = StubNotificationsAPIClient()
        let store = makeStore(api: api)
        await store.handlePushToken("token-v1", appVersion: nil)
        #expect(api.registerDeviceCallCount == 1)

        // When – APNs rotates the token
        await store.handlePushToken("token-v2", appVersion: nil)

        // Then – backend is called with the new token
        #expect(api.registerDeviceCallCount == 2)
    }

    @Test
    func deleteDeviceSuppressesAutomaticReregistrationWithSameToken() async throws {
        // Given
        let api = StubNotificationsAPIClient()
        let keychain = InMemoryKeychain()
        let store = makeStore(api: api, keychain: keychain)
        await store.handlePushToken("test-push-token", appVersion: nil)
        #expect(api.registerDeviceCallCount == 1)

        // When – device is deleted, then APNs delivers the same token again automatically
        try await store.deleteDevice()
        await store.handlePushToken("test-push-token", appVersion: nil)

        // Then – the user-initiated deletion is respected
        #expect(api.registerDeviceCallCount == 1)
    }

    @Test
    func deleteDeviceSuppressionPersistsAcrossStoreRestart() async throws {
        // Given
        let api = StubNotificationsAPIClient()
        let keychain = InMemoryKeychain()
        let userDefaults = UserDefaults(suiteName: UUID().uuidString)!
        let store = makeStore(api: api, keychain: keychain, userDefaults: userDefaults)
        await store.handlePushToken("test-push-token", appVersion: nil)
        try await store.deleteDevice()

        // When – a new store is created after app restart and receives a push token
        let restartedStore = makeStore(api: api, keychain: keychain, userDefaults: userDefaults, seedOnboarded: false)
        await restartedStore.handlePushToken("test-push-token", appVersion: nil)

        // Then – deletion still suppresses automatic registration
        #expect(api.registerDeviceCallCount == 1)
    }

    @Test
    func completingOnboardingAfterDeleteAllowsReregistration() async throws {
        // Given
        let api = StubNotificationsAPIClient()
        let store = makeStore(api: api)
        await store.handlePushToken("test-push-token", appVersion: nil)
        try await store.deleteDevice()
        let update = NotificationPreferencesUpdate(lines: [makePreferenceUpdate(lineId: "victoria", schedulePreset: .anytime)])

        // When – the user explicitly configures notifications again
        store.completeOnboarding(with: update)
        await store.handlePushToken("test-push-token", appVersion: nil)

        // Then – explicit setup clears suppression and registers a new device
        #expect(api.registerDeviceCallCount == 2)
        #expect(api.updatePreferencesCallCount == 1)
    }

    @Test
    func onboardingPreferencesRetainedWhenApplyFails() async throws {
        // Given – device registered with a queued update
        let api = StubNotificationsAPIClient()
        let store = makeStore(api: api)
        let update = NotificationPreferencesUpdate(lines: [makePreferenceUpdate(lineId: "victoria", schedulePreset: .anytime)])
        store.completeOnboarding(with: update)

        // When – registration succeeds but the queued apply fails (server down)
        api.updatePreferencesError = HTTPError.connection(URLError(.notConnectedToInternet))
        await store.handlePushToken("test-push-token", appVersion: nil)

        // Then – the queued update is preserved so it retries on the next handlePushToken call
        api.updatePreferencesError = nil
        await store.handlePushToken("new-push-token", appVersion: nil)
        #expect(api.updatePreferencesCallCount == 2)
        #expect(store.state.preferences?.lines.map(\.lineId) == ["victoria"])
    }


    // MARK: - hasConfiguredLines

    @Test
    func hasConfiguredLinesIsFalseWhenPreferencesNil() {
        let store = makeStore()
        #expect(store.hasConfiguredLines == false)
    }

    @Test
    func hasConfiguredLinesIsFalseWhenLinesEmpty() async {
        // Given – registered with preferences containing no lines
        let api = StubNotificationsAPIClient()
        let store = makeStore(api: api)
        store.completeOnboarding(with: NotificationPreferencesUpdate(lines: []))
        await store.handlePushToken("test-push-token", appVersion: nil)
        #expect(store.state.preferences?.lines.isEmpty == true)

        // Then
        #expect(store.hasConfiguredLines == false)
    }

    @Test
    func hasConfiguredLinesIsTrueWhenLinesPresent() async {
        // Given – stub returns preferences with one line
        let api = StubNotificationsAPIClient()
        let store = makeStore(api: api)
        let update = NotificationPreferencesUpdate(lines: [makePreferenceUpdate(lineId: "victoria", schedulePreset: .anytime)])
        store.completeOnboarding(with: update)
        await store.handlePushToken("test-push-token", appVersion: nil)

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
        store.completeOnboarding(with: update)
        await store.handlePushToken("test-push-token", appVersion: nil)

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
        store.completeOnboarding(with: update)
        await store.handlePushToken("test-push-token", appVersion: nil)

        // Then
        #expect(store.isNotifying(for: .victoria) == false)
    }

    @Test
    func isNotifyingReturnsTrueWhenLineEnabled() async {
        // Given – victoria is present and enabled
        let api = StubNotificationsAPIClient()
        let store = makeStore(api: api)
        let update = NotificationPreferencesUpdate(lines: [makePreferenceUpdate(lineId: "victoria", schedulePreset: .anytime)])
        store.completeOnboarding(with: update)
        await store.handlePushToken("test-push-token", appVersion: nil)

        // Then
        #expect(store.isNotifying(for: .victoria) == true)
    }


    // MARK: - Helpers

    private func makeStore(
        api: StubNotificationsAPIClient = StubNotificationsAPIClient(),
        pushNotificationEnvironment: PushNotificationEnvironment = .stub(),
        keychain: KeychainService = InMemoryKeychain(),
        userDefaults: UserDefaults = .init(suiteName: UUID().uuidString)!,
        seedOnboarded: Bool = true
    ) -> NotificationsDataStore {
        if seedOnboarded {
            userDefaults.notificationState = NotificationState(
                device: nil,
                preferences: nil,
                registrationState: .registered
            )
        }
        return NotificationsDataStore(
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
