import SwiftUI
import UIKit

/// A small capsule shown after a feature's title while it's new.
struct NewBadge: View {

    var body: some View {
        Text(.globalNew)
            .font(.caption2.weight(.bold))
            .textCase(.uppercase)
            .foregroundStyle(.white)
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(Color.accentColor, in: Capsule())
    }
}

private struct NewBadgeModifier: ViewModifier {

    let isShown: Bool
    let titleTextStyle: UIFont.TextStyle

    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    /// The height of the title's capital letters at the current text size.
    private var titleCapHeight: CGFloat {
        let traits = UITraitCollection(preferredContentSizeCategory: UIContentSizeCategory(dynamicTypeSize))
        return UIFont.preferredFont(forTextStyle: titleTextStyle, compatibleWith: traits).capHeight
    }

    func body(content: Content) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: 6) {
            content
            if isShown {
                // Centres the capsule on the title's capital letters rather than sharing its baseline,
                // which would leave the capsule sitting low. Holds on the first line when the title wraps.
                NewBadge()
                    .alignmentGuide(.firstTextBaseline) { dimensions in
                        dimensions[VerticalAlignment.center] + titleCapHeight / 2
                    }
            }
        }
    }
}

extension View {

    /// Places a `NewBadge` after the view, centred on its first line of text.
    /// - Parameter titleTextStyle: The text style of the view's text, used to centre the badge on it.
    func newBadge(_ isShown: Bool, titleTextStyle: UIFont.TextStyle = .headline) -> some View {
        modifier(NewBadgeModifier(isShown: isShown, titleTextStyle: titleTextStyle))
    }
}


// MARK: - Previews

#Preview {
    VStack(alignment: .leading, spacing: 20) {
        Text(verbatim: "Status History")
            .font(.headline)
            .newBadge(true)

        Text(verbatim: "A much longer feature title that wraps onto a second line")
            .font(.headline)
            .newBadge(true)
            .frame(width: 240, alignment: .leading)
    }
    .padding()
}
