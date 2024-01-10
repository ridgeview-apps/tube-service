import Models
import SwiftUI

extension View {
    func lineGroupListRowStyle() -> some View {
        self
            .listRowSeparator(.visible, edges: .bottom)
            .listRowInsets(.init(top: 8, leading: 16, bottom: 8, trailing: 16))
            .listRowBackground(Color.defaultCellBackground)
    }
}


struct LineGroupSectionHeader: View {
    let title: LocalizedStringKey
    var imageName: String?
    
    var body: some View {
        HStack(spacing: 4) {
            if let imageName {
                Image(systemName: imageName)
                    .imageScale(.small)
            }
            Text(title, bundle: .module)
        }
    }
}

struct LineGroupCell: View {
    
    @Environment(\.locale) var locale
    
    enum Style {
        case plain
        case distance(metres: Double)
    }
    
    let style: Style
    let lineIDs: [LineID]
    let title: String

    var body: some View {
        HStack(spacing: 8) {
            LineColourKeyView(lineIDs: lineIDs)
                .frame(width: 40, height: 40)
                .roundedBorder(.white)
            Text(title)
            Spacer()
            if case .distance(let metres) = style {
                formattedDistanceText(for: metres)
            }
        }
        .contentShape(Rectangle())
        .foregroundColor(Color.primary)
    }
    
    private func formattedDistanceText(for metres: Double) -> some View {
        Text(
            Measurement(value: metres, unit: UnitLength.meters)
                .formatted(
                    .measurement(width: .abbreviated, usage: .road).locale(locale)
                )
        )
        .font(.subheadline)
        .foregroundStyle(Color.adaptiveMidGrey2)
    }
}

// MARK: - Previews

#Preview {
    NavigationStack {
        List {
            Section {
                LineGroupCell(style: .plain,
                              lineIDs: ModelStubs.eastFinchleyStation.sortedLineIDs,
                              title: ModelStubs.eastFinchleyStation.name)
                LineGroupCell(style: .plain,
                              lineIDs: ModelStubs.kingsCrossStation.sortedLineIDs,
                              title: ModelStubs.kingsCrossStation.name)
                LineGroupCell(style: .plain,
                              lineIDs: [.circle, .hammersmithAndCity, .district],
                              title: "Mixed line group")
            } header: {
                LineGroupSectionHeader(title: "Plain cells")
            }
            Section {
                LineGroupCell(style: .distance(metres: 600), 
                              lineIDs: ModelStubs.eastFinchleyStation.sortedLineIDs,
                              title: ModelStubs.eastFinchleyStation.name)
                LineGroupCell(style: .distance(metres: 7000),
                              lineIDs: ModelStubs.kingsCrossStation.sortedLineIDs,
                              title: ModelStubs.kingsCrossStation.name)
            } header: {
                LineGroupSectionHeader(title: "Distance cells", imageName: "location.fill")
            }
        }
    }
    .environment(\.locale, .init(languageRegion: .unitedStates))
//    .environment(\.locale, .init(languageRegion: .unitedKingdom))
//    .environment(\.locale, .init(languageRegion: .france))
}
