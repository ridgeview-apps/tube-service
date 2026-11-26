import Models
import SwiftUI

/// Switches Arrivals between trains and buses.
public struct ArrivalsModePicker: View {

    @Binding var selectedMode: ArrivalsMode

    public init(selectedMode: Binding<ArrivalsMode>) {
        self._selectedMode = selectedMode
    }

    public var body: some View {
        Picker(selection: $selectedMode) {
            ForEach(ArrivalsMode.allCases, id: \.self) { mode in
                Text(mode.title)
            }
        } label: {
            Text(.arrivalsModePickerLabel)
        }
        .pickerStyle(.segmented)
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }
}

private extension ArrivalsMode {
    var title: LocalizedStringResource {
        switch self {
        case .trains: .arrivalsModeTrains
        case .buses: .arrivalsModeBuses
        }
    }
}

// MARK: - Previews

#Preview(traits: .sizeThatFitsLayout) {
    @Previewable @State var selectedMode = ArrivalsMode.trains
    ArrivalsModePicker(selectedMode: $selectedMode)
        .background(Color.defaultBackground)
}
