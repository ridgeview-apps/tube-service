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
                ForEach(ModeID.journeyPlannerModeIDs.sortedBySortValue(), id: \.self) { modeID in
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
            Text("journey.mode.picker.instruction.title", bundle: .module)
            HStack {
                Spacer()
                Button {
                    selectAll()
                } label: {
                    Text("journey.mode.picker.select.all.button.title", bundle: .module)
                }
            }
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
                            Text("journey.mode.picker.minimum.selection.warning", bundle: .module)
                        }
                        .font(.footnote)
                        .foregroundStyle(Color.adaptiveRed)
                    }
                    Text(modeID.localizedStringKey, bundle: .module)
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
        selection = Set(ModeID.journeyPlannerModeIDs)
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
                Text("journey.mode.picker.select.all.button.title", bundle: .module)
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
            ![TrainLineID.elizabeth, .dlr, .elizabeth, .overground].contains($0)
        }
    }
}

private extension ModeID {
    
    var localizedStringKey: LocalizedStringKey {
        switch self {
        case .bus:
            return "journey.mode.picker.value.bus"
        case .cableCar:
            return "journey.mode.picker.value.cable.car"
        case .dlr:
            return "journey.mode.picker.value.dlr"
        case .elizabethLine:
            return "journey.mode.picker.value.elizabeth"
        case .nationalRail:
            return "journey.mode.picker.value.national.rail"
        case .overground:
            return "journey.mode.picker.value.overground"
        case .riverBus:
            return "journey.mode.picker.value.river.bus"
        case .tram:
            return "journey.mode.picker.value.tram"
        case .tube:
            return "journey.mode.picker.value.tube"
        case .walking:
            return "journey.mode.picker.value.walk"
        case .cycle:
            return "journey.mode.picker.value.cycle"
        case .coach, .cycleHire, .interchangeKeepSitting, .interchangeSecure, .replacementBus,
             .riverTour, .taxi:
            assertionFailure("Missing string localization \(self)?")
            return ""
        }
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
    @State var selection = Set(ModeID.journeyPlannerModeIDs)
    
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
