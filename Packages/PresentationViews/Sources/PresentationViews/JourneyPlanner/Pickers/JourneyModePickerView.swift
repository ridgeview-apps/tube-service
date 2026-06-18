import Foundation
import Models
import SwiftUI

public struct JourneyModePickerView: View {

    @Binding var selection: Set<ModeID>

    public init(selection: Binding<Set<ModeID>>) {
        self._selection = selection
    }

    public var body: some View {
        List {
            Section {
                ForEach(ModeID.journeyPlannerModes.sortedBySortValue(), id: \.self) { modeID in
                    allModeCell(for: modeID)
                }
            } header: {
                Text(.journeyModePickerAllModesSectionTitle)
            }
        }
        .listStyle(.insetGrouped)
    }

    private func allModeCell(for modeID: ModeID) -> some View {
        Button {
            withAnimation {
                if selection.contains(modeID) {
                    selection.remove(modeID)
                } else {
                    selection.insert(modeID)
                }
            }
        } label: {
            HStack {
                if let lineIDs = modeID.pickerLineIDs {
                    LineColourKeyView(lineIDs: lineIDs)
                        .frame(width: 40, height: 40)
                        .roundedBorder(.white)
                } else {
                    modeID.image
                        .resizable()
                        .scaledToFit()
                        .padding(4)
                        .foregroundStyle(modeID.foregroundColor ?? .accentColor)
                        .frame(width: 40, height: 40)
                }
                Text(modeID.localized)
                    .foregroundStyle(Color.primary)
                Spacer()
                if selection.contains(modeID) {
                    Image(systemName: "checkmark")
                        .foregroundStyle(Color.accentColor)
                }
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Private display helpers

private extension ModeID {

    var pickerLineIDs: [TrainLineID]? {
        switch self {
        case .tube:
            return [
                .bakerloo, .central, .circle, .district, .hammersmithAndCity,
                .jubilee, .metropolitan, .northern, .piccadilly, .victoria, .waterlooAndCity
            ]
        case .dlr:
            return [.dlr]
        case .elizabethLine:
            return [.elizabeth]
        case .overground:
            return [.liberty, .lioness, .mildmay, .suffragette, .weaver, .windrush]
        default:
            return nil
        }
    }
}

// MARK: - ModeID display utilities

extension Sequence where Element == ModeID {
    func sortedBySortValue() -> [ModeID] {
        sorted {
            $0.sortValue < $1.sortValue
        }
    }
}

extension ModeID {

    var localized: LocalizedStringResource {
        let resource: LocalizedStringResource =
            switch self {
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
    @State var selection = JourneyModePreset.trainAndBus.modeIDs

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
