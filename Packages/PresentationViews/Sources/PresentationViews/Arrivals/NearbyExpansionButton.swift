import SwiftUI

/// Shows all or fewer nearby stops, as a section of its own under the Nearby card.
struct NearbyExpansionButton: View {

    @Binding var isExpanded: Bool

    var body: some View {
        Section {
            HStack {
                Spacer()
                ExpansionInfoButton(
                    titleState: .init(collapsed: .nearbyShowAllButtonTitle, expanded: .nearbyShowLessButtonTitle),
                    isExpanded: $isExpanded
                )
                .buttonStyle(.borderless)
                .font(.subheadline)
                Spacer()
            }
        }
        // Keeps the button against the Nearby card it expands, rather than a section's distance away
        .listSectionSpacing(0)
        .listRowBackground(Color.clear)
        .listRowSeparator(.hidden)
        .listRowInsets(.init(top: 12, leading: 0, bottom: 12, trailing: 0))
    }
}
