import Shared
import SwiftUI
import Models

// MARK: - Data types

public enum ArrivalsPickerMode: Equatable {
    case favouritesVisible(favourites: Set<Station.LineGroup.ID>, order: [Station.ID])
    case searchResults
}


// MARK: - ArrivalsPickerView

public struct ArrivalsPickerView: View {

    public enum Action {
        case reorderFavourites([Station.ID])
        case removeFavourites([Station.LineGroup.ID])
    }

    public let mode: ArrivalsPickerMode
    public let allStations: [Station]

    @Binding public var selection: Station.LineGroup?
    public let onAction: (Action) -> Void

    private let favourites: [Station]

    @State private var editMode: EditMode = .inactive

    private var canReorderFavourites: Bool { favourites.count > 1 }

    // MARK: - Init

    public init(
        allStations: [Station],
        mode: ArrivalsPickerMode,
        selection: Binding<Station.LineGroup?>,
        onAction: @escaping (Action) -> Void
    ) {
        self.allStations = allStations
        self.mode = mode
        self._selection = selection
        self.onAction = onAction

        switch mode {
        case let .favouritesVisible(favourites, order):
            self.favourites = allStations.favourites(matching: favourites, order: order)
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
        .defaultMaxWidthWithFullBackground()
        .environment(\.editMode, $editMode)
        .onChange(of: favourites.isEmpty) {
            if favourites.isEmpty { editMode = .inactive }
        }
        .accessibilityIdentifier("acc.id.arrivals.picker.list")
    }

    @ViewBuilder private var favouritesSection: some View {
        if !favourites.isEmpty {
            Section {
                ForEach(favourites) { station in
                    ArrivalsPickerExpandableCell(style: .plain, station: station, isEditable: true)
                }
                .onMove(perform: moveFavourites)
                .onDelete(perform: removeFavourites)
                .moveDisabled(!canReorderFavourites)
                // Empty swipe actions replace onDelete's swipe-to-delete, so stations are only removable from
                // edit mode. Toggling deleteDisabled with edit mode instead stops the delete controls animating in.
                .swipeActions {}
            } header: {
                HStack {
                    LineGroupSectionHeader(
                        title: .arrivalsPickerFavouritesSectionTitle,
                        imageName: "star.fill"
                    )
                    Spacer()
                    EditModeButton(editMode: $editMode)
                }
                .secondarySectionHeaderStyle()
            }
            .lineGroupListRowStyle()
        }
    }

    private func moveFavourites(fromOffsets source: IndexSet, toOffset destination: Int) {
        var reorderedStationIDs = favourites.map(\.id)
        reorderedStationIDs.move(fromOffsets: source, toOffset: destination)
        onAction(.reorderFavourites(reorderedStationIDs))
    }

    // Favourite stations only hold their favourited line groups, so this removes the whole station
    private func removeFavourites(atOffsets offsets: IndexSet) {
        let removedLineGroupIDs = offsets.flatMap { favourites[$0].lineGroups.map(\.id) }
        withAnimation { onAction(.removeFavourites(removedLineGroupIDs)) }
    }

    private var allStationsSection: some View {
        stationsSection(
            with: allStations,
            header: .init(title: allStationsSectionHeaderTitle)
        )
    }

    private func stationsSection(
        with stations: [Station],
        header: LineGroupSectionHeader
    ) -> some View {
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
    var isEditable = false

    @Environment(\.editMode) private var editMode
    @State private var isExpanded = false

    private var isBeingEdited: Bool { isEditable && editMode?.wrappedValue.isEditing == true }

    var body: some View {
        Group {
            if isBeingEdited {
                // A plain row while editing: it's dragged as a whole station, and has no chevron
                // or link suggesting a tap will expand it or navigate away
                stationCell
            } else if station.lineGroups.count == 1 {
                lineGroupCellLink(
                    for: station.lineGroups[0],
                    title: station.name,
                    showsDistance: true
                )
            } else {
                DisclosureGroup(isExpanded: $isExpanded) {
                    ForEach(station.lineGroups.sortedByName()) { lineGroup in
                        lineGroupCellLink(
                            for: lineGroup,
                            title: lineGroup.name,
                            showsDistance: false
                        )
                    }
                    // Only whole stations can be reordered, not the line groups within them
                    .moveDisabled(true)
                } label: {
                    stationCell
                }
                .tint(.clear)
            }
        }
        .frame(minHeight: 52)
    }

    private var stationCell: some View {
        lineGroupCell(
            withLineIDs: station.sortedLineIDs,
            title: station.name,
            showsDistance: true
        )
        .accessibilityIdentifier(station.id)
    }


    private func lineGroupCellLink(
        for lineGroup: Station.LineGroup,
        title: String,
        showsDistance: Bool
    ) -> some View {
        NavigationLink(value: lineGroup) {
            lineGroupCell(
                withLineIDs: lineGroup.lineIds.sortedByName(),
                title: title,
                showsDistance: showsDistance
            )
        }
        .accessibilityIdentifier("\(lineGroup.id)")
    }

    private func lineGroupCell(
        withLineIDs lineIDs: [TrainLineID],
        title: String,
        showsDistance: Bool
    ) -> some View {
        LineGroupCell(
            style: style,
            lineIDs: lineIDs,
            title: title
        )
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
            ArrivalsPickerView(
                allStations: allStations,
                mode: mode,
                selection: $selection,
                onAction: { _ in }
            )
            .navigationTitle("Picker preview")
            .navigationDestination(item: $selection) { selection in
                Text("\(String(describing: selection)) selected")
            }
        }
    }
}


#Preview("Normal mode (favourites)") {
    WrapperView(
        mode: .favouritesVisible(
            favourites: [
                "940GZZLUKSX-circle,hammersmith-city,metropolitan",  // Kings X - Circle, H&C, Met lines
                "940GZZLUKSX-northern",  // Kings X - Northern line
                "940GZZLUKSX-piccadilly",  // Kingx X - Piccadilly line
                "940GZZLUPAC-bakerloo",
                "940GZZLUHBT-northern"
            ],
            order: []
        )
    )
}

#Preview("Normal mode (no favourites)") {
    WrapperView(mode: .favouritesVisible(favourites: [], order: []))
}

#Preview("Search results mode") {
    WrapperView(
        allStations: Array(ModelStubs.stations.prefix(4)),
        mode: .searchResults
    )
    .searchable(text: .constant(""), placement: .navigationBarDrawer(displayMode: .always))
}
