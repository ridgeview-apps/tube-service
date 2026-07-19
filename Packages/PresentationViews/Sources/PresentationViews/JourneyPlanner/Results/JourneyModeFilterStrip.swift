import Models
import SwiftUI

struct JourneyModeFilterStrip: View {

    @Binding var selectedPreset: JourneyModePreset
    let isDisabled: Bool
    let onCustomTapped: () -> Void

    var body: some View {
        HStack(spacing: 0) {
            Image(systemName: "line.3.horizontal.decrease")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .padding(.leading, 14)
                .padding(.vertical, 8)
            ScrollView(.horizontal) {
                HStack(spacing: 8) {
                    ForEach(JourneyModePreset.displayCases, id: \.self) { preset in
                        presetChip(for: preset)
                    }
                }
                .padding(.leading, 10)
                .padding(.trailing, 16)
                .padding(.vertical, 8)
            }
            .scrollIndicators(.hidden)
            .mask(
                HStack(spacing: 0) {
                    Rectangle()
                    LinearGradient(
                        colors: [.black, .clear],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .frame(width: 20)
                }
            )
        }
        .background(Color.defaultCellBackground)
    }

    private func presetChip(for preset: JourneyModePreset) -> some View {
        let isSelected: Bool = {
            if preset.isCustom { return selectedPreset.isCustom }
            return selectedPreset == preset
        }()
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
                .lineLimit(1)
                .font(.subheadline)
                .padding(.horizontal, 10)
                .padding(.vertical, 7)
                .foregroundStyle(isSelected ? Color.white : Color.secondary)
                .background(isSelected ? Color.accentColor : .clear, in: Capsule())
                .overlay(Capsule().strokeBorder(isSelected ? .clear : Color.secondary.opacity(0.4), lineWidth: 1))
        }
        .disabled(isDisabled && !preset.isCustom)
        .buttonStyle(.plain)
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
