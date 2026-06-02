import Models
import SwiftUI

struct JourneyResultsHeaderView: View {

    @Binding var fromLocation: JourneyLocationPicker.Value?
    @Binding var toLocation: JourneyLocationPicker.Value?
    let viaLocation: JourneyLocationPicker.Value?
    let isSwapDisabled: Bool
    var collapseProgress: CGFloat = 0
    let onSwapLocations: () -> Void

    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @State private var hasSwappedLocations = false
    @Namespace private var animationNamespace

    private var fromToSpacing: CGFloat {
        lerp(from: 44, to: 8, progress: collapseProgress)
    }

    private var verticalPadding: CGFloat {
        lerp(from: 16, to: 6, progress: collapseProgress)
    }

    private var titleScale: CGFloat {
        lerp(from: 1, to: 0.8, progress: collapseProgress)
    }

    private func lerp(from start: CGFloat, to end: CGFloat, progress: CGFloat) -> CGFloat {
        start + (end - start) * progress
    }

    var body: some View {
        VStack(spacing: 0) {
            if horizontalSizeClass != .regular { Divider() }
            journeyStartToEndTitle
            if horizontalSizeClass != .regular { Divider() }
        }
        .padding(.horizontal, horizontalSizeClass == .regular ? 16 : 0)
    }

    private var journeyStartToEndTitle: some View {
        VStack(alignment: .leading) {
            if let fromLocation {
                JourneyLocationTitleLabel(value: fromLocation)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .swapValuesGeometryEffectID(
                        .firstPairItem("locationsPair"),
                        isSwapped: hasSwappedLocations,
                        in: animationNamespace
                    )
                    .routeAnchor(.from)
            }

            Spacer().frame(height: fromToSpacing)

            VStack(alignment: .leading, spacing: 4) {
                if let toLocation {
                    JourneyLocationTitleLabel(value: toLocation)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .swapValuesGeometryEffectID(
                            .secondPairItem("locationsPair"),
                            isSwapped: hasSwappedLocations,
                            in: animationNamespace
                        )
                        .routeAnchor(.to)
                }

                if let viaLocation {
                    HStack(spacing: 0) {
                        Text(.journeyResultsViaTitle)
                        JourneyLocationTitleLabel(value: viaLocation)
                            .bold()
                    }
                    .font(.caption2)
                    .opacity(1 - collapseProgress)
                    .frame(height: lerp(from: 14, to: 0, progress: collapseProgress))
                    .clipped()
                }
            }
        }
        .lineLimit(1)
        .font(.headline)
        .scaleEffect(titleScale, anchor: .leading)
        .routeIndicatorOverlay(leadingOffset: 28, leadingPadding: 56) {
            swapLocationsButton
        }
        .padding(.vertical, verticalPadding)
        .padding(.horizontal, horizontalSizeClass == .regular ? 12 : 0)
        .background(Color.defaultCellBackground)
        .clipShape(RoundedRectangle(cornerRadius: horizontalSizeClass == .regular ? 14 : 0, style: .continuous))
    }

    private var swapLocationsButton: some View {
        JourneyPlannerSwapButton(
            isSwapped: $hasSwappedLocations,
            valueA: $fromLocation,
            valueB: $toLocation
        )
        .disabled(isSwapDisabled || collapseProgress >= 1)
        .opacity(1 - collapseProgress)
        .scaleEffect(lerp(from: 1, to: 0.6, progress: collapseProgress))
        .onChange(of: hasSwappedLocations) {
            onSwapLocations()
        }
    }
}

// MARK: - Previews

import ModelStubs

private struct Previewer: View {
    @State var fromLocation: JourneyLocationPicker.Value? = .station(
        ModelStubs.kingsCrossStation
    )
    @State var toLocation: JourneyLocationPicker.Value? = .station(
        ModelStubs.angelStation
    )
    var viaLocation: JourneyLocationPicker.Value?
    var isSwapDisabled: Bool = false

    var body: some View {
        JourneyResultsHeaderView(
            fromLocation: $fromLocation,
            toLocation: $toLocation,
            viaLocation: viaLocation,
            isSwapDisabled: isSwapDisabled,
            onSwapLocations: { print("Swap locations") }
        )
    }
}

#Preview("Default") {
    Previewer()
}

#Preview("With via location") {
    Previewer(
        viaLocation: .namedLocation(
            .init(
                name: .init(title: "Farringdon", subtitle: ""),
                coordinate: nil,
                isCurrentLocation: false
            )
        )
    )
}

#Preview("Current location") {
    Previewer(
        fromLocation: .currentLocation(
            name: .init(title: "Current location", subtitle: ""),
            coordinate: nil
        )
    )
}

#Preview("Swap disabled") {
    Previewer(isSwapDisabled: true)
}
