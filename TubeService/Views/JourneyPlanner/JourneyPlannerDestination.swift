import Models
import SwiftUI

enum JourneyPlannerDestination: Hashable {
    case results
    case locationPicker(JourneyPlannerForm.FieldID.LocationID)
    case modePicker

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
