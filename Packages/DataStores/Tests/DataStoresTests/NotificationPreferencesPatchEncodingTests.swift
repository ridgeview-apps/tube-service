import Foundation
import Models
import Testing

@testable import DataStores

struct NotificationPreferencesPatchEncodingTests {

    @Test
    func unsetFieldsAreOmittedRatherThanSentAsNull() throws {
        // Given
        let patch = NotificationPreferencesPatch(lines: [
            "victoria": NotificationLinePreferencePatch(enabled: false)
        ])

        // When
        let json = try encodeToJSONObject(patch)

        // Then – in a merge patch, null would delete the field, so unset fields must be absent
        let victoria = try #require((json["lines"] as? [String: Any])?["victoria"] as? [String: Any])
        #expect(victoria.count == 1)
        #expect(victoria["enabled"] as? Bool == false)
    }

    @Test
    func removedLineIsSentAsNull() throws {
        // Given
        // A nil value in a dictionary literal keeps the key, unlike assigning nil through a subscript.
        let patch = NotificationPreferencesPatch(lines: ["central": nil])

        // When
        let json = try encodeToJSONObject(patch)

        // Then
        let lines = try #require(json["lines"] as? [String: Any])
        #expect(lines.keys.contains("central"))
        #expect(lines["central"] is NSNull)
    }

    @Test
    func fieldNamesAreSnakeCasedButLineIdsAreUnchanged() throws {
        // Given
        let patch = NotificationPreferencesPatch(lines: [
            "hammersmith-city": NotificationLinePreferencePatch(
                severityThreshold: .minorDelays,
                notifyRecoveries: true
            )
        ])

        // When
        let json = try encodeToJSONObject(patch)

        // Then
        let lines = try #require(json["lines"] as? [String: Any])
        let line = try #require(lines["hammersmith-city"] as? [String: Any])
        #expect(Set(line.keys) == ["severity_threshold", "notify_recoveries"])
        #expect(line["severity_threshold"] as? String == "minor_delays")
    }


    // MARK: - Helpers

    private func encodeToJSONObject(_ patch: NotificationPreferencesPatch) throws -> [String: Any] {
        let data = try TubeServiceAPIClient.makeJSONEncoder().encode(patch)
        return try #require(try JSONSerialization.jsonObject(with: data, options: [.fragmentsAllowed]) as? [String: Any])
    }
}
