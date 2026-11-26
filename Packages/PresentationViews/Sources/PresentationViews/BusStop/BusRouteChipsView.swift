import SwiftUI

/// An "All" chip then one per route, at the top of the Stop screen at stops with more than one route.
struct BusRouteChipsView: View {

    private enum Chip: Hashable {
        case all
        case route(String)
    }

    let routes: [String]
    /// Nil for all routes.
    let selectedRoute: String?
    let onSelect: (String?) -> Void

    private var chips: [Chip] { [.all] + routes.map(Chip.route) }
    private var selectedChip: Chip { selectedRoute.map(Chip.route) ?? .all }

    var body: some View {
        FilterChipRow(selectedID: selectedChip, backing: .none) {
            ForEach(chips, id: \.self) { chip in
                Button {
                    onSelect(route(for: chip))
                } label: {
                    label(for: chip)
                }
                .buttonStyle(.filterChip(isSelected: chip == selectedChip))
                .accessibilityAddTraits(chip == selectedChip ? .isSelected : [])
            }
        }
        .dynamicTypeSize(...DynamicTypeSize.accessibility2)
    }

    private func route(for chip: Chip) -> String? {
        guard case .route(let route) = chip else { return nil }
        return route
    }

    @ViewBuilder
    private func label(for chip: Chip) -> some View {
        switch chip {
        case .all: Text(.busStopRoutesAll)
        case .route(let route): BusRouteTag(route: route, isOnAccent: chip == selectedChip)
        }
    }
}
