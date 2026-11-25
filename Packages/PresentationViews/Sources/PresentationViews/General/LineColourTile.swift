import Models
import SwiftUI

/// One small rounded square with each line's colour stacked top to bottom, so every line group gets a marker of the
/// same size. Square rather than round, so it doesn't look like the status icons and disruption badges beside it.
struct LineColourTile: View {
    let lineIDs: [TrainLineID]
    /// A white outline keeps dark blue lines (e.g. Piccadilly) distinct from an accent-coloured background.
    var isOnAccent = false

    @ScaledMetric private var size: CGFloat

    init(lineIDs: [TrainLineID], isOnAccent: Bool = false, size: CGFloat = 14) {
        self.lineIDs = lineIDs
        self.isOnAccent = isOnAccent
        self._size = ScaledMetric(wrappedValue: size, relativeTo: .subheadline)
    }

    var body: some View {
        VStack(spacing: 0) {
            ForEach(lineIDs, id: \.self) { lineID in
                Rectangle().fill(lineID.backgroundColor)
            }
        }
        .frame(width: size, height: size)
        .clipShape(tileShape)
        .overlay(
            tileShape.stroke(
                isOnAccent ? AnyShapeStyle(.white) : AnyShapeStyle(.primary.opacity(0.35)),
                lineWidth: 0.5
            )
        )
        .accessibilityHidden(true)
    }

    private var tileShape: RoundedRectangle {
        RoundedRectangle(cornerRadius: size * 0.25, style: .continuous)
    }
}
