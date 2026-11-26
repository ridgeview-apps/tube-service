import ModelStubs
import Models
import Shared
import SwiftUI

public struct RecentJourneyItem: Hashable, Identifiable, Sendable {
    public let id: UUID
    public var fromLocation: JourneyLocationPicker.Value
    public var toLocation: JourneyLocationPicker.Value
    public let viaLocation: JourneyLocationPicker.Value?
    public var lastUsed: Date

    public init(
        id: UUID,
        fromLocation: JourneyLocationPicker.Value,
        toLocation: JourneyLocationPicker.Value,
        viaLocation: JourneyLocationPicker.Value?,
        lastUsed: Date
    ) {
        self.id = id
        self.fromLocation = fromLocation
        self.toLocation = toLocation
        self.viaLocation = viaLocation
        self.lastUsed = lastUsed
    }
}

struct RecentJourneyCell: View {

    @Binding var item: RecentJourneyItem
    let animationNamespace: Namespace.ID
    let onAction: () -> Void

    @State private var isSwapped = false

    var body: some View {
        HStack(alignment: .fromToCenter, spacing: 0) {
            JourneyPlannerSwapButton(
                isSwapped: $isSwapped,
                valueA: $item.fromLocation,
                valueB: $item.toLocation,
                style: .plain
            )
            .padding(.leading, 10)
            Button {
                withAnimation {
                    onAction()
                }
            } label: {
                buttonLabel
            }
            .accessibilityIdentifier(AccessibilityID.JourneyPlanner.recentJourney)
        }
    }

    var buttonLabel: some View {
        HStack(alignment: .fromToCenter) {
            VStack(alignment: .leading, spacing: 2) {
                journeyFromToLocation
                journeyViaLocation
            }
            .lineLimit(1)
            .routeIndicatorOverlay(leadingOffset: 14, leadingPadding: 28)
            Spacer()
            Image(systemName: "chevron.right")
                .font(.footnote.weight(.semibold))
                .foregroundStyle(.tertiary)
        }
        .contentShape(Rectangle())
        .padding(.vertical, 12)
        .padding(.trailing)
    }

    private var journeyFromToLocation: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(item.fromLocation.name)
                .frame(maxWidth: .infinity, alignment: .leading)
                .swapValuesGeometryEffectID(
                    .firstPairItem("\(item.id)"),
                    isSwapped: isSwapped,
                    in: animationNamespace
                )
                .routeAnchor(.from)
            Text(item.toLocation.name)
                .frame(maxWidth: .infinity, alignment: .leading)
                .swapValuesGeometryEffectID(
                    .secondPairItem("\(item.id)"),
                    isSwapped: isSwapped,
                    in: animationNamespace
                )
                .routeAnchor(.to)
        }
        .font(.subheadline)
        .foregroundStyle(.primary)
        .alignmentGuide(.fromToCenter) { $0[VerticalAlignment.center] }
    }

    @ViewBuilder
    private var journeyViaLocation: some View {
        if let viaLocation = item.viaLocation {
            HStack {
                Text(.recentJourneyCellVia(viaLocation.name))
                Spacer()
            }
            .font(.caption)
            .foregroundStyle(.secondary)
        }
    }
}

extension VerticalAlignment {
    private enum FromToCenter: AlignmentID {
        static func defaultValue(in context: ViewDimensions) -> CGFloat {
            context[VerticalAlignment.center]
        }
    }

    fileprivate static let fromToCenter = VerticalAlignment(FromToCenter.self)
}

// MARK: - Previews

private struct Previewer: View {

    @State var recentJourneyItems: [RecentJourneyItem]
    @Namespace private var animationNamespace
    var onAction: () -> Void = { print("Button tapped") }

    var body: some View {
        List {
            ForEach($recentJourneyItems) { $recentJourneyItem in
                RecentJourneyCell(
                    item: $recentJourneyItem,
                    animationNamespace: animationNamespace,
                    onAction: onAction
                )
            }
            .listRowInsets(EdgeInsets())
        }
        .listStyle(.insetGrouped)
        .buttonStyle(.plain)
    }
}

#Preview {
    Previewer(
        recentJourneyItems: [
            .init(
                id: UUID(),
                fromLocation: .station(ModelStubs.eastFinchleyStation),
                toLocation: .station(ModelStubs.kingsCrossStation),
                viaLocation: nil,
                lastUsed: .distantPast
            ),
            .init(
                id: UUID(),
                fromLocation: .station(ModelStubs.angelStation),
                toLocation: .station(ModelStubs.eastFinchleyStation),
                viaLocation: .station(ModelStubs.kingsCrossStation),
                lastUsed: .distantPast
            )
        ]
    )
}
