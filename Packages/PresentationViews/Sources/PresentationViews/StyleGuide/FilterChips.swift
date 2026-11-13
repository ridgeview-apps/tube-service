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

/// A horizontally scrolling row of chips, fading out at the trailing edge.
///
/// Content scrolls under the glass, fading out as it nears the chips.
struct FilterChipRow<ChipID: Hashable, Content: View>: View {
    enum Backing {
        /// Fades out content that scrolls under the chips, for content on the screen's background, e.g. white cards.
        case scrollEdgeFade
        /// For a row that scrolls with the page, so nothing passes behind it.
        case none
    }

    /// A chip to scroll into view when the row first appears, e.g. a remembered selection that would be off screen.
    var initiallyVisibleID: ChipID?
    var backing: Backing = .scrollEdgeFade
    @ViewBuilder let content: Content

    // A pinned header can be rebuilt while the page scrolls, so this stops it snapping back after a manual scroll
    @State private var hasScrolledToInitialID = false
    @State private var fadedEdges: HorizontalEdge.Set = []

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal) {
                // No `GlassEffectContainer`: the chips never morph together, and it clips overlays that sit
                // outside the glass, such as the Station chips' disruption badge
                HStack(spacing: 8) {
                    content
                }
                .padding(.horizontal, 16)
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
            // Each edge fades only while there are chips beyond it, so a row that fits shows no fade at all
            .onScrollGeometryChange(for: HorizontalEdge.Set.self) { geometry in
                var edges: HorizontalEdge.Set = []
                // A point of slack, so rounding at either end doesn't leave a fade showing
                if geometry.contentOffset.x > 1 {
                    edges.insert(.leading)
                }
                if geometry.contentOffset.x + geometry.containerSize.width < geometry.contentSize.width - 1 {
                    edges.insert(.trailing)
                }
                return edges
            } action: { _, edges in
                withAnimation(.easeOut(duration: 0.2)) { fadedEdges = edges }
            }
        }
        .mask {
            HStack(spacing: 0) {
                EdgeFade(edge: .leading, isVisible: fadedEdges.contains(.leading))
                Rectangle()
                EdgeFade(edge: .trailing, isVisible: fadedEdges.contains(.trailing))
            }
        }
        .background {
            switch backing {
            case .scrollEdgeFade: scrollEdgeFade
            case .none: EmptyView()
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

/// A mask strip that fades the chips out towards one edge of the row.
private struct EdgeFade: View {
    let edge: HorizontalEdge
    let isVisible: Bool

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [.clear, .black],
                startPoint: edge == .leading ? .leading : .trailing,
                endPoint: edge == .leading ? .trailing : .leading
            )
            // Covering the gradient, rather than swapping its colours, so the fade animates in and out
            Rectangle()
                .opacity(isVisible ? 0 : 1)
        }
        .frame(width: 20)
    }
}
