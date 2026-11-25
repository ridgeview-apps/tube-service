import Models
import SwiftUI

extension View {
    func lineGroupListRowStyle(backgroundColor: Color = .defaultCellBackground) -> some View {
        self
            .listRowInsets(.init(top: 8, leading: 16, bottom: 8, trailing: 16))
            .listRowBackground(backgroundColor)
    }
}


struct LineGroupSectionHeader: View {
    let title: LocalizedStringResource
    var imageName: String?

    var body: some View {
        HStack(spacing: 4) {
            if let imageName {
                Image(systemName: imageName)
                    .imageScale(.small)
            }
            Text(title)
        }
    }
}

struct LineGroupCell: View {

    @Environment(\.locale) var locale
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    enum Style {
        case plain
        case distance(metres: Double)
    }

    let style: Style
    let lineIDs: [TrainLineID]
    let title: String

    var body: some View {
        HStack(spacing: 12) {
            LineColourTile(lineIDs: lineIDs, size: 30)
                .dynamicTypeSize(...DynamicTypeSize.accessibility1)
            if dynamicTypeSize.isAccessibilitySize {
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                    distanceText
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            } else {
                Text(title)
                Spacer()
                distanceText
            }
        }
        .contentShape(Rectangle())
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(accessibilityLabel)
    }

    @ViewBuilder private var distanceText: some View {
        if let formattedDistance {
            Text(formattedDistance)
                .font(.subheadline)
                .foregroundStyle(Color.secondary)
        }
    }

    private var formattedDistance: String? {
        guard case .distance(let metres) = style else { return nil }
        return Measurement(value: metres, unit: UnitLength.meters)
            .formatted(.measurement(width: .abbreviated, usage: .road).locale(locale))
    }

    private var accessibilityLabel: String {
        let lineNames = lineIDs.map(\.name)
        let parts = [title, lineNames.formatted(.list(type: .and).locale(locale)), formattedDistance]
        return parts.compactMap { $0 }.filter { !$0.isEmpty }.joined(separator: ", ")
    }
}

// MARK: - Previews

import ModelStubs

#Preview {
    NavigationStack {
        List {
            Section {
                LineGroupCell(
                    style: .plain,
                    lineIDs: [.circle, .hammersmithAndCity, .district],
                    title: "Mixed line group"
                )
            } header: {
                LineGroupSectionHeader(title: "Plain cells")
            }
            Section {
                LineGroupCell(
                    style: .distance(metres: 600),
                    lineIDs: ModelStubs.eastFinchleyStation.sortedLineIDs,
                    title: ModelStubs.eastFinchleyStation.name
                )
                LineGroupCell(
                    style: .distance(metres: 1200),
                    lineIDs: ModelStubs.stations.first { $0.name == "Bank" }?.sortedLineIDs ?? [],
                    title: "Bank"
                )
                LineGroupCell(
                    style: .distance(metres: 7000),
                    lineIDs: ModelStubs.kingsCrossStation.sortedLineIDs,
                    title: ModelStubs.kingsCrossStation.name
                )
            } header: {
                LineGroupSectionHeader(title: "Distance cells", imageName: "location.fill")
            }
        }
    }
    .environment(\.locale, .init(languageRegion: .unitedStates))
    //    .environment(\.locale, .init(languageRegion: .unitedKingdom))
    //    .environment(\.locale, .init(languageRegion: .france))
}
