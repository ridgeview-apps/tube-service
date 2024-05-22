import Models
import SwiftUI

struct JourneyPlannerFromToSelectionView: View {
    @Binding var form: JourneyPlannerForm
    let locationAccessoryStatus: JourneyLocationTitleLabel.AccessoryStatus
    let animationNamespace: Namespace.ID
    let onAction: (JourneyPlannerForm.Action) -> Void
    
    enum Action {
        case locationButtonTapped(JourneyPlannerForm.FieldID.LocationID)
        case swapLocations
    }
    
    @State private var isSwapped = false
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                fromLocationField
                toLocationField
            }
            if canShowSwapLocationsButton {
                swapLocationsButton
            }
        }
    }
    
    private func errorView(message: String) -> some View {
        HStack {
            Image(systemName: "exclamationmark.circle.fill")
            Text(message)
        }
        .foregroundColor(.adaptiveRed)
    }
    
    
    private var fromLocationField: some View {
        JourneyLocationFormButton(style: buttonStyle(forFieldID: .from),
                                  value: $form.from,
                                  accessoryStatus: locationAccessoryStatus,
                                  placeholderText: "journey.planner.from.placeholder.title") {
            onAction(.tappedLocationField(.from))
        }
        .swapValuesGeometryEffectID(.firstPairItem("fromToFormFields"), isSwapped: isSwapped, in: animationNamespace)
        .formDetailCell(errors: inlineErrors(forFieldID: .from))
    }
    
    private var toLocationField: some View {
        JourneyLocationFormButton(style: buttonStyle(forFieldID: .to),
                                  value: $form.to,
                                  accessoryStatus: locationAccessoryStatus,
                                  placeholderText: "journey.planner.to.placeholder.title") {
            onAction(.tappedLocationField(.to))
        }
        .swapValuesGeometryEffectID(.secondPairItem("fromToFormFields"), isSwapped: isSwapped, in: animationNamespace)
        .formDetailCell(title: "journey.planner.to.label.title",
                        errors: inlineErrors(forFieldID: .to))
    }
    
    private func buttonStyle(forFieldID fieldID: JourneyPlannerForm.FieldID.LocationID) -> JourneyLocationFormButton.Style {
        if let errors = inlineErrors(forFieldID: fieldID), !errors.isEmpty {
            return .error
        }
        return .normal
    }
    
    private func inlineErrors(forFieldID fieldID: JourneyPlannerForm.FieldID.LocationID) -> [String]? {
        guard form.showsInlineErrors else { return nil }
        return form.validate().errors[.location(fieldID)]
    }
    
    @ViewBuilder
    private var swapLocationsButton: some View {
        SwapValuesButton(isSwapped: $isSwapped,
                         valueA: $form.from,
                         valueB: $form.to)
        .foregroundColor(Color.accentColor)
        .frame(height: 44)
    }
    
    private var canShowSwapLocationsButton: Bool {
        form.from != nil
            && form.to != nil
            && form.from != form.to
    }
}


// MARK: - Previews

import ModelStubs

private struct Previewer: View {
    @State var form: JourneyPlannerForm = .init()
    var locationAccessoryStatus: JourneyLocationTitleLabel.AccessoryStatus = .loadingState(.loaded)
    var onAction: (JourneyPlannerForm.Action) -> Void = { print($0) }
    @Namespace private var animationNamespace
    
    var body: some View {
        JourneyPlannerFromToSelectionView(form: $form,
                                          locationAccessoryStatus: locationAccessoryStatus,
                                          animationNamespace: animationNamespace,
                                          onAction: onAction)
    }
}

#Preview("Swap button visible") {
    Previewer(
        form: .init(from: .unknownCurrentLocation,
                    to: .station(ModelStubs.eastFinchleyStation))
    )
}

#Preview("No swap button") {
    Previewer(form: .init())
}
