import SwiftUI

/// A titled block on the Station screen, shared by its header, arrivals and info parts.
struct StationSection<Content: View, Header: View>: View {
    var cardBackground = true
    @ViewBuilder let content: () -> Content
    @ViewBuilder let header: () -> Header

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            header()
                .secondarySectionHeaderStyle()
                .padding(.horizontal, 32)
            Group {
                if cardBackground {
                    content()
                        .cardStyle()
                } else {
                    content()
                }
            }
            .padding(.horizontal, 16)
        }
    }
}

extension StationSection where Header == EmptyView {
    init(cardBackground: Bool = true, @ViewBuilder content: @escaping () -> Content) {
        self.init(cardBackground: cardBackground, content: content, header: { EmptyView() })
    }
}
