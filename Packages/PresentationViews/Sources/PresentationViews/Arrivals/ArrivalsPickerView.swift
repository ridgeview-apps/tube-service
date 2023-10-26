import Shared
import SwiftUI
import Models

public struct ArrivalsPickerView: View {
    
    public enum Style {
        case normal(favouriteLineGroupIDs: Set<Station.LineGroup.ID>)
        case searchResults
    }
    
    public let style: Style
    public let allStations: [Station]

    @Binding public var selectedLineGroup: Station.LineGroup?
    
    private let favourites: [Station]
    
    @ScaledMetric private var dynamicTextScale: CGFloat = 1
    
    
    // MARK: - Init
    
    public init(allStations: [Station],
                style: Style,
                selectedLineGroup: Binding<Station.LineGroup?>) {
        self.allStations = allStations
        self.style = style
        self._selectedLineGroup = selectedLineGroup
        
        switch style {
        case let .normal(favouriteLineGroupIDs):
            self.favourites = allStations.favourites(matching: favouriteLineGroupIDs)
        case .searchResults:
            self.favourites = []
        }
    }
    
    // MARK: Layout
    
    public var body: some View {
        List(selection: $selectedLineGroup) {
            section(stations: favourites) {
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .imageScale(.small)
                    Text("arrivals.picker.favourites.section.title", bundle: .module)
                }
            }
            section(stations: allStations) {
                allStationsSectionTitle
            }
        }
        .listStyle(.plain)
        .defaultScrollContentBackgroundColor()
        .accessibilityIdentifier("acc.id.arrivals.picker.list")
        
    }
    
    @ViewBuilder private func section(stations: [Station], header: () -> some View) -> some View {
        if !stations.isEmpty {
            Section {
                ForEach(stations) { station in
                    cell(for: station)
                }
            } header: {
                header()
            }
            .listRowSeparator(.visible, edges: .bottom)
            .listRowInsets(.init(top: 8, leading: 16, bottom: 8, trailing: 16))
            .listRowBackground(Color.defaultBackground)
        }
    }
    
    @ViewBuilder private var allStationsSectionTitle: some View {
        switch style {
        case .normal:
            Text("arrivals.picker.all.stations.section.title", bundle: .module)
        case .searchResults:
            Text("arrivals.picker.search.results.count \(allStations.count)", bundle: .module)
        }
    }
    
    @ViewBuilder private func cell(for station: Station) -> some View {
        Group {
            if station.lineGroups.count == 1 {
                navigationLink(for: station.lineGroups[0], title: station.name)
            } else {
                DisclosureGroup {
                    ForEach(station.lineGroups.sortedByName()) { lineGroup in
                        navigationLink(for: lineGroup, title: lineGroup.name)
                    }
                } label: {
                    rowLabel(withLineIDs: station.sortedLineIDs, title: station.name)
                        .accessibilityIdentifier(station.id)
                }
                .tint(.clear)
            }
        }
        .frame(minHeight: 44 * dynamicTextScale)
    }
    
    private func navigationLink(for lineGroup: Station.LineGroup, title: String) -> some View {
        NavigationLink(value: lineGroup) {
            rowLabel(withLineIDs: lineGroup.lineIds.sortedByName(), title: title)
        }
        .accessibilityIdentifier("\(lineGroup.id)")
    }
    
    private func rowLabel(withLineIDs lineIDs: [LineID], title: String) -> some View {
        HStack(spacing: 8) {
            LineColourKeyView(lineIDs: lineIDs)
                .frame(width: 40, height: 40)
                .roundedBorder(.white)
            Text(title)
            Spacer()
        }
        .contentShape(Rectangle())
        .foregroundColor(Color.primary)
    }
}


// MARK: - Previews

#if DEBUG
private struct WrapperView: View  {
    var allStations: [Station] = ModelStubs.stations
    var style: ArrivalsPickerView.Style
    @State var selectedLineGroup: Station.LineGroup?
    
    var body: some View {
        NavigationSplitView {
            ArrivalsPickerView(allStations: allStations,
                               style: style,
                               selectedLineGroup: $selectedLineGroup)
            .navigationTitle("Picker preview")
        } detail: {
            if let selectedLineGroup {
                Text("\(selectedLineGroup.name) selected")
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
