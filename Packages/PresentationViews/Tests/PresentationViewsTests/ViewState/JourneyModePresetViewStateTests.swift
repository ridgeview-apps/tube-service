import Models
import Testing

@testable import PresentationViews

struct JourneyModePresetViewStateTests {

    @Test
    func customSelectionsShareTheCustomChip() {
        let customChipID = JourneyModePreset.custom([]).chipID

        #expect(JourneyModePreset.custom([.bus]).chipID == customChipID)
        #expect(JourneyModePreset.custom([.bus, .cableCar]).chipID == customChipID)
    }

    @Test
    func fixedPresetsKeepTheirOwnChip() {
        #expect(JourneyModePreset.trainAndBus.chipID == .trainAndBus)
        #expect(JourneyModePreset.trainOnly.chipID == .trainOnly)
        #expect(JourneyModePreset.busOnly.chipID == .busOnly)
    }

    @Test
    func everyDisplayedChipHasItsOwnID() {
        let chipIDs = JourneyModePreset.displayCases.map(\.chipID)

        #expect(Set(chipIDs).count == chipIDs.count)
    }
}
