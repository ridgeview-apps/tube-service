import Shared
import SwiftUI
import Models

// MARK: - Data types

public enum ArrivalsPickerMode: Equatable {
    case favouritesVisible(favourites: Set<Station.LineGroup.ID>)
    case searchResults
}


// MARK: - ArrivalsPickerView

public struct ArrivalsPickerView: View {
    
    public let mode: ArrivalsPickerMode
    public let allStations: [Station]

    @Binding public var selection: Station.LineGroup?
    
    private let favourites: [Station]
    
    // MARK: - Init
    
    public init(allStations: [Station],
                mode: ArrivalsPickerMode,
                selection: Binding<Station.LineGroup?>) {
        self.allStations = allStations
        self.mode = mode
        self._selection = selection
        
        switch mode {
        case let .favouritesVisible(favourites):
            self.favourites = allStations.favourites(matching: favourites)
        case .searchResults:
            self.favourites = []
        }
    }
    
    // MARK: Layout
    
    public var body: some View {
        List(selection: $selection) {
            Group {
                if case .favouritesVisible = mode {
                    favouritesSection
                }
                allStationsSection
            }
        }
        .listStyle(.plain)
        .defaultMaxWidthWithFullBackground()
        .withHardScrollEdgeEffectStyle()
        .accessibilityIdentifier("acc.id.arrivals.picker.list")
    }
    
    @ViewBuilder private var favouritesSection: some View {
        if !favourites.isEmpty {
            stationsSection(with: favourites,
                            header: .init(title: .arrivalsPickerFavouritesSectionTitle,
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
                .secondarySectionHeaderStyle()
        }
        .lineGroupListRowStyle()
    }
        
    private var allStationsSectionHeaderTitle: LocalizedStringResource {
        switch mode {
        case .favouritesVisible:
            .arrivalsPickerAllStationsSectionTitle
        case .searchResults:
            .stationsSearchResultsCount(allStations.count)
        }
    }
}


private struct ArrivalsPickerExpandableCell: View {
    
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
        .frame(minHeight: 52)
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
    
    private func lineGroupCell(withLineIDs lineIDs: [TrainLineID],
                               title: String,
                               showsDistance: Bool) -> some View {
        LineGroupCell(style: style,
                      lineIDs: lineIDs,
                      title: title)
    }
}


// MARK: - Previews

import ModelStubs

private struct WrapperView: View {
    var allStations: [Station] = ModelStubs.stations
    var mode: ArrivalsPickerMode
    @State var selection: Station.LineGroup?
    
    var body: some View {
        NavigationStack {
            ArrivalsPickerView(allStations: allStations,
                               mode: mode,
                               selection: $selection)
            .navigationTitle("Picker preview")
            .navigationDestination(item: $selection) { selection in
                Text("\(String(describing: selection)) selected")
            }
        }
    }
}


#Preview("Normal mode (favourites)") {
    WrapperView(
        mode: .favouritesVisible(favourites: [
            "940GZZLUKSX-circle,hammersmith-city,metropolitan", // Kings X - Circle, H&C, Met lines
            "940GZZLUKSX-northern",   // Kings X - Northern line
            "940GZZLUKSX-piccadilly", // Kingx X - Piccadilly line
            "940GZZLUPAC-bakerloo",
            "940GZZLUHBT-northern"
        ])
    )
}

#Preview("Normal mode (no favourites)") {
    WrapperView(mode: .favouritesVisible(favourites: []))
}

#Preview("Search results mode") {
    WrapperView(
        allStations: Array(ModelStubs.stations.prefix(4)),
        mode: .searchResults
    )
    .searchable(text: .constant(""), placement: .navigationBarDrawer(displayMode: .always))
}
