import Foundation
import Models
import ModelStubs

#if DEBUG

    public final class StubNotificationsAPIClient: NotificationsAPIClientType, @unchecked Sendable {

        public init() {}

        public private(set) var invocations: [String] = []

        public private(set) var registerDeviceCallCount = 0
        public var stubbedDevice: HTTPResponse<NotificationDevice> = .success200(
            .init(
                deviceId: UUID().uuidString,
                platform: "ios",
                enabled: true,
                appVersion: nil,
                appVariant: "stub",
                createdAt: .now,
                updatedAt: .now,
                lastSeenAt: .now
            )
        )
        public var registerDeviceError: Error?
        public func registerDevice(deviceId: String, pushToken: String, appVersion: String?) async throws -> HTTPResponse<NotificationDevice> {
            registerDeviceCallCount += 1
            invocations.append("registerDevice")
            if let registerDeviceError { throw registerDeviceError }
            return stubbedDevice
        }

        public private(set) var deleteDeviceCallCount = 0
        public var deleteDeviceError: Error?
        public func deleteDevice(deviceId: String) async throws {
            deleteDeviceCallCount += 1
            invocations.append("deleteDevice")
            if let deleteDeviceError { throw deleteDeviceError }
        }

        public private(set) var disableDeviceCallCount = 0
        public var disableDeviceError: Error?
        public func disableDevice(deviceId: String) async throws -> HTTPResponse<NotificationDevice> {
            disableDeviceCallCount += 1
            invocations.append("disableDevice")
            if let disableDeviceError { throw disableDeviceError }
            stubbedDevice = makeDeviceResponse(enabled: false)
            return stubbedDevice
        }

        public private(set) var enableDeviceCallCount = 0
        public var enableDeviceError: Error?
        public func enableDevice(deviceId: String) async throws -> HTTPResponse<NotificationDevice> {
            enableDeviceCallCount += 1
            invocations.append("enableDevice")
            if let enableDeviceError { throw enableDeviceError }
            stubbedDevice = makeDeviceResponse(enabled: true)
            return stubbedDevice
        }

        public private(set) var fetchPreferencesCallCount = 0
        public var stubbedPreferences: HTTPResponse<NotificationPreferences> = .success200(
            .init(
                deviceId: UUID().uuidString,
                lines: [],
                createdAt: .now,
                updatedAt: .now
            )
        )
        public var fetchPreferencesError: Error?
        public func fetchPreferences(deviceId: String) async throws -> HTTPResponse<NotificationPreferences> {
            fetchPreferencesCallCount += 1
            invocations.append("fetchPreferences")
            if let fetchPreferencesError { throw fetchPreferencesError }
            return stubbedPreferences
        }

        public private(set) var updatePreferencesCallCount = 0
        public var updatePreferencesError: Error?
        public func updatePreferences(deviceId: String, update: NotificationPreferencesUpdate) async throws -> HTTPResponse<NotificationPreferences> {
            updatePreferencesCallCount += 1
            invocations.append("updatePreferences")
            if let updatePreferencesError { throw updatePreferencesError }
            let updated = NotificationPreferences(
                deviceId: deviceId,
                lines: update.lines.map { lineUpdate in
                    NotificationLinePreference(
                        lineId: lineUpdate.lineId,
                        enabled: lineUpdate.enabled,
                        severityThreshold: lineUpdate.severityThreshold,
                        notifyRecoveries: lineUpdate.notifyRecoveries,
                        schedulePreset: lineUpdate.schedulePreset,
                        customSchedules: lineUpdate.customSchedules
                    )
                },
                createdAt: stubbedPreferences.decodedModel.createdAt,
                updatedAt: .now
            )
            stubbedPreferences = .success200(updated)
            return stubbedPreferences
        }

        private func makeDeviceResponse(enabled: Bool) -> HTTPResponse<NotificationDevice> {
            let current = stubbedDevice.decodedModel
            return .success200(
                NotificationDevice(
                    deviceId: current.deviceId,
                    platform: current.platform,
                    enabled: enabled,
                    appVersion: current.appVersion,
                    appVariant: current.appVariant,
                    createdAt: current.createdAt,
                    updatedAt: .now,
                    lastSeenAt: current.lastSeenAt
                )
            )
        }
    }

#endif
