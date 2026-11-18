import Models
import SwiftUI

enum JourneyPlannerDestination: Hashable {
    case results
    case locationPicker(JourneyPlannerForm.FieldID.LocationID)
    case modePicker

    /// Discarding unsaved mode changes needs a confirmation, so the picker has its own cancel button.
    var hasOwnCloseButton: Bool {
        switch self {
        case .modePicker: true
        case .results, .locationPicker: false
        }
    }

    @MainActor
    @ViewBuilder
    var screen: some View {
        switch self {
        case .results:
            JourneyResultsScreen()
        case .locationPicker(let fieldID):
            JourneyLocationPickerScreen(fieldID: fieldID)
        case .modePicker:
            JourneyModePickerScreen()
        }
    }
}
