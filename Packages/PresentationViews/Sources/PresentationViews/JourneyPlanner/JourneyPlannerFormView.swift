import Models
import SwiftUI

public struct JourneyPlannerFormView: View {
    
    @Binding var form: JourneyPlannerForm
    
    var onAction: (JourneyPlannerForm.Action) -> Void = { _ in }
    
    let currentLocationAccessoryStatus: JourneyCurrentLocationAccessoryStatus
    
    @Namespace private var animationNamespace
    
    private let swapButtonSize = CGSize(width: 44, height: 44)

    @State private var swapAnimationIDs = false // This is just used for animation purposes
    
    private let timestampFormatter: DateFormatter = Formatter.relative(dateStyle: .medium, timeStyle: .short)
    
    public init(form: Binding<JourneyPlannerForm>,
                onAction: @escaping (JourneyPlannerForm.Action) -> Void,
                currentLocationAccessoryStatus: JourneyCurrentLocationAccessoryStatus = .omitted) {
        self._form = form
        self.onAction = onAction
        self.currentLocationAccessoryStatus = currentLocationAccessoryStatus
    }
    
    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                locationsSelectionView
                submitButton
                    .padding(.horizontal)
                    .padding(.top, 8)
            }
            .withDefaultMaxWidth()
        }
        .defaultScrollContentBackgroundColor()
        .scrollBounceBehavior(.basedOnSize)
    }
    
    private var locationsSelectionView: some View {
        VStack {
            HStack(spacing: 0) {
                VStack {
                    row(for: .from,
                        title: "journey.planner.from.button.title",
                        action: .select(.from),
                        showClearButton: form.from != nil)
                    Divider()
                    row(for: .to,
                        title: "journey.planner.to.button.title",
                        action: .select(.to),
                        showClearButton: form.to != nil)
                }
                swapLocationsButton
            }
            Divider()
                .padding(.trailing, form.isValid ? swapButtonSize.width : 0)
            row(for: .timeOption,
                title: "journey.planner.when.button.title",
                action: .select(.timeOption),
                showClearButton: false)
            .padding(.trailing, form.isValid ? swapButtonSize.width : 0)
        }
        .padding(.vertical, 16)
        .padding(.leading, 16)
        .padding(.trailing, form.isValid ? 0 : 16)
        .background(Color.defaultCellBackground)
    }
    
    private var timeOptionSelectionView: some View {
        HStack {
            Spacer()
            valueButton(for: .timeOption, action: .select(.timeOption))
                .frame(minHeight: 44)
        }
    }
    
    @ViewBuilder
    private var swapLocationsButton: some View {
        if form.isValid {
            JourneyPlannerSwapButton {
                swapAnimationIDs.toggle()
                form.swapLocations()
            }
            .frame(width: 44, height: 44)
        }
    }
    

    private func row(
        for selectionFieldID: JourneyPlannerForm.FieldID,
        title: LocalizedStringKey,
        action: JourneyPlannerForm.Action,
        showClearButton: Bool = false
    ) -> some View {
        VStack(spacing: 0) {
            HStack {
                Text(title, bundle: .module)
                    .font(.footnote)
                Spacer()
                valueButton(for: selectionFieldID, action: action)
                    .overlay(alignment: .trailing) {
                        if showClearButton {
                            clearButton(for: selectionFieldID)
                        }
                    }
            }
            .frame(minHeight: 44)
        }
    }
    
    private func valueButton(
        for selectionFieldID: JourneyPlannerForm.FieldID,
        action: JourneyPlannerForm.Action
    ) -> some View {
        Button {
            onAction(action)
        } label: {
            Group {
                switch selectionFieldID {
                case .from:
                    if swapAnimationIDs {
                        valueLabel(forLocationPickerValue: form.from)
                            .matchedGeometryEffect(id: "locationField1", in: animationNamespace)
                    } else {
                        valueLabel(forLocationPickerValue: form.from)
                            .matchedGeometryEffect(id: "locationField2", in: animationNamespace)
                    }
                case .to:
                    if swapAnimationIDs {
                        valueLabel(forLocationPickerValue: form.to)
                            .matchedGeometryEffect(id: "locationField2", in: animationNamespace)
                    } else {
                        valueLabel(forLocationPickerValue: form.to)
                            .matchedGeometryEffect(id: "locationField1", in: animationNamespace)
                    }
                case .timeOption:
                    valueLabel(forTimeOption: form.timeOption)
                }
            }
            .foregroundStyle(form.validate().errorFields.contains(selectionFieldID) ? .adaptiveRed : .accentColor)
            .lineLimit(1)
            .padding(4)
        }
        .buttonStyle(.bordered)
        .buttonBorderShape(.capsule)
        .font(.subheadline)
    }
    
    private func clearButton(for selectionFieldID: JourneyPlannerForm.FieldID) -> some View {
        Button {
            withAnimation {
                onAction(.clear(selectionFieldID))
            }
        } label: {
            Image(systemName: "multiply.circle.fill")
                .padding(.horizontal, 4)
                .frame(height: 44)
        }
        .foregroundStyle(.darkGrey1)
        .offset(x: 4, y: -18)
    }
    
    @ViewBuilder
    private func valueLabel(forLocationPickerValue value: JourneyLocationPicker.Value?) -> some View {
        if let value {
            JourneyLocationValueTitleLabel(value: value,
                                           style: .form(currentLocationAccessoryStatus))
        } else {
            Text("journey.planner.location.value.unselected", bundle: .module)
        }
    }
      
    @ViewBuilder
    private func valueLabel(forTimeOption timeOption: JourneyPlannerForm.TimeOption) -> some View {
        HStack(spacing: 4) {
            Image(systemName: "clock")
            Group {
                switch timeOption {
                case .leaveNow:
                    Text("journey.planner.when.value.leave.now", bundle: .module)
                case .leaveAt(let date):
                    Text("journey.planner.when.value.leave.at \(timestampFormatter.string(from: date))", bundle: .module)
                case .arriveBy(let date):
                    Text("journey.planner.when.value.arrive.at \(timestampFormatter.string(from: date))", bundle: .module)
                }
            }
        }
    }
    
    private var submitButton: some View {
        Button {
            onAction(.submit)
        } label: {
            Text("journey.planner.show.journeys.button.title", bundle: .module)
        }
        .buttonStyle(.primary)
        .disabled(!form.isValid)
    }
}

