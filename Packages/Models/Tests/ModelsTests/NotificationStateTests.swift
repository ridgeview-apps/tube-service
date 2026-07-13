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
            registrationState: .registered
        )

        state.reset()

        #expect(state.device == nil)
        #expect(state.preferences == nil)
        #expect(state.registrationState == .deregistered)
    }

    @Test
    func isConfiguredIsTrueWhenPendingSyncOrRegistered() {
        #expect(NotificationState(device: nil, preferences: nil, registrationState: .pendingSync(.init(lines: []))).isConfigured == true)
        #expect(NotificationState(device: nil, preferences: nil, registrationState: .registered).isConfigured == true)
        #expect(NotificationState(device: nil, preferences: nil, registrationState: .notRegistered).isConfigured == false)
        #expect(NotificationState(device: nil, preferences: nil, registrationState: .deregistered).isConfigured == false)
    }

}
