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
        await store.handlePushToken("test-push-token", appVersion: nil)

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
        await store.handlePushToken("test-push-token", appVersion: nil)

        // When
        try await store.enableDevice()

        // Then
        #expect(api.enableDeviceCallCount == 1)
    }

    @Test
    func deviceActionsThrowWithoutGeneratingDeviceIdWhenNotRegistered() async {
        // Given
        let api = StubNotificationsAPIClient()
        let keychain = InMemoryKeychain()
        let store = makeStore(api: api, keychain: keychain)

        // When / Then – each action fails without reaching the server
        await #expect(throws: NotificationsDataStoreError.deviceNotRegistered) { try await store.disableDevice() }
        await #expect(throws: NotificationsDataStoreError.deviceNotRegistered) { try await store.enableDevice() }
        await #expect(throws: NotificationsDataStoreError.deviceNotRegistered) {
            try await store.updateLinePreferences(with: NotificationPreferencesPatch(lines: ["victoria": nil]))
        }
        #expect(api.disableDeviceCallCount == 0)
        #expect(api.enableDeviceCallCount == 0)
        #expect(api.updatePreferencesCallCount == 0)
        #expect(keychain.read(key: "push_device_id") == nil)
    }

    @Test
    func handlePushTokenReusesExistingDeviceId() async {
        // Given – a device ID persisted by a previous launch
        let keychain = InMemoryKeychain()
        keychain.write(key: "push_device_id", value: "existing-device-id")
        let store = makeStore(keychain: keychain)

        // When
        await store.handlePushToken("test-push-token", appVersion: nil)

        // Then
        #expect(keychain.read(key: "push_device_id") == "existing-device-id")
        #expect(store.debugInfo.deviceId == "existing-device-id")
    }

    @Test
    func deleteDeviceClearsState() async throws {
        // Given
        let api = StubNotificationsAPIClient()
        let store = makeStore(api: api)
        let update = NotificationPreferencesUpdate(lines: [makePreferenceUpdate(lineId: "victoria", schedule: .anytime)])
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
        let update = NotificationPreferencesUpdate(lines: [makePreferenceUpdate(lineId: "victoria", schedule: .anytime)])
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

    @Test
    func deleteDeviceClearsStateWhenServerReturnsNotFound() async throws {
        // Given
        let api = StubNotificationsAPIClient()
        let keychain = InMemoryKeychain()
        let store = makeStore(api: api, keychain: keychain)
        await store.handlePushToken("test-push-token", appVersion: nil)
        #expect(store.state.device != nil)

        // When – the server has already lost the device
        api.deleteDeviceError = HTTPError.statusCode(404, nil)
        try await store.deleteDevice()

        // Then – local state and keychain are still cleared
        #expect(store.state.device == nil)
        #expect(store.state.registrationState == .notRegistered)
        #expect(keychain.read(key: "push_device_id") == nil)
    }

    @Test
    func deleteDeviceSkipsServerWhenNoDeviceIdExists() async throws {
        // Given
        let api = StubNotificationsAPIClient()
        let keychain = InMemoryKeychain()
        let store = makeStore(api: api, keychain: keychain)

        // When
        try await store.deleteDevice()

        // Then – no server call, and no device ID is generated as a side effect
        #expect(api.deleteDeviceCallCount == 0)
        #expect(keychain.read(key: "push_device_id") == nil)
        #expect(store.state.registrationState == .notRegistered)
    }


    // MARK: - Preferences

    @Test
    func updateLinePreferencesChangesOnlyTheListedLine() async throws {
        // Given – two configured lines
        let api = StubNotificationsAPIClient()
        let store = await makeOnboardedStore(
            api: api,
            lines: [
                makePreferenceUpdate(lineId: "victoria", schedule: .weekends),
                makePreferenceUpdate(lineId: "jubilee", schedule: .weekends, severityThreshold: .severeDelays)
            ]
        )
        let originalJubilee = store.state.preferences?.lines.first { $0.lineId == "jubilee" }

        // When
        try await store.updateLinePreferences(
            with: NotificationPreferencesPatch(lines: [
                "victoria": NotificationLinePreferencePatch(enabled: false)
            ])
        )

        // Then – the patched line is paused and the other is untouched
        let lines = try #require(store.state.preferences?.lines)
        #expect(lines.first { $0.lineId == "victoria" }?.enabled == false)
        #expect(lines.first { $0.lineId == "jubilee" } == originalJubilee)
        #expect(api.updatePreferencesCallCount == 1)
    }

    @Test
    func updateLinePreferencesRemovesLineSetToNil() async throws {
        // Given
        let store = await makeOnboardedStore(lines: [
            makePreferenceUpdate(lineId: "victoria", schedule: .weekends),
            makePreferenceUpdate(lineId: "jubilee", schedule: .weekends)
        ])

        // When
        try await store.updateLinePreferences(with: NotificationPreferencesPatch(lines: ["victoria": nil]))

        // Then
        #expect(store.state.preferences?.lines.map(\.lineId) == ["jubilee"])
    }

    @Test
    func updateLinePreferencesFailurePreservesOriginalPreferences() async throws {
        // Given
        let api = StubNotificationsAPIClient()
        let store = await makeOnboardedStore(api: api, lines: [makePreferenceUpdate(lineId: "victoria", schedule: .weekends)])
        let originalPreferences = store.state.preferences

        // When – patch fails
        api.updatePreferencesError = HTTPError.invalidRequestURL
        await #expect(throws: HTTPError.self) {
            try await store.updateLinePreferences(
                with: NotificationPreferencesPatch(lines: [
                    "victoria": NotificationLinePreferencePatch(enabled: false)
                ])
            )
        }

        // Then
        #expect(store.state.preferences == originalPreferences)
    }

    @Test
    func updateLinePreferences404ClearsStoredPushToken() async throws {
        // Given – device registered and push token stored
        let api = StubNotificationsAPIClient()
        let keychain = InMemoryKeychain()
        let store = makeStore(api: api, keychain: keychain)
        await store.handlePushToken("test-push-token", appVersion: nil)

        // When – patch returns 404 (device not found on server)
        api.updatePreferencesError = HTTPError.statusCode(404, nil)
        await #expect(throws: HTTPError.self) {
            try await store.updateLinePreferences(with: NotificationPreferencesPatch(lines: ["victoria": nil]))
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
            makePreferenceUpdate(lineId: "victoria", schedule: .weekends)
        ])

        // When – schedule an update before the APNs token arrives
        store.completeOnboarding(with: update)
        await store.handlePushToken("test-push-token", appVersion: nil)

        // Then – update is applied instead of fetching defaults
        #expect(api.replaceAllPreferencesCallCount == 1)
        #expect(api.fetchPreferencesCallCount == 0)
        #expect(store.state.preferences?.lines.map(\.lineId) == ["victoria"])
        #expect(store.state.preferences?.lines.first?.schedules == [NotificationScheduleSelection.weekends.schedule])
    }

    @Test
    func scheduledPreferencesUpdateIsConsumedOnce() async {
        // Given
        let api = StubNotificationsAPIClient()
        let store = makeStore(api: api)
        let update = NotificationPreferencesUpdate(lines: [
            makePreferenceUpdate(lineId: "victoria", schedule: .weekends)
        ])
        store.completeOnboarding(with: update)

        // When – register twice with the same token; second call is skipped by the token deduplication guard
        await store.handlePushToken("test-push-token", appVersion: nil)
        await store.handlePushToken("test-push-token", appVersion: nil)

        // Then – update was only applied once
        #expect(api.replaceAllPreferencesCallCount == 1)
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
        let update = NotificationPreferencesUpdate(lines: [makePreferenceUpdate(lineId: "victoria", schedule: .anytime)])

        // When – the user explicitly configures notifications again
        store.completeOnboarding(with: update)
        await store.handlePushToken("test-push-token", appVersion: nil)

        // Then – explicit setup clears suppression and registers a new device
        #expect(api.registerDeviceCallCount == 2)
        #expect(api.replaceAllPreferencesCallCount == 1)
    }

    @Test
    func onboardingPreferencesRetainedWhenApplyFails() async throws {
        // Given – device registered with a queued update
        let api = StubNotificationsAPIClient()
        let store = makeStore(api: api)
        let update = NotificationPreferencesUpdate(lines: [makePreferenceUpdate(lineId: "victoria", schedule: .anytime)])
        store.completeOnboarding(with: update)

        // When – registration succeeds but the queued apply fails (server down)
        api.replaceAllPreferencesError = HTTPError.connection(URLError(.notConnectedToInternet))
        await store.handlePushToken("test-push-token", appVersion: nil)

        // Then – the queued update is preserved so it retries on the next handlePushToken call
        api.replaceAllPreferencesError = nil
        await store.handlePushToken("new-push-token", appVersion: nil)
        #expect(api.replaceAllPreferencesCallCount == 2)
        #expect(store.state.preferences?.lines.map(\.lineId) == ["victoria"])
    }

    @Test
    func onboardingApply404ClearsStoredPushToken() async {
        // Given – onboarding complete, waiting for registration
        let api = StubNotificationsAPIClient()
        let keychain = InMemoryKeychain()
        let store = makeStore(api: api, keychain: keychain)
        store.completeOnboarding(with: NotificationPreferencesUpdate(lines: [makePreferenceUpdate(lineId: "victoria", schedule: .anytime)]))

        // When – registration succeeds but the server has lost the device by the time preferences are sent
        api.replaceAllPreferencesError = HTTPError.statusCode(404, nil)
        await store.handlePushToken("test-push-token", appVersion: nil)

        // Then – stored push token is cleared so the next APNs delivery forces re-registration
        #expect(keychain.read(key: "push_registered_token") == nil)
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
        let update = NotificationPreferencesUpdate(lines: [makePreferenceUpdate(lineId: "victoria", schedule: .anytime)])
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
        let update = NotificationPreferencesUpdate(lines: [makePreferenceUpdate(lineId: "jubilee", schedule: .anytime)])
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
                severityThreshold: .minorDelays,
                schedules: [NotificationScheduleSelection.anytime.schedule]
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
        let update = NotificationPreferencesUpdate(lines: [makePreferenceUpdate(lineId: "victoria", schedule: .anytime)])
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

    /// A registered store whose lines were set up through onboarding, the only path that sends a full set of lines.
    private func makeOnboardedStore(
        api: StubNotificationsAPIClient = StubNotificationsAPIClient(),
        lines: [NotificationLinePreferenceUpdate]
    ) async -> NotificationsDataStore {
        let store = makeStore(api: api)
        store.completeOnboarding(with: NotificationPreferencesUpdate(lines: lines))
        await store.handlePushToken("test-push-token", appVersion: nil)
        return store
    }

    private func makePreferenceUpdate(
        lineId: String,
        schedule: NotificationScheduleSelection,
        severityThreshold: NotificationSeverityThreshold = .minorDelays
    ) -> NotificationLinePreferenceUpdate {
        NotificationLinePreferenceUpdate(
            lineId: lineId,
            enabled: true,
            notifyRecoveries: true,
            severityThreshold: severityThreshold,
            schedules: [schedule.schedule]
        )
    }
}

private extension NotificationScheduleSelection {
    static let anytime = NotificationScheduleSelection(days: Set(NotificationWeekday.allCases), timeSlot: .allDay)
    static let weekends = NotificationScheduleSelection(days: Set(NotificationWeekday.weekend), timeSlot: .allDay)
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
