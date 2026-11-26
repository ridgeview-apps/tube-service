import SwiftUI

/// A route number tinted bus red.
struct BusRouteTag: View {
    let route: String
    var isOnAccent = false

    private var tint: Color { isOnAccent ? .white : .bus }

    var body: some View {
        Text(verbatim: route)
            .font(.footnote.weight(.semibold))
            .monospacedDigit()
            .foregroundStyle(tint)
            .padding(.horizontal, 5)
            .padding(.vertical, 1)
            .background(tint.opacity(isOnAccent ? 0.22 : 0.14), in: .rect(cornerRadius: 4, style: .continuous))
    }
}

/// A stop's routes as wrapping tags, ending in "+N" past `limit`.
struct BusRouteTags: View {
    let routes: [String]
    var limit = 6

    private var visibleRoutes: ArraySlice<String> { routes.prefix(routes.count > limit ? limit - 1 : limit) }
    private var hiddenRouteCount: Int { routes.count - visibleRoutes.count }

    var body: some View {
        WrappingHStack(spacing: 4) {
            ForEach(visibleRoutes, id: \.self) { route in
                BusRouteTag(route: route)
            }
            if hiddenRouteCount > 0 {
                Text(.busStopRoutesMore(hiddenRouteCount))
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

/// Lays its views out in rows, starting a new row when the next view doesn't fit.
struct WrappingHStack: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let rows = rows(for: subviews, maxWidth: proposal.width ?? .infinity)
        let width = rows.map(\.width).max() ?? 0
        let height = rows.map(\.height).reduce(0, +) + spacing * CGFloat(max(rows.count - 1, 0))
        return CGSize(width: width, height: height)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var y = bounds.minY
        for row in rows(for: subviews, maxWidth: bounds.width) {
            var x = bounds.minX
            for index in row.indices {
                let size = subviews[index].sizeThatFits(.unspecified)
                subviews[index].place(at: CGPoint(x: x, y: y + (row.height - size.height) / 2), proposal: .unspecified)
                x += size.width + spacing
            }
            y += row.height + spacing
        }
    }

    private struct Row {
        var indices: [Int] = []
        var width: CGFloat = 0
        var height: CGFloat = 0
    }

    private func rows(for subviews: Subviews, maxWidth: CGFloat) -> [Row] {
        var rows = [Row()]
        for index in subviews.indices {
            let size = subviews[index].sizeThatFits(.unspecified)
            let widthWithView = rows[rows.count - 1].width + (rows[rows.count - 1].indices.isEmpty ? 0 : spacing) + size.width
            if widthWithView > maxWidth && !rows[rows.count - 1].indices.isEmpty {
                rows.append(Row())
            }
            var row = rows[rows.count - 1]
            row.width += (row.indices.isEmpty ? 0 : spacing) + size.width
            row.height = max(row.height, size.height)
            row.indices.append(index)
            rows[rows.count - 1] = row
        }
        return rows
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    VStack(alignment: .leading, spacing: 12) {
        BusRouteTags(routes: ["251", "628", "688"])
        BusRouteTags(routes: ["30", "73", "91", "205", "390", "N73", "N91", "N205"])
    }
    .frame(width: 220, alignment: .leading)
    .padding()
}
