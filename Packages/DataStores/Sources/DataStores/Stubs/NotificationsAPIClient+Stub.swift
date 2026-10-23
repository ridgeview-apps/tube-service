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
                        schedules: lineUpdate.schedules
                    )
                },
                createdAt: stubbedPreferences.decodedModel.createdAt,
                updatedAt: .now
            )
            stubbedPreferences = .success200(updated)
            return stubbedPreferences
        }

        public private(set) var patchPreferencesCallCount = 0
        public private(set) var lastPatch: NotificationPreferencesPatch?
        public var patchPreferencesError: Error?
        public func patchPreferences(deviceId: String, patch: NotificationPreferencesPatch) async throws -> HTTPResponse<NotificationPreferences> {
            patchPreferencesCallCount += 1
            lastPatch = patch
            invocations.append("patchPreferences")
            if let patchPreferencesError { throw patchPreferencesError }
            let current = stubbedPreferences.decodedModel
            // Mirrors the server's merge: listed lines change, others are kept, and `nil` removes a line.
            var lines = current.lines.compactMap { line -> NotificationLinePreference? in
                guard let entry = patch.lines[line.lineId] else { return line }
                guard let linePatch = entry else { return nil }
                return NotificationLinePreference(
                    lineId: line.lineId,
                    enabled: linePatch.enabled ?? line.enabled,
                    severityThreshold: linePatch.severityThreshold ?? line.severityThreshold,
                    notifyRecoveries: linePatch.notifyRecoveries ?? line.notifyRecoveries,
                    schedules: linePatch.schedules ?? line.schedules
                )
            }
            let existingLineIds = Set(current.lines.map(\.lineId))
            for (lineId, entry) in patch.lines.sorted(by: { $0.key < $1.key }) where !existingLineIds.contains(lineId) {
                guard let linePatch = entry,
                    let enabled = linePatch.enabled,
                    let severityThreshold = linePatch.severityThreshold,
                    let notifyRecoveries = linePatch.notifyRecoveries,
                    let schedules = linePatch.schedules
                else { continue }
                lines.append(
                    NotificationLinePreference(
                        lineId: lineId,
                        enabled: enabled,
                        severityThreshold: severityThreshold,
                        notifyRecoveries: notifyRecoveries,
                        schedules: schedules
                    )
                )
            }
            stubbedPreferences = .success200(
                NotificationPreferences(
                    deviceId: deviceId,
                    timezone: current.timezone,
                    lines: lines,
                    createdAt: current.createdAt,
                    updatedAt: .now
                )
            )
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
