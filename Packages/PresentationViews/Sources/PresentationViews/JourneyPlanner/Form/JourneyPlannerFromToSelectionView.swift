import Models
import SwiftUI

struct JourneyPlannerFromToSelectionView: View {
    @Binding var form: JourneyPlannerForm
    let locationAccessoryStatus: JourneyLocationValueButton.AccessoryStatus
    let onAction: (JourneyPlannerForm.Action) -> Void
    
    enum Action {
        case locationButtonTapped(JourneyPlannerForm.FieldID.LocationID)
        case swapLocations
    }
    
    @State private var isSwapped = false
    
    @Namespace private var animationNamespace
        
    var body: some View {
        VStack {
            HStack(spacing: 0) {
                VStack {
                    fromLocationField
                    Divider()
                    toLocationField
                }
                if canShowSwapLocationsButton {
                    swapLocationsButton
                }
            }
        }        
    }
    
    private var fromLocationField: some View {
        JourneyLocationValueButton(value: $form.from,
                                   hasErrors: form.hasErrors(for: .location(.from)),
                                   accessoryStatus: locationAccessoryStatus) {
            onAction(.tapLocationField(.from))
        }
        .swapValuesGeometryEffectID(.firstPairItem("locationsPair"), isSwapped: isSwapped, in: animationNamespace)
        .formDetailCell(title: "journey.planner.from.label.title")
    }
    
    private var toLocationField: some View {
        JourneyLocationValueButton(value: $form.to,
                                   hasErrors: form.hasErrors(for: .location(.to)),
                                   accessoryStatus: locationAccessoryStatus) {
            onAction(.tapLocationField(.to))
        }
        .swapValuesGeometryEffectID(.secondPairItem("locationsPair"), isSwapped: isSwapped, in: animationNamespace)
        .formDetailCell(title: "journey.planner.to.label.title")
    }
    
    @ViewBuilder
    private var swapLocationsButton: some View {
        SwapValuesButton(isSwapped: $isSwapped,
                         valueA: $form.from,
                         valueB: $form.to,
                         namespace: animationNamespace)
        .foregroundColor(Color.accentColor)
        .padding(.leading, 8)
        .frame(height: 44)
    }
    
    private var canShowSwapLocationsButton: Bool {
        form.isFieldValid(.location(.from)) && form.isFieldValid(.location(.to))
    }
}


// MARK: - Previews
private struct Previewer: View {
    @State var form: JourneyPlannerForm = .init()
    var locationAccessoryStatus: JourneyLocationValueButton.AccessoryStatus = .loadingState(.loaded)
    var onAction: (JourneyPlannerForm.Action) -> Void = { print($0) }
    
    var body: some View {
        JourneyPlannerFromToSelectionView(form: $form,
                                          locationAccessoryStatus: locationAccessoryStatus,
                                          onAction: onAction)
    }
}

#Preview("Swap button visible") {
    Previewer(
        form: .init(from: .currentLocation(.unknown),
                    to: .station(ModelStubs.eastFinchleyStation))
    )
}

#Preview("Error state") {
    Previewer(form: .init())
}
