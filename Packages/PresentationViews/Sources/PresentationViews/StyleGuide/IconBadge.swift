import SwiftUI

/// An SF Symbol on a filled circle, shown at the leading edge of a card row such as the status history
/// and notifications buttons. Shared so those rows' icons stay the same size.
struct IconBadge: View {

    let systemName: String
    let foregroundColor: Color
    let backgroundColor: Color

    /// Sized to leave room around wide symbols like `bell.and.waves.left.and.right.fill`,
    /// and scaled with the symbol's text style so larger text sizes don't push the symbol past the circle.
    @ScaledMetric(relativeTo: .body) private var diameter: CGFloat = 40

    var body: some View {
        Image(systemName: systemName)
            .font(.body.weight(.semibold))
            .foregroundStyle(foregroundColor)
            .frame(width: diameter, height: diameter)
            .background(backgroundColor, in: Circle())
    }
}


// MARK: - Previews

#Preview {
    VStack(spacing: 20) {
        HStack(spacing: 20) {
            IconBadge(
                systemName: "clock.arrow.trianglehead.counterclockwise.rotate.90",
                foregroundColor: .white,
                backgroundColor: .orange
            )
            IconBadge(
                systemName: "bell.and.waves.left.and.right.fill",
                foregroundColor: .white,
                backgroundColor: .accentColor
            )
            IconBadge(systemName: "bell.slash", foregroundColor: .secondary, backgroundColor: Color(.tertiarySystemFill))
        }
        HStack(spacing: 20) {
            IconBadge(
                systemName: "clock.arrow.trianglehead.counterclockwise.rotate.90",
                foregroundColor: .white,
                backgroundColor: .orange
            )
            IconBadge(
                systemName: "bell.and.waves.left.and.right.fill",
                foregroundColor: .white,
                backgroundColor: .accentColor
            )
        }
        .dynamicTypeSize(.accessibility3)
    }
    .padding()
}
