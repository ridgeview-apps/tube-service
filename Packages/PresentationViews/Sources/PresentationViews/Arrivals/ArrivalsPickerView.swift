import Shared
import SwiftUI
import Models

// MARK: - Data types

public enum ArrivalsPickerMode: Equatable {
    case favouritesVisible(favourites: [FavouriteStop])
    case searchResults
}


// MARK: - ArrivalsPickerView

public struct ArrivalsPickerView: View {

    public enum Action {
        case reorderFavourites([Station.ID])
        case removeFavourites([Station.ID])
    }

    public let mode: ArrivalsPickerMode
    public let allStations: [Station]

    @Binding public var selection: Station?
    public let onAction: (Action) -> Void

    private let favourites: [Station]

    @State private var editMode: EditMode = .inactive

    private var canReorderFavourites: Bool { favourites.count > 1 }

    // MARK: - Init

    public init(
        allStations: [Station],
        mode: ArrivalsPickerMode,
        selection: Binding<Station?>,
        onAction: @escaping (Action) -> Void
    ) {
        self.allStations = allStations
        self.mode = mode
        self._selection = selection
        self.onAction = onAction

        switch mode {
        case .favouritesVisible(let favourites):
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
        .accessibilityIdentifier(AccessibilityID.ArrivalsPicker.list)
        .defaultMaxWidthWithFullBackground()
        .environment(\.editMode, $editMode)
        .onChange(of: favourites.isEmpty) {
            if favourites.isEmpty { editMode = .inactive }
        }
    }

    @ViewBuilder private var favouritesSection: some View {
        if !favourites.isEmpty {
            Section {
                ForEach(favourites) { station in
                    ArrivalsPickerStationCell(station: station, isEditable: true)
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

    private func removeFavourites(atOffsets offsets: IndexSet) {
        let removedStationIDs = offsets.map { favourites[$0].id }
        withAnimation { onAction(.removeFavourites(removedStationIDs)) }
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
                ArrivalsPickerStationCell(station: station)
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


private struct ArrivalsPickerStationCell: View {

    let station: Station
    var isEditable = false

    @Environment(\.editMode) private var editMode

    private var isBeingEdited: Bool { isEditable && editMode?.wrappedValue.isEditing == true }

    var body: some View {
        Group {
            if isBeingEdited {
                // A plain row while editing: it's dragged as a whole station, and has no chevron suggesting a tap
                // will navigate away
                stationCell
            } else {
                NavigationLink(value: station) {
                    stationCell
                }
            }
        }
        .accessibilityIdentifier(
            isEditable
                ? AccessibilityID.ArrivalsPicker.favouriteStation(station.id)
                : AccessibilityID.ArrivalsPicker.station(station.id)
        )
        .frame(minHeight: 52)
    }

    private var stationCell: some View {
        LineGroupCell(style: .plain, lineIDs: station.sortedLineIDs, title: station.name)
    }
}


// MARK: - Previews

import ModelStubs

private struct WrapperView: View {
    var allStations: [Station] = ModelStubs.stations
    var mode: ArrivalsPickerMode
    @State var selection: Station?

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
                .station(id: "HUBKGX"),  // King's Cross & St Pancras International
                .station(id: "HUBPAD"),  // Paddington
                .station(id: "940GZZLUHBT")  // High Barnet
            ]
        )
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
