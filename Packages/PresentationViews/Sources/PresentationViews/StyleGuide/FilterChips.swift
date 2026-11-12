import SwiftUI

/// The app's chip: a Liquid Glass capsule, tinted with the accent colour when selected.
struct FilterChipButtonStyle: ButtonStyle {
    let isSelected: Bool

    @Environment(\.isEnabled) private var isEnabled

    // Swapping between `.glass` and `.glassProminent` would change the button's type on selection, losing its
    // identity and animation, so both states share one `glassEffect` and differ only in tint
    private var glass: Glass {
        .regular.tint(isSelected ? .accentColor : nil).interactive()
    }

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .lineLimit(1)
            .font(.subheadline)
            .padding(.horizontal, 10)
            .padding(.vertical, 7)
            .foregroundStyle(isSelected ? Color.white : Color.primary)
            .glassEffect(glass, in: .capsule)
            .contentShape(Capsule())
            .opacity(isEnabled ? 1 : 0.5)
    }
}

extension ButtonStyle where Self == FilterChipButtonStyle {
    static func filterChip(isSelected: Bool) -> FilterChipButtonStyle {
        FilterChipButtonStyle(isSelected: isSelected)
    }
}

/// A horizontally scrolling row of chips after a filter icon, fading out at the trailing edge.
///
/// Content scrolls under the glass, fading out as it nears the chips.
struct FilterChipRow<ChipID: Hashable, Content: View>: View {
    enum Backing {
        /// Fades out content that scrolls under the chips, for content on the screen's background, e.g. white cards.
        case scrollEdgeFade
        /// Hides content behind a solid strip, for dark content that a light fade would only wash out to grey,
        /// e.g. the Station screen's boards.
        case solid
    }

    /// A chip to scroll into view when the row first appears, e.g. a remembered selection that would be off screen.
    var initiallyVisibleID: ChipID?
    var backing: Backing = .scrollEdgeFade
    @ViewBuilder let content: Content

    // A pinned header can be rebuilt while the page scrolls, so this stops it snapping back after a manual scroll
    @State private var hasScrolledToInitialID = false

    var body: some View {
        HStack(spacing: 0) {
            Image(systemName: "line.3.horizontal.decrease")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .padding(.leading, 16)
                .accessibilityHidden(true)
            ScrollViewReader { proxy in
                ScrollView(.horizontal) {
                    // No `GlassEffectContainer`: the chips never morph together, and it clips overlays that sit
                    // outside the glass, such as the Station chips' disruption badge
                    HStack(spacing: 8) {
                        content
                    }
                    .padding(.leading, 10)
                    .padding(.trailing, 16)
                    // Room for the glass's edge highlight and shadow, which the scroll view would otherwise clip
                    .padding(.vertical, 10)
                }
                .scrollIndicators(.hidden)
                // Not `ScrollPosition`: its initial position isn't applied to this row, so it starts at the first chip
                .onAppear {
                    guard !hasScrolledToInitialID, let initiallyVisibleID else { return }
                    hasScrolledToInitialID = true
                    proxy.scrollTo(initiallyVisibleID, anchor: .center)
                }
            }
            .mask(
                HStack(spacing: 0) {
                    Rectangle()
                    LinearGradient(colors: [.black, .clear], startPoint: .leading, endPoint: .trailing)
                        .frame(width: 20)
                }
            )
        }
        .background {
            switch backing {
            case .scrollEdgeFade: scrollEdgeFade
            case .solid: Color.defaultBackground
            }
        }
    }

    // Our own version of the system's scroll edge effect, which only comes with `safeAreaBar`: a bar there broke the
    // chips' horizontal scroll view after navigating back. Without it, content stays sharp behind the chips and
    // reads as part of the row
    private var scrollEdgeFade: some View {
        LinearGradient(
            stops: [
                .init(color: .defaultBackground, location: 0),
                .init(color: .defaultBackground, location: 0.5),
                .init(color: .defaultBackground.opacity(0), location: 1)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
        // Finishes the fade below the chips rather than at their bottom edge
        .padding(.bottom, -16)
        .allowsHitTesting(false)
    }
}

extension FilterChipRow where ChipID == Never {
    init(@ViewBuilder content: () -> Content) {
        self.initiallyVisibleID = nil
        self.content = content()
    }
}
