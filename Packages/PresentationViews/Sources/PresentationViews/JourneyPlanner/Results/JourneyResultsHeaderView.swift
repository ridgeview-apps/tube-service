import Models
import SwiftUI

struct JourneyResultsHeaderView: View {

    @Binding var fromLocation: JourneyLocationPicker.Value?
    @Binding var toLocation: JourneyLocationPicker.Value?
    let viaLocation: JourneyLocationPicker.Value?
    let isSwapDisabled: Bool
    let onSwapLocations: () -> Void

    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @State private var hasSwappedLocations = false
    @Namespace private var animationNamespace

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

            Spacer().frame(height: 44)

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
                }
            }
        }
        .lineLimit(1)
        .font(.headline)
        .routeIndicatorOverlay(leadingOffset: 28, leadingPadding: 56) {
            swapLocationsButton
        }
        .padding(.vertical)
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
        .disabled(isSwapDisabled)
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
