import Models
import SwiftUI

public struct JourneyPlannerTravelOptionsView: View {
    
    public enum Action {
        case viaLocationButtonTapped
    }
    
    @Binding var timeSelection: JourneyTimePickerSelection
    @Binding var viaLocation: JourneyLocationPicker.Value?
    
    let onAction: (Action) -> Void
    
    public var body: some View {
        DisclosureGroup {
            travelOptionsExpandedItemsView
        } label: {
            travelOptionsCollapsedLabelView
        }
    }
    
    private var travelOptionsCollapsedLabelView: some View {
        VStack(alignment: .leading) {
            Text("journey.planner.travel.options.label.title", bundle: .module)
            Text(travelOptionSubtitle)
                .lineLimit(3)
                .font(.caption)
                .foregroundStyle(.adaptiveMidGrey2)
        }
        .font(.subheadline)
        .multilineTextAlignment(.leading)
    }
    
    private var travelOptionsExpandedItemsView: some View {
        VStack {
            JourneyTimePickerView(selection: $timeSelection)
                .formDetailCell(title: "journey.planner.travel.options.when.label.title")
            JourneyLocationValueButton(value: $viaLocation) {
                onAction(.viaLocationButtonTapped)
            }
            .formDetailCell(title: "journey.planner.travel.options.via.label.title")
        }
        .listRowInsets(.init(top: 12, leading: 0, bottom: 12, trailing: 16))
    }
    
    var travelOptionSubtitle: String {
        [
         formattedTimeOption,
         formattedViaOption
        ]
        .compactMap { $0 }
        .joined(separator: ", ")
        .capitalizedFirstLetter()
    }
    
    private var formattedTimeOption: String {
        switch timeSelection.option {
        case .leaveNow:
            return NSLocalizedString("journey.planner.travel.options.detail.leave.now", bundle: .module, comment: "")
        case .leaveAt:
            let format = NSLocalizedString("journey.planner.travel.options.detail.leave.at %@", bundle: .module, comment: "")
            return String(format: format, timeSelection.formattedDate)
        case .arriveBy:
            let format = NSLocalizedString("journey.planner.travel.options.detail.arrive.by %@", bundle: .module, comment: "")
            return String(format: format, timeSelection.formattedDate)
        }
    }
    
    private var formattedViaOption: String? {
        guard let viaLocation else {
            return nil
        }
        let format = NSLocalizedString("journey.planner.travel.options.via %@", bundle: .module, comment: "")
        return String(format: format, viaLocation.localizedTitle)
    }
}


private extension String {
    func capitalizedFirstLetter() -> String {
        prefix(1).capitalized + dropFirst()
    }
}


// MARK: - Preview
private struct Previewer: View {
    @State var timeSelection: JourneyTimePickerSelection = .leaveNow()
    @State var viaLocation: JourneyLocationPicker.Value?
    var onAction: (JourneyPlannerTravelOptionsView.Action) -> Void = { print($0) }
    
    var body: some View {
        JourneyPlannerTravelOptionsView(timeSelection: $timeSelection,
                                        viaLocation: $viaLocation,
                                        onAction: onAction)
    }
}

#Preview {
    VStack {
        Previewer()
        Previewer(viaLocation: .station(ModelStubs.eastFinchleyStation))
        Previewer(timeSelection: .init(option: .leaveAt, date: .now + (60 * 60 * 24)))
    }
    .padding(.horizontal)
}
