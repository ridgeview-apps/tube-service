import Models
import Shared
import SwiftUI

/// A chip per line group, pinned at the top of the Station screen at stations with more than one line group.
struct StationLineChipsView: View {

    let lineGroups: [Station.LineGroup]
    let selectedLineGroup: Station.LineGroup
    /// Line groups with at least one disrupted line, which get a badge.
    var disruptedLineGroupIDs: Set<Station.LineGroup.ID> = []
    let onSelect: (Station.LineGroup) -> Void

    // The pinned header can be rebuilt while the page scrolls, so this stops it snapping back after a manual scroll
    @State private var hasScrolledToSelection = false

    // Matches the Journey Planner's mode filter strip, so chips look the same across the app
    var body: some View {
        HStack(spacing: 0) {
            Image(systemName: "line.3.horizontal.decrease")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .padding(.leading, 16)
                .accessibilityHidden(true)
            ScrollViewReader { proxy in
                ScrollView(.horizontal) {
                    HStack(spacing: 8) {
                        ForEach(lineGroups) { lineGroup in
                            LineChip(
                                lineGroup: lineGroup,
                                isSelected: lineGroup == selectedLineGroup,
                                isDisrupted: disruptedLineGroupIDs.contains(lineGroup.id)
                            ) {
                                onSelect(lineGroup)
                            }
                        }
                    }
                    .padding(.leading, 10)
                    .padding(.trailing, 16)
                    .padding(.vertical, 8)
                }
                .scrollIndicators(.hidden)
                // A remembered chip can be off screen, e.g. the last of King's Cross's four.
                // Not `ScrollPosition`: its initial position isn't applied to this row, so it starts at the first chip
                .onAppear {
                    guard !hasScrolledToSelection else { return }
                    hasScrolledToSelection = true
                    proxy.scrollTo(selectedLineGroup.id, anchor: .center)
                }
            }
            .mask(
                HStack(spacing: 0) {
                    Rectangle()
                    LinearGradient(colors: [.black, .clear], startPoint: .leading, endPoint: .trailing)
                        .frame(width: 20)
                }
            )
        }
        // The row is pinned, so it stops growing where the Journey Planner's mode chips do
        .dynamicTypeSize(...DynamicTypeSize.accessibility2)
    }
}

private struct LineChip: View {
    let lineGroup: Station.LineGroup
    let isSelected: Bool
    let isDisrupted: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                LineColourBar(lineIDs: lineGroup.lineIds.sortedByName(), isOnAccent: isSelected)
                Text(lineGroup.shortName)
                    .lineLimit(1)
                    .accessibilityLabel(lineGroup.name)
            }
            .font(.subheadline)
            .padding(.horizontal, 10)
            .padding(.vertical, 7)
            .foregroundStyle(isSelected ? Color.white : Color.secondary)
            .background(isSelected ? Color.accentColor : .clear, in: Capsule())
            .overlay(Capsule().strokeBorder(isSelected ? .clear : Color.secondary.opacity(0.4), lineWidth: 1))
            .contentShape(Capsule())
            .overlay(alignment: .topTrailing) {
                if isDisrupted {
                    DisruptionBadge()
                }
            }
        }
        .buttonStyle(.plain)
        .accessibilityValue(isDisrupted ? Text(.stationLineChipDisrupted) : Text(verbatim: ""))
        .accessibilityIdentifier(AccessibilityID.Station.lineChip(lineGroup.id))
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}

/// The app's disruption icon, ringed in the background colour so it stands clear of the chip it overlaps.
private struct DisruptionBadge: View {
    @ScaledMetric(relativeTo: .subheadline) private var size: CGFloat = 14

    var body: some View {
        LineStatusAccessoryImageType.disruption.image
            .font(.system(size: size))
            .background(Circle().fill(Color.defaultBackground).padding(-1.5))
            // Scaled with the badge, so a larger badge doesn't cover more of the chip's name
            .offset(x: size * 0.35, y: -size * 0.35)
            .accessibilityHidden(true)
    }
}

/// One small bar with each line's colour stacked top to bottom, so every line group gets a marker of the same size.
struct LineColourBar: View {
    let lineIDs: [TrainLineID]
    /// A white outline keeps dark blue lines (e.g. Piccadilly) distinct from an accent-coloured background.
    var isOnAccent = false

    @ScaledMetric(relativeTo: .subheadline) private var height: CGFloat = 16

    private let shape = RoundedRectangle(cornerRadius: 2)

    var body: some View {
        VStack(spacing: 0) {
            ForEach(lineIDs, id: \.self) { lineID in
                Rectangle().fill(lineID.backgroundColor)
            }
        }
        .frame(width: height / 2, height: height)
        .clipShape(shape)
        .overlay(
            shape.stroke(
                isOnAccent ? AnyShapeStyle(.white) : AnyShapeStyle(.primary.opacity(0.35)),
                lineWidth: isOnAccent ? 1 : 0.5
            )
        )
        .accessibilityHidden(true)
    }
}

// MARK: - Previews

private struct ChipsPreview: View {
    @State var selected: Station.LineGroup
    var disruptedIndices: [Int] = []

    static let lineGroups: [Station.LineGroup] = [
        .init(atcoCode: "940GZZLUKSX", lineIds: [.circle, .hammersmithAndCity, .metropolitan]),
        .init(atcoCode: "940GZZLUKSX", lineIds: [.northern]),
        .init(atcoCode: "940GZZLUKSX", lineIds: [.piccadilly]),
        .init(atcoCode: "940GZZLUKSX", lineIds: [.victoria]),
        .init(atcoCode: "940GZZLUBST", lineIds: [.bakerloo, .circle, .hammersmithAndCity, .metropolitan])
    ]

    var body: some View {
        StationLineChipsView(
            lineGroups: Self.lineGroups,
            selectedLineGroup: selected,
            disruptedLineGroupIDs: Set(disruptedIndices.map { Self.lineGroups[$0].id }),
            onSelect: { selected = $0 }
        )
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    VStack(spacing: 0) {
        ChipsPreview(selected: ChipsPreview.lineGroups[0], disruptedIndices: [0, 3])
        ChipsPreview(selected: ChipsPreview.lineGroups[2])
        ChipsPreview(selected: ChipsPreview.lineGroups[4])
    }
    .background(Color.defaultBackground)
}
