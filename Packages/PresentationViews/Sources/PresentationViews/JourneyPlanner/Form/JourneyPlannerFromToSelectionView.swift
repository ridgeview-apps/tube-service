import ModelStubs
import Models
import SwiftUI

struct JourneyPlannerFromToSelectionView: View {
    @Binding var form: JourneyPlannerForm
    let locationAccessoryStatus: JourneyLocationTitleLabel.AccessoryStatus
    let animationNamespace: Namespace.ID
    let onAction: (JourneyPlannerForm.Action) -> Void

    private let routeIndicatorDotSize: CGFloat = 10
    private var routeIndicatorDotRadius: CGFloat { routeIndicatorDotSize / 2.0 }

    enum Action {
        case locationButtonTapped(JourneyPlannerForm.FieldID.LocationID)
        case swapLocations
    }

    @State private var isSwapped = false

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            fromLocationField
            toLocationField
        }
        .padding(.trailing, 44)
        .overlayPreferenceValue(RouteAnchorKey.self) { anchors in
            routeIndicatorSideOverlay(anchors: anchors)
        }
    }

    @ViewBuilder
    private func routeIndicatorSideOverlay(
        anchors: [RouteAnchorID: Anchor<CGRect>]
    ) -> some View {
        GeometryReader { proxy in
            if let fromAnchor = anchors[.from], let toAnchor = anchors[.to] {
                let fromY = proxy[fromAnchor].midY
                let toY = proxy[toAnchor].midY
                let positionX = proxy.size.width - 20

                routeIndicator(
                    x: positionX,
                    fromY: fromY,
                    toY: toY
                )
                .transaction { $0.animation = nil }

                if canShowSwapLocationsButton {
                    swapLocationsButton
                        .position(
                            x: positionX,
                            y: (fromY + toY) / 2
                        )
                }
            }
        }
    }

    // swiftlint:disable identifier_name
    private func routeIndicator(
        x: CGFloat,
        fromY: CGFloat,
        toY: CGFloat
    ) -> some View {
        ZStack {
            Path { path in
                path.move(to: CGPoint(x: x, y: fromY + routeIndicatorDotRadius))
                path.addLine(
                    to: CGPoint(x: x, y: toY - routeIndicatorDotRadius)
                )
            }
            .stroke(.quaternary, lineWidth: 2)

            Circle()
                .strokeBorder(lineWidth: 2)
                .frame(
                    width: routeIndicatorDotSize,
                    height: routeIndicatorDotSize
                )
                .foregroundStyle(.secondary)
                .position(x: x, y: fromY)

            Circle()
                .frame(
                    width: routeIndicatorDotSize,
                    height: routeIndicatorDotSize
                )
                .foregroundStyle(.secondary)
                .position(x: x, y: toY)
        }
    }
    // swiftlint:enable identifier_name

    private var fromLocationField: some View {
        JourneyLocationFormButton(
            style: buttonStyle(forFieldID: .from),
            value: $form.from,
            accessoryStatus: locationAccessoryStatus,
            placeholderText: .journeyPlannerFromPlaceholderTitle
        ) {
            onAction(.tappedLocationField(.from))
        }
        .transformAnchorPreference(key: RouteAnchorKey.self, value: .bounds) {
            $0[.from] = $1
        }
        .swapValuesGeometryEffectID(
            .firstPairItem("fromToFormFields"),
            isSwapped: isSwapped,
            in: animationNamespace
        )
        .formDetailCell(
            title: .journeyPlannerFromLabelTitle,
            errors: inlineErrors(forFieldID: .from)
        )
    }

    private var toLocationField: some View {
        JourneyLocationFormButton(
            style: buttonStyle(forFieldID: .to),
            value: $form.to,
            accessoryStatus: locationAccessoryStatus,
            placeholderText: .journeyPlannerToPlaceholderTitle
        ) {
            onAction(.tappedLocationField(.to))
        }
        .transformAnchorPreference(key: RouteAnchorKey.self, value: .bounds) {
            $0[.to] = $1
        }
        .swapValuesGeometryEffectID(
            .secondPairItem("fromToFormFields"),
            isSwapped: isSwapped,
            in: animationNamespace
        )
        .formDetailCell(
            title: .journeyPlannerToLabelTitle,
            errors: inlineErrors(forFieldID: .to)
        )
    }

    private func buttonStyle(
        forFieldID fieldID: JourneyPlannerForm.FieldID.LocationID
    ) -> JourneyLocationFormButton.Style {
        if let errors = inlineErrors(forFieldID: fieldID), !errors.isEmpty {
            return .error
        }
        return .normal
    }

    private func inlineErrors(
        forFieldID fieldID: JourneyPlannerForm.FieldID.LocationID
    ) -> [String]? {
        guard form.showsInlineErrors else { return nil }
        return form.validate().errors[.location(fieldID)]
    }

    @ViewBuilder
    private var swapLocationsButton: some View {
        JourneyPlannerSwapButton(
            isSwapped: $isSwapped,
            valueA: $form.from,
            valueB: $form.to
        )
    }

    private var canShowSwapLocationsButton: Bool {
        form.from != nil
            && form.to != nil
            && form.from != form.to
    }
}

// swiftlint:disable identifier_name
private enum RouteAnchorID: Hashable {
    case from, to
}
// swiftlint:enable identifier_name

private struct RouteAnchorKey: PreferenceKey {
    static var defaultValue: [RouteAnchorID: Anchor<CGRect>] = [:]
    static func reduce(
        value: inout [RouteAnchorID: Anchor<CGRect>],
        nextValue: () -> [RouteAnchorID: Anchor<CGRect>]
    ) {
        value.merge(nextValue(), uniquingKeysWith: { $1 })
    }
}

// MARK: - Previews

private struct Previewer: View {
    @State var form: JourneyPlannerForm = .init()
    var locationAccessoryStatus: JourneyLocationTitleLabel.AccessoryStatus =
        .loadingState(.loaded)
    var onAction: (JourneyPlannerForm.Action) -> Void = { print($0) }
    @Namespace private var animationNamespace

    var body: some View {
        JourneyPlannerFromToSelectionView(
            form: $form,
            locationAccessoryStatus: locationAccessoryStatus,
            animationNamespace: animationNamespace,
            onAction: onAction
        )
    }
}

#Preview("Swap button visible") {
    Previewer(
        form: .init(
            from: .unknownCurrentLocation,
            to: .station(ModelStubs.eastFinchleyStation)
        )
    )
}

#Preview("No swap button") {
    Previewer(form: .init())
}
