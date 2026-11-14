import Models
import SwiftUI

/// One small circle with each line's colour stacked top to bottom, so every line group gets a marker of the same
/// size.
struct LineColourDot: View {
    let lineIDs: [TrainLineID]
    /// A white outline keeps dark blue lines (e.g. Piccadilly) distinct from an accent-coloured background.
    var isOnAccent = false

    @ScaledMetric(relativeTo: .subheadline) private var size: CGFloat = 14

    var body: some View {
        VStack(spacing: 0) {
            ForEach(lineIDs, id: \.self) { lineID in
                Rectangle().fill(lineID.backgroundColor)
            }
        }
        .frame(width: size, height: size)
        .clipShape(.circle)
        .overlay(
            Circle().stroke(
                isOnAccent ? AnyShapeStyle(.white) : AnyShapeStyle(.primary.opacity(0.35)),
                lineWidth: 0.5
            )
        )
        .accessibilityHidden(true)
    }
}
