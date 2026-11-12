import SwiftUI

/// The app's chip: an accent capsule when selected, an outlined one when not.
struct FilterChipButtonStyle: ButtonStyle {
    let isSelected: Bool

    @Environment(\.isEnabled) private var isEnabled

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .lineLimit(1)
            .font(.subheadline)
            .padding(.horizontal, 10)
            .padding(.vertical, 7)
            .foregroundStyle(isSelected ? Color.white : Color.secondary)
            .background(isSelected ? Color.accentColor : .clear, in: Capsule())
            .overlay(Capsule().strokeBorder(isSelected ? .clear : Color.secondary.opacity(0.4), lineWidth: 1))
            .contentShape(Capsule())
            .opacity(configuration.isPressed || !isEnabled ? 0.5 : 1)
    }
}

extension ButtonStyle where Self == FilterChipButtonStyle {
    static func filterChip(isSelected: Bool) -> FilterChipButtonStyle {
        FilterChipButtonStyle(isSelected: isSelected)
    }
}

/// A horizontally scrolling row of chips after a filter icon, fading out at the trailing edge.
struct FilterChipRow<ChipID: Hashable, Content: View>: View {
    /// A chip to scroll into view when the row first appears, e.g. a remembered selection that would be off screen.
    var initiallyVisibleID: ChipID?
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
                    HStack(spacing: 8) {
                        content
                    }
                    .padding(.leading, 10)
                    .padding(.trailing, 16)
                    .padding(.vertical, 8)
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
    }
}

extension FilterChipRow where ChipID == Never {
    init(@ViewBuilder content: () -> Content) {
        self.initiallyVisibleID = nil
        self.content = content()
    }
}
