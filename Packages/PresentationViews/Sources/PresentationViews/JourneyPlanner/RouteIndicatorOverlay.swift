import SwiftUI

// swiftlint:disable identifier_name
enum RouteAnchorID: Hashable {
    case from, to
}
// swiftlint:enable identifier_name

struct RouteAnchorKey: PreferenceKey {
    static var defaultValue: [RouteAnchorID: Anchor<CGRect>] = [:]
    static func reduce(
        value: inout [RouteAnchorID: Anchor<CGRect>],
        nextValue: () -> [RouteAnchorID: Anchor<CGRect>]
    ) {
        value.merge(nextValue(), uniquingKeysWith: { $1 })
    }
}

struct RouteIndicatorOverlay: View {
    let dotSize: CGFloat
    let leadingOffset: CGFloat
    let fromAnchor: Anchor<CGRect>
    let toAnchor: Anchor<CGRect>
    let midContent: AnyView?

    private var dotRadius: CGFloat { dotSize / 2.0 }

    var body: some View {
        GeometryReader { proxy in
            let fromY = proxy[fromAnchor].midY
            let toY = proxy[toAnchor].midY
            let positionX = leadingOffset

            ZStack {
                Path { path in
                    path.move(to: CGPoint(x: positionX, y: fromY + dotRadius))
                    path.addLine(to: CGPoint(x: positionX, y: toY - dotRadius))
                }
                .stroke(.quaternary, lineWidth: 2)

                Circle()
                    .strokeBorder(lineWidth: 2)
                    .frame(width: dotSize, height: dotSize)
                    .foregroundStyle(.secondary)
                    .position(x: positionX, y: fromY)

                Circle()
                    .frame(width: dotSize, height: dotSize)
                    .foregroundStyle(.secondary)
                    .position(x: positionX, y: toY)
            }
            .transaction { $0.animation = nil }
            .overlay {
                if let midContent {
                    midContent
                        .position(x: positionX, y: (fromY + toY) / 2)
                }
            }
        }
    }
}

extension View {
    func routeAnchor(_ id: RouteAnchorID) -> some View {
        transformAnchorPreference(key: RouteAnchorKey.self, value: .bounds) {
            $0[id] = $1
        }

    }

    func routeIndicatorOverlay(
        dotSize: CGFloat = 10,
        leadingOffset: CGFloat = 16,
        leadingPadding: CGFloat = 32,
        @ViewBuilder midContent: @escaping () -> some View = { EmptyView?.none }
    ) -> some View {
        self
            .padding(.leading, leadingPadding)
            .overlayPreferenceValue(RouteAnchorKey.self) { anchors in
                if let fromAnchor = anchors[.from], let toAnchor = anchors[.to] {
                    RouteIndicatorOverlay(
                        dotSize: dotSize,
                        leadingOffset: leadingOffset,
                        fromAnchor: fromAnchor,
                        toAnchor: toAnchor,
                        midContent: AnyView(midContent())
                    )
                }
            }
    }
}

// MARK: - Previews

#Preview {
    VStack(spacing: 16) {
        Text("Angel")
            .routeAnchor(.from)
        Text("King's Cross")
            .routeAnchor(.to)
    }
    .routeIndicatorOverlay()
}