private extension Sequence where Element == ModeID {
    func commaSeparatedValue() -> String {
        map {
            NSLocalizedString($0.journeyPlannerStringKey, bundle: .module, comment: "")
        }
        .joined(separator: ", ")
    }
}

private extension ModeID {
    
    var journeyPlannerStringKey: String {
        switch self {
        case .bus:
            return "journey.planner.mode.value.bus"
        case .cableCar:
            return "journey.planner.mode.value.cable.car"
        case .dlr:
            return "journey.planner.mode.value.dlr"
        case .elizabethLine:
            return "journey.planner.mode.value.elizabeth"
        case .nationalRail:
            return "journey.planner.mode.value.national.rail"
        case .overground:
            return "journey.planner.mode.value.overground"
        case .riverBus:
            return "journey.planner.mode.value.river.bus"
        case .tram:
            return "journey.planner.mode.value.tram"
        case .tube:
            return "journey.planner.mode.value.tube"
        case .coach, .cycle, .cycleHire, .interchangeKeepSitting, .interchangeSecure, .replacementBus,
             .riverTour, .taxi, .walking:
            assertionFailure("Missing string localization?")
            return ""
        }
    }
}

private struct Previewer: View {
    @State var form: JourneyPlannerForm
    var currentLocationAccessoryStatus: JourneyCurrentLocationAccessoryStatus = .omitted
    
    var body: some View {
        JourneyPlannerFormView(
            form: $form,
            onAction: { print("Action \($0)") },
            currentLocationAccessoryStatus: currentLocationAccessoryStatus
        )
    }
}

#Preview("Default form") {
    Previewer(form: .default)
}

#Preview("Valid form") {
    Previewer(
        form: .init(
            from: .currentLocation(name: "Piccadilly"),
            to: .station(ModelStubs.kingsCrossStation),
            timeOption: .leaveNow,
            modeOption: .specific([.bus, .cableCar, .nationalRail])
        )
    )
}

#Preview("Invalid form (location loading error)") {
    Previewer(
        form: .init(from: .currentLocation(name: nil)),
        currentLocationAccessoryStatus: .loadingState(.failure(errorMessage: ""))
    )
}
