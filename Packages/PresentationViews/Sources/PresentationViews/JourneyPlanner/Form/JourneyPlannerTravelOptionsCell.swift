import Models
import SwiftUI

public struct JourneyPlannerTravelOptionsCell: View {
    
    public enum Action {
        case tappedViaLocationButton
    }

    @Binding var isExpanded: Bool
    @Binding var timeSelection: JourneyTimePickerSelection
    @Binding var viaLocation: JourneyLocationPicker.Value?
    
    let onAction: (Action) -> Void
    
    public var body: some View {
        DisclosureGroup(isExpanded: $isExpanded) {
            expandedItemsView
        } label: {
            labelView
        }
        .listRowSeparator(.hidden)
    }
    
    private var labelView: some View {
        VStack(alignment: .leading) {
            Text(.journeyPlannerTravelOptionsMainLabelTitle)
                .font(.subheadline)
                if !travelOptionSubtitle.isEmpty {
                    Text(travelOptionSubtitle)
                        .font(.footnote)
                        .foregroundStyle(Color.accentColor)
                        .lineLimit(2)
                }
        }
    }
    
    private var expandedItemsView: some View {
        VStack(alignment: .leading, spacing: 12) {
            viaLocationCell
            timePickerCell
        }
        .listRowInsets(.init(top: 0, leading: 0, bottom: 12, trailing: 20))
    }

    private var viaLocationCell: some View {
        JourneyLocationFormButton(value: $viaLocation,
                                  placeholderText: .journeyPlannerTravelOptionsViaPlaceholderTitle) {
            onAction(.tappedViaLocationButton)
        }
        .formDetailCell(title: .journeyPlannerViaLabelTitle)
    }
    
    private var timePickerCell: some View {
        JourneyTimePickerView(selection: $timeSelection)
            .formDetailCell(title: .journeyPlannerTravelOptionsWhenLabelTitle)
    }
    
    private var travelOptionSubtitle: String {
        [
         formattedTimeOption,
         formattedViaOption
        ]
        .compactMap { $0 }
        .joined(separator: ", ")
        .capitalizedFirstLetter()
    }
    
    private var formattedTimeOption: String? {
        switch timeSelection.option {
        case .leaveNow:
            return nil
        case .leaveAt:
            return String(localized: .journeyPlannerTravelOptionsDetailLeaveAt(timeSelection.formattedDate))
        case .arriveBy:
            return String(localized: .journeyPlannerTravelOptionsDetailArriveBy(timeSelection.formattedDate))
        }
    }
    
    private var formattedViaOption: String? {
        guard let viaLocation else {
            return nil
        }
        return String(localized: .journeyPlannerTravelOptionsVia(viaLocation.name))
        
    }
}

private extension String {
    func capitalizedFirstLetter() -> String {
        prefix(1).capitalized + dropFirst()
    }
}


// MARK: - Previews

import ModelStubs


private struct Previewer: View {
    @State var isExpanded = false
    @State var timeSelection: JourneyTimePickerSelection = .leaveNow()
    @State var viaLocation: JourneyLocationPicker.Value?
    var onAction: (JourneyPlannerTravelOptionsCell.Action) -> Void = { print($0) }
    
    var body: some View {
        JourneyPlannerTravelOptionsCell(isExpanded: $isExpanded, timeSelection: $timeSelection,
                                        viaLocation: $viaLocation,
                                        onAction: onAction)
    }
}

#Preview {
    List {
        Previewer()
        Previewer(viaLocation: .station(ModelStubs.eastFinchleyStation))
        Previewer(timeSelection: .init(option: .leaveAt, date: .now + (60 * 60 * 24)))
    }
    .listStyle(.plain)
}
