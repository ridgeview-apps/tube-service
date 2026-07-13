import Foundation
import Models
import Testing

struct NotificationStateTests {

    @Test
    func resetClearsAllFields() {
        let date = Date(timeIntervalSince1970: 0)
        let device = NotificationDevice(
            deviceId: "abc",
            platform: "ios",
            enabled: true,
            appVersion: "1.0",
            appVariant: nil,
            createdAt: date,
            updatedAt: date,
            lastSeenAt: date
        )
        let preferences = NotificationPreferences(
            deviceId: "abc",
            lines: [],
            createdAt: date,
            updatedAt: date
        )
        var state = NotificationState(
            device: device,
            preferences: preferences,
            hasCompletedOnboarding: true,
            hasUserDeletedDevice: false,
            pendingPreferencesUpdate: NotificationPreferencesUpdate(lines: [])
        )

        state.reset()

        #expect(state.device == nil)
        #expect(state.preferences == nil)
        #expect(state.hasCompletedOnboarding == false)
        #expect(state.hasUserDeletedDevice == true)
        #expect(state.pendingPreferencesUpdate == nil)
    }

    @Test
    func completeOnboardingSetsAllFields() {
        var state = NotificationState(
            device: nil,
            preferences: nil,
            hasCompletedOnboarding: false,
            hasUserDeletedDevice: true
        )
        let update = NotificationPreferencesUpdate(lines: [])

        state.completeOnboarding(with: update)

        #expect(state.hasCompletedOnboarding == true)
        #expect(state.hasUserDeletedDevice == false)
        #expect(state.pendingPreferencesUpdate == update)
    }
}
