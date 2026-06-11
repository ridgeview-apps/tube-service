import SwiftUI

struct EqualColumnsWithAccessoryLayout: Layout {
    let columnCount: Int

    init(columnCount: Int) {
        precondition(columnCount > 0)
        self.columnCount = columnCount
    }

    func sizeThatFits(
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) -> CGSize {
        guard subviews.count == columnCount + 1 else { return .zero }

        let accessorySize = subviews[columnCount].sizeThatFits(.unspecified)
        let proposedWidth = proposal.width ?? intrinsicWidth(
            for: subviews,
            accessoryWidth: accessorySize.width
        )
        let columnWidth = max(0, (proposedWidth - accessorySize.width) / CGFloat(columnCount))
        let columnProposal = ProposedViewSize(width: columnWidth, height: proposal.height)
        let columnHeight = subviews.dropLast().reduce(CGFloat.zero) { height, subview in
            max(height, subview.sizeThatFits(columnProposal).height)
        }

        return CGSize(
            width: proposedWidth,
            height: max(columnHeight, accessorySize.height)
        )
    }

    func placeSubviews(
        in bounds: CGRect,
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) {
        guard subviews.count == columnCount + 1 else { return }

        let accessoryWidth = subviews[columnCount].sizeThatFits(.unspecified).width
        let columnWidth = max(0, (bounds.width - accessoryWidth) / CGFloat(columnCount))
        let columnProposal = ProposedViewSize(width: columnWidth, height: bounds.height)

        for (index, subview) in subviews.dropLast().enumerated() {
            subview.place(
                at: CGPoint(
                    x: bounds.minX + CGFloat(index) * columnWidth,
                    y: bounds.minY
                ),
                anchor: .topLeading,
                proposal: columnProposal
            )
        }

        subviews[columnCount].place(
            at: CGPoint(x: bounds.maxX, y: bounds.midY),
            anchor: .trailing,
            proposal: .init(width: accessoryWidth, height: bounds.height)
        )
    }

    private func intrinsicWidth(
        for subviews: Subviews,
        accessoryWidth: CGFloat
    ) -> CGFloat {
        let widestColumn = subviews.dropLast().reduce(CGFloat.zero) { width, subview in
            max(width, subview.sizeThatFits(.unspecified).width)
        }
        return widestColumn * CGFloat(columnCount) + accessoryWidth
    }
}
