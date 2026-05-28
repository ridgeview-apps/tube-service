import SwiftUI

struct JourneyPlannerViaChip: View {

    @Binding var via: JourneyLocationPicker.Value?
    let onTap: () -> Void

    var body: some View {
        if let via {
            filledChip(via: via)
        } else {
            emptyChip
        }
    }

    private func filledChip(via: JourneyLocationPicker.Value) -> some View {
        HStack(spacing: 4) {
            Button {
                onTap()
            } label: {
                Text(.journeyPlannerTravelOptionsVia(via.name))
            }

            Button {
                withAnimation {
                    self.via = nil
                }
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .imageScale(.small)
            }
            .foregroundStyle(Color.accentColor.opacity(0.6))
        }
        .font(.subheadline)
        .lineLimit(1)
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .foregroundStyle(Color.accentColor)
        .background(Color.accentColor.opacity(0.12), in: Capsule())
    }

    private var emptyChip: some View {
        Button {
            onTap()
        } label: {
            HStack(spacing: 4) {
                Image(systemName: "plus")
                    .imageScale(.small)
                Text(.journeyPlannerViaLabelTitle)
            }
            .font(.subheadline)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .foregroundStyle(.secondary)
            .background(Color(.tertiarySystemFill), in: Capsule())
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Previews

import ModelStubs

#Preview("Empty") {
    JourneyPlannerViaChip(
        via: .constant(nil),
        onTap: {}
    )
}

#Preview("Filled") {
    JourneyPlannerViaChip(
        via: .constant(.station(ModelStubs.eastFinchleyStation)),
        onTap: {}
    )
}
