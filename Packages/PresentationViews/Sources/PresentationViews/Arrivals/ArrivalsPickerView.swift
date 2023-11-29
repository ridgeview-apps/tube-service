import Shared
import SwiftUI
import Models

// MARK: - Data types

public enum ArrivalsPickerStyle: Equatable {
    case normal(favouriteLineGroupIDs: Set<Station.LineGroup.ID>)
    case searchResults
}


// MARK: - ArrivalsPickerView

public struct ArrivalsPickerView: View {
    
    public let style: ArrivalsPickerStyle
    public let allStations: [Station]

    @Binding public var selection: Station.LineGroup?
    
    private let favourites: [Station]
    
    // MARK: - Init
    
    public init(allStations: [Station],
                style: ArrivalsPickerStyle,
                selection: Binding<Station.LineGroup?>) {
        self.allStations = allStations
        self.style = style
        self._selection = selection
        
        switch style {
        case let .normal(favouriteLineGroupIDs):
            self.favourites = allStations.favourites(matching: favouriteLineGroupIDs)
        case .searchResults:
            self.favourites = []
        }
    }
    
    // MARK: Layout
    
    public var body: some View {
        List(selection: $selection) {
            if case .normal = style {
                favouritesSection
            }
            allStationsSection
        }
        .listStyle(.plain)
        .defaultScrollContentBackgroundColor()
        .accessibilityIdentifier("acc.id.arrivals.picker.list")
    }
    
    @ViewBuilder private var favouritesSection: some View {
        if !favourites.isEmpty {
            stationsSection(with: favourites,
                            header: .init(title: "arrivals.picker.favourites.section.title",
                                          imageName: "star.fill"))
        }
    }
    
    private var allStationsSection: some View {
        stationsSection(with: allStations,
                        header: .init(title: allStationsSectionHeaderTitle))
    }
    
    private func stationsSection(with stations: [Station],
                                 header: LineGroupSectionHeader) -> some View {
        Section {
            ForEach(stations) { station in
                ArrivalsPickerExpandableCell(style: .plain, station: station)
            }
        } header: {
            header
        }
        .lineGroupListRowStyle()
    }
    
    private var allStationsSectionHeaderTitle: LocalizedStringKey {
        switch style {
        case .normal:
            LocalizedStringKey("arrivals.picker.all.stations.section.title")
        case .searchResults:
            LocalizedStringKey("stations.search.results.count \(allStations.count)")
        }
    }
}


private struct ArrivalsPickerExpandableCell: View {
    
    @ScaledMetric private var dynamicTextScale: CGFloat = 1
    
    let style: LineGroupCell.Style
    let station: Station
    
    var body: some View {
        Group {
            if station.lineGroups.count == 1 {
                lineGroupCellLink(for: station.lineGroups[0],
                                  title: station.name,
                                  showsDistance: true)
            } else {
                DisclosureGroup {
                    ForEach(station.lineGroups.sortedByName()) { lineGroup in
                        lineGroupCellLink(for: lineGroup,
                                          title: lineGroup.name,
                                          showsDistance: false)
                    }
                } label: {
                    lineGroupCell(withLineIDs: station.sortedLineIDs,
                                  title: station.name,
                                  showsDistance: true)
                        .accessibilityIdentifier(station.id)
                }
                .tint(.clear)
            }
        }
        .frame(minHeight: 44 * dynamicTextScale)
    }
    
    
    private func lineGroupCellLink(for lineGroup: Station.LineGroup,
                                   title: String,
                                   showsDistance: Bool) -> some View {
        NavigationLink(value: lineGroup) {
            lineGroupCell(withLineIDs: lineGroup.lineIds.sortedByName(),
                          title: title,
                          showsDistance: showsDistance)
        }
        .accessibilityIdentifier("\(lineGroup.id)")
    }
    
    private func lineGroupCell(withLineIDs lineIDs: [LineID],
                               title: String,
                               showsDistance: Bool) -> some View {
        LineGroupCell(style: style,
                      lineIDs: lineIDs,
                      title: title)
    }
}



// MARK: - Previews

#if DEBUG
private struct WrapperView: View  {
    var allStations: [Station] = ModelStubs.stations
    var style: ArrivalsPickerStyle
    @State var selection: Station.LineGroup?
    
    var body: some View {
        NavigationSplitView {
            ArrivalsPickerView(allStations: allStations,
                               style: style,
                               selection: $selection)
            .navigationTitle("Picker preview")
        } detail: {
            if let selection {
                Text("\(String(describing: selection)) selected")
            } else {
                Text("No value selected")
            }
        }
    }
}


#Preview("Normal mode (favourites)") {
    WrapperView(
        style: .normal(favouriteLineGroupIDs: [
            "940GZZLUKSX-circle,hammersmith-city,metropolitan", // Kings X - Circle, H&C, Met lines
            "940GZZLUKSX-northern",   // Kings X - Northern line
            "940GZZLUKSX-piccadilly", // Kingx X - Piccadilly line
            "940GZZLUPAC-bakerloo",
            "940GZZLUHBT-northern"
        ])
    )
}

#Preview("Normal mode (no favourites)") {
    WrapperView(style: .normal(favouriteLineGroupIDs: []))
}

#Preview("Search results mode") {
    WrapperView(
        allStations: Array(ModelStubs.stations.prefix(4)),
        style: .searchResults
    )
    .searchable(text: .constant(""), placement: .navigationBarDrawer(displayMode: .always))
    .previewDisplayName("With search bar")
}
#endif
