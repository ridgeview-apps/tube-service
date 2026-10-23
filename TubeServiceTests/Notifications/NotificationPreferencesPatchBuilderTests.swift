import DataStores
import Models
import PresentationViews
import Testing

@testable import Tube_Service

struct NotificationPreferencesPatchBuilderTests {

    @Test
    func setEnabledOnlyChangesEnabled() throws {
        // When
        let patch = NotificationPreferencesPatch.setEnabled(false, for: .victoria)

        // Then
        #expect(patch.lines.count == 1)
        let line = try #require(patch.lines["victoria"] ?? nil)
        #expect(line == NotificationLinePreferencePatch(enabled: false))
    }

    @Test
    func updateOnlyChangesUserEditableFields() throws {
        // Given
        let settings = LineNotificationSettings.defaultValue(lineID: .victoria, isEnabled: false)

        // When
        let patch = NotificationPreferencesPatch.update(settings)

        // Then – fields the user can't edit are left for the server to keep
        let line = try #require(patch.lines["victoria"] ?? nil)
        #expect(line.enabled == false)
        #expect(line.schedules == [settings.schedule.schedule])
        #expect(line.severityThreshold == nil)
        #expect(line.notifyRecoveries == nil)
    }

    @Test
    func addSetsEveryField() throws {
        // Given
        let settings = LineNotificationSettings.defaultValue(lineID: .hammersmithAndCity)

        // When
        let patch = NotificationPreferencesPatch.add(settings)

        // Then – a new line must be fully specified
        let line = try #require(patch.lines["hammersmith-city"] ?? nil)
        #expect(line.enabled == true)
        #expect(line.severityThreshold == .minorDelays)
        #expect(line.notifyRecoveries == true)
        #expect(line.schedules == [settings.schedule.schedule])
    }

    @Test
    func removeSendsTheLineAsNil() {
        // When
        let patch = NotificationPreferencesPatch.remove(.central)

        // Then – the key is present with a nil value, which encodes as null
        #expect(patch.lines.keys.contains("central"))
        #expect(patch.lines["central"] == .some(nil))
    }
}
