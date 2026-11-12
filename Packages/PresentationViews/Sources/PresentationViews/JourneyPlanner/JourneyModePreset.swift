import Models
import SwiftUI

extension JourneyModePreset {
    var label: LocalizedStringResource {
        switch self {
        case .trainAndBus: .journeyModePresetTrainAndBus
        case .trainOnly: .journeyModePresetTrainOnly
        case .busOnly: .journeyModePresetBusOnly
        case .custom(let modeIDs):
            modeIDs.isEmpty ? .journeyModePresetCustom : .journeyModePresetCustomModesCount(modeIDs.count)
        }
    }

    static var displayCases: [JourneyModePreset] {
        [.trainAndBus, .trainOnly, .busOnly, .custom([])]
    }

    /// Every custom selection shares the one "More…" chip, whichever modes it holds.
    var chipID: JourneyModePreset {
        isCustom ? .custom([]) : self
    }
}
