import Models
import SwiftUI

struct JourneyModeFilterStrip: View {

    @Binding var selectedPreset: JourneyModePreset
    let isDisabled: Bool
    let onCustomTapped: () -> Void

    var body: some View {
        // The remembered chip can be off screen, e.g. "More…" at larger text sizes
        FilterChipRow(initiallyVisibleID: selectedPreset.chipID) {
            ForEach(JourneyModePreset.displayCases, id: \.chipID) { preset in
                presetChip(for: preset)
            }
        }
        .background(Color.defaultCellBackground)
    }

    private func presetChip(for preset: JourneyModePreset) -> some View {
        let isSelected = preset.chipID == selectedPreset.chipID
        return Button {
            if preset.isCustom {
                onCustomTapped()
            } else {
                withAnimation(.snappy) {
                    selectedPreset = preset
                }
            }
        } label: {
            Text(isSelected && preset.isCustom ? selectedPreset.label : preset.label)
        }
        .disabled(isDisabled && !preset.isCustom)
        .buttonStyle(.filterChip(isSelected: isSelected))
    }
}

// MARK: - Previews

private struct Previewer: View {
    @State var selectedPreset: JourneyModePreset = .trainAndBus

    var body: some View {
        JourneyModeFilterStrip(
            selectedPreset: $selectedPreset,
            isDisabled: false,
            onCustomTapped: { print("custom tapped") }
        )
    }
}

#Preview {
    Previewer()
}
