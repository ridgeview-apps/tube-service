import Models
import SwiftUI

struct JourneyPlannerFromToSelectionView: View {
    @Binding var form: JourneyPlannerForm
    let locationAccessoryStatus: JourneyLocationTitleLabel.AccessoryStatus
    let animationNamespace: Namespace.ID
    let onAction: (JourneyPlannerForm.Action) -> Void
    
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
        .padding(.leading, 44)
        .overlayPreferenceValue(RouteAnchorKey.self) { anchors in
            GeometryReader { proxy in
                if let fromAnchor = anchors[.from], let toAnchor = anchors[.to] {
                    let fromY = proxy[fromAnchor].midY
                    let toY = proxy[toAnchor].midY

                    routeIndicator(fromY: fromY, toY: toY)

                    if canShowSwapLocationsButton {
                        swapLocationsButton
                            .position(
                                x: 20,
                                y: (fromY + toY) / 2
                            )
                    }
                }
            }
        }
    }

    // swiftlint:disable identifier_name
    private func routeIndicator(fromY: CGFloat, toY: CGFloat) -> some View {
        let x: CGFloat = 20
        let dotSize: CGFloat = 10
        let dotRadius = dotSize / 2

        return ZStack {
            Path { path in
                path.move(to: CGPoint(x: x, y: fromY + dotRadius))
                path.addLine(to: CGPoint(x: x, y: toY - dotRadius))
            }
            .stroke(.quaternary, lineWidth: 2)

            Circle()
                .strokeBorder(lineWidth: 2)
                .frame(width: dotSize, height: dotSize)
                .foregroundStyle(.secondary)
                .position(x: x, y: fromY)

            Circle()
                .frame(width: dotSize, height: dotSize)
                .foregroundStyle(.secondary)
                .position(x: x, y: toY)
        }
    }
    // swiftlint:enable identifier_name
    
    private var fromLocationField: some View {
        JourneyLocationFormButton(style: buttonStyle(forFieldID: .from),
                                  value: $form.from,
                                  accessoryStatus: locationAccessoryStatus,
                                  placeholderText: .journeyPlannerFromPlaceholderTitle) {
            onAction(.tappedLocationField(.from))
        }
        .transformAnchorPreference(key: RouteAnchorKey.self, value: .bounds) { $0[.from] = $1 }
        .swapValuesGeometryEffectID(.firstPairItem("fromToFormFields"), isSwapped: isSwapped, in: animationNamespace)
        .formDetailCell(title: .journeyPlannerFromLabelTitle,
                        errors: inlineErrors(forFieldID: .from))
    }

    private var toLocationField: some View {
        JourneyLocationFormButton(style: buttonStyle(forFieldID: .to),
                                  value: $form.to,
                                  accessoryStatus: locationAccessoryStatus,
                                  placeholderText: .journeyPlannerToPlaceholderTitle) {
            onAction(.tappedLocationField(.to))
        }
        .transformAnchorPreference(key: RouteAnchorKey.self, value: .bounds) { $0[.to] = $1 }
        .swapValuesGeometryEffectID(.secondPairItem("fromToFormFields"), isSwapped: isSwapped, in: animationNamespace)
        .formDetailCell(title: .journeyPlannerToLabelTitle,
                        errors: inlineErrors(forFieldID: .to))
    }
    
    private func buttonStyle(forFieldID fieldID: JourneyPlannerForm.FieldID.LocationID) -> JourneyLocationFormButton.Style {
        if let errors = inlineErrors(forFieldID: fieldID), !errors.isEmpty {
            return .error
        }
        return .normal
    }
    
    private func inlineErrors(forFieldID fieldID: JourneyPlannerForm.FieldID.LocationID) -> [String]? {
        guard form.showsInlineErrors else { return nil }
        return form.validate().errors[.location(fieldID)]
    }
    
    @ViewBuilder
    private var swapLocationsButton: some View {
        SwapValuesButton(isSwapped: $isSwapped,
                         valueA: $form.from,
                         valueB: $form.to)
        .font(.system(size: 12, weight: .semibold))
        .foregroundStyle(Color.accentColor)
        .frame(width: 30, height: 30)
        .background {
            Circle()
                .fill(Color.defaultCellBackground)
            Circle()
                .fill(Color.accentColor.opacity(0.12))
            Circle()
                .strokeBorder(Color.accentColor.opacity(0.3), lineWidth: 1.5)
        }
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
    static func reduce(value: inout [RouteAnchorID: Anchor<CGRect>],
                       nextValue: () -> [RouteAnchorID: Anchor<CGRect>]) {
        value.merge(nextValue(), uniquingKeysWith: { $1 })
    }
}


// MARK: - Previews

import ModelStubs

private struct Previewer: View {
    @State var form: JourneyPlannerForm = .init()
    var locationAccessoryStatus: JourneyLocationTitleLabel.AccessoryStatus = .loadingState(.loaded)
    var onAction: (JourneyPlannerForm.Action) -> Void = { print($0) }
    @Namespace private var animationNamespace
    
    var body: some View {
        JourneyPlannerFromToSelectionView(form: $form,
                                          locationAccessoryStatus: locationAccessoryStatus,
                                          animationNamespace: animationNamespace,
                                          onAction: onAction)
    }
}

#Preview("Swap button visible") {
    Previewer(
        form: .init(from: .unknownCurrentLocation,
                    to: .station(ModelStubs.eastFinchleyStation))
    )
}

#Preview("No swap button") {
    Previewer(form: .init())
}
