import Foundation
import Models
import SwiftUI

public struct JourneyModePickerView: View {
    
    @State private var minimumSelectionWarningID: ModeID?
    @Binding var selection: Set<ModeID>
    
    public init(selection: Binding<Set<ModeID>>) {
        self._selection = selection
    }

    public var body: some View {
        List {
            Section {
                ForEach(ModeID.allJourneyPlannerModeIDs.sortedBySortValue(), id: \.self) { modeID in
                    cell(forModeID: modeID)
                }
            } header: {
                sectionHeader
            }
        }
        .listStyle(.plain)
    }
    
    private var sectionHeader: some View {
        VStack(alignment: .leading) {
            Text(.journeyModePickerInstructionTitle)
            selectAllButton
        }
    }
    
    private func cell(forModeID modeID: ModeID) -> some View {
        Button {
            withAnimation {
                toggleSelection(forModeID: modeID)
            }
        } label: {
            HStack {
                leadingImage(forModeID: modeID)
                VStack(alignment: .leading) {
                    if minimumSelectionWarningID == modeID {
                        HStack(alignment: .top, spacing: 4) {
                            Text(.journeyModePickerMinimumSelectionWarning)
                        }
                        .font(.footnote)
                        .foregroundStyle(Color.adaptiveRed)
                    }
                    Text(modeID.localized)
                }
                Spacer()
                if selection.contains(modeID) {
                    Image(systemName: "checkmark")
                }
            }
        }
    }
    
    private func toggleSelection(forModeID modeID: ModeID) {
        let isDeselectingLastItem = selection.contains(modeID) && selection.count == 1
        guard !isDeselectingLastItem else {
            minimumSelectionWarningID = modeID
            return
        }
        
        minimumSelectionWarningID = nil
        if selection.contains(modeID) {
            selection.remove(modeID)
        } else {
            selection.insert(modeID)
        }
    }
    
    private func selectAll() {
        minimumSelectionWarningID = nil
        selection = Set(ModeID.allJourneyPlannerModeIDs)
    }
    
    @ViewBuilder
    private func leadingImage(forModeID modeID: ModeID) -> some View {
        Group {
            switch modeID {
            case .tube:
                lineColourKeyView(with: TrainLineID.tubesOnly)
            case .dlr:
                lineColourKeyView(with: [.dlr])
            case .elizabethLine:
                lineColourKeyView(with: [.elizabeth])
            case .overground:
                lineColourKeyView(with: [.overground])
            default:
                modeID
                    .image
                    .resizable()
                    .scaledToFit()
                    .padding(4)
                    .foregroundStyle(modeID.foregroundColor ?? .blue)
            }
        }
        .frame(width: 40, height: 40)
    }
    
    private func lineColourKeyView(with lineIDs: [TrainLineID]) -> some View {
        LineColourKeyView(lineIDs: lineIDs)
            .roundedBorder(.white)
    }
    
    private var selectAllButton: some View {
        HStack {
            Spacer()
            Button {
                selectAll()
            } label: {
                Text(.journeyModePickerSelectAllButtonTitle)
            }
        }
    }
}

private extension Sequence where Element == ModeID {
    func sortedBySortValue() -> [ModeID] {
        sorted {
            $0.sortValue < $1.sortValue
        }
    }
}

private extension TrainLineID {
    static var tubesOnly: [TrainLineID] {
        TrainLineID.allCases.filter {
            ![TrainLineID.elizabeth, .dlr, .elizabeth, .overground, .liberty, .lioness, .mildmay, .suffragette, .weaver, .windrush].contains($0)
        }
    }
}

private extension ModeID {
    
    var localized: LocalizedStringResource {
        let resource: LocalizedStringResource = switch self {
        case .bus:
            .journeyModePickerValueBus
        case .cableCar:
            .journeyModePickerValueCableCar
        case .dlr:
            .journeyModePickerValueDlr
        case .elizabethLine:
            .journeyModePickerValueElizabeth
        case .nationalRail:
            .journeyModePickerValueNationalRail
        case .overground:
            .journeyModePickerValueOverground
        case .riverBus:
            .journeyModePickerValueRiverBus
        case .tram:
            .journeyModePickerValueTram
        case .tube:
            .journeyModePickerValueTube
        case .walking:
            .journeyModePickerValueWalk
        case .cycle:
            .journeyModePickerValueCycle
        case .coach, .cycleHire, .interchangeKeepSitting, .interchangeSecure, .replacementBus,
             .riverTour, .taxi:
            .journeyModePickerValueInvalid
        }
        
        if resource == .journeyModePickerValueInvalid {
            assertionFailure("Missing string localization for mode: \(self)?")
        }
        
        return resource
    }
    
    var sortValue: Int {
        switch self {
        case .tube: 0
        case .dlr: 1
        case .elizabethLine: 2
        case .overground: 3
        case .nationalRail: 4
        case .bus: 6
        case .tram: 7
        case .cableCar: 8
        case .riverBus: 9
        case .walking: 10
        case .cycle: 11
        default: 999
        }
    }
}


// MARK: - Previews
private struct Previewer: View {
    @State var selection = Set(ModeID.defaultJourneyPlannerModeIDs)
    
    var body: some View {
        NavigationStack {
            JourneyModePickerView(selection: $selection)
                .navigationTitle("Preview")
        }
    }
}

#Preview {
    Previewer()
}
