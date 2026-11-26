import Shared
import SwiftUI
import Models

public struct ArrivalsStopPickerView: View {

    public enum Content: Sendable {
        case browse(favourites: [StopRow], recents: [StopRow], nearby: [StopRow])
        case searchResults(searchTerm: String, stations: [StopRow])
    }

    public enum Action: Sendable {
        case tappedStation(Station)
        case tappedFindStation
        case tappedRefreshNearby
        case tappedClearRecents
        case reorderFavourites([Station.ID])
        case removeFavourites([Station.ID])
    }

    let content: Content
    let locationAccess: LocationAccess
    let onAction: (Action) -> Void

    private static let collapsedNearbyCount = 3

    @State private var editMode: EditMode = .inactive
    @State private var isNearbyExpanded = false
    @Environment(\.isSearching) private var isSearching

    private var favourites: [StopRow] {
        guard case .browse(let favourites, _, _) = content else { return [] }
        return favourites
    }

    private var canReorderFavourites: Bool { favourites.count > 1 }

    // Favourite rows can't be tapped in edit mode, so editing would leave them as dead shortcuts while searching
    private var canEditFavourites: Bool { !favourites.isEmpty && !isSearching }

    private var nearby: [StopRow] {
        guard case .browse(_, _, let nearby) = content else { return [] }
        return nearby
    }

    private var isNearbyExpandable: Bool { nearby.count > Self.collapsedNearbyCount }

    private var visibleNearby: [StopRow] {
        isNearbyExpanded ? nearby : Array(nearby.prefix(Self.collapsedNearbyCount))
    }

    // MARK: - Init

    public init(
        content: Content,
        locationAccess: LocationAccess,
        onAction: @escaping (Action) -> Void
    ) {
        self.content = content
        self.locationAccess = locationAccess
        self.onAction = onAction
    }

    // MARK: Layout

    public var body: some View {
        contentView
            .defaultMaxWidthWithFullBackground()
            .environment(\.editMode, $editMode)
            .onChange(of: canEditFavourites) {
                if !canEditFavourites { editMode = .inactive }
            }
    }

    @ViewBuilder private var contentView: some View {
        switch content {
        case .browse(let favourites, let recents, _):
            browseList(favourites: favourites, recents: recents)
        case .searchResults(let searchTerm, let stations) where stations.isEmpty:
            ContentUnavailableView.search(text: searchTerm)
        case .searchResults(_, let stations):
            List {
                Section {
                    ForEach(stations) { row in
                        stationButton(for: row)
                    }
                }
                .lineGroupListRowStyle()
            }
            .listSectionSpacing(.compact)
        }
    }

    private func browseList(favourites: [StopRow], recents: [StopRow]) -> some View {
        List {
            favouritesSection(favourites)
            recentsSection(recents)
            NearbyStationsSection(
                title: .searchNearbySectionTitle,
                locationAccess: locationAccess,
                rows: visibleNearby,
                onAction: handleNearbyAction
            )
            if isNearbyExpandable {
                nearbyExpansionButton
            }
        }
        .onChange(of: Set(nearby.map(\.id))) {
            isNearbyExpanded = false
        }
        .accessibilityIdentifier(AccessibilityID.ArrivalsStopPicker.list)
    }

    @ViewBuilder private func favouritesSection(_ favourites: [StopRow]) -> some View {
        Section {
            if favourites.isEmpty {
                noFavouritesHintRow
            } else {
                ForEach(favourites) { row in
                    FavouriteStopRowCell(row: row) {
                        handleTap(on: row)
                    }
                }
                .onMove(perform: moveFavourites)
                .onDelete(perform: removeFavourites)
                .moveDisabled(!canReorderFavourites)
                // Empty swipe actions replace onDelete's swipe-to-delete, so stations are only removable from
                // edit mode. Toggling deleteDisabled with edit mode instead stops the delete controls animating in.
                .swipeActions {}
            }
        } header: {
            HStack {
                LineGroupSectionHeader(
                    title: .globalFavourites,
                    imageName: "star.fill"
                )
                Spacer()
                if canEditFavourites {
                    EditModeButton(editMode: $editMode)
                }
            }
            .secondarySectionHeaderStyle()
        }
        .lineGroupListRowStyle()
    }

    private var noFavouritesHintRow: some View {
        HStack(spacing: 12) {
            Image(systemName: "star")
                .foregroundStyle(.secondary)
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: 2) {
                Text(.arrivalsNoFavouritesTitle)
                Text(.arrivalsNoFavouritesSubtitle)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            // The button only activates search, so it has nothing to do once search is active
            if !isSearching {
                Button(.arrivalsNoFavouritesButtonTitle) {
                    onAction(.tappedFindStation)
                }
                .buttonStyle(.bordered)
                .buttonBorderShape(.capsule)
                .controlSize(.small)
            }
        }
        .frame(minHeight: 52)
    }

    @ViewBuilder private func recentsSection(_ recents: [StopRow]) -> some View {
        if !recents.isEmpty {
            Section {
                ForEach(recents) { row in
                    stationButton(for: row)
                }
            } header: {
                HStack {
                    LineGroupSectionHeader(title: .searchRecentSectionTitle, imageName: "clock")
                    Spacer()
                    SectionHeaderButton(title: .searchRecentClearButtonTitle) {
                        withAnimation { onAction(.tappedClearRecents) }
                    }
                }
                .secondarySectionHeaderStyle()
            }
            .lineGroupListRowStyle()
        }
    }

    private func stationButton(for row: StopRow) -> some View {
        Button {
            handleTap(on: row)
        } label: {
            StopRowCell(row: row)
        }
        .buttonStyle(.plain)
        .accessibilityIdentifier(AccessibilityID.ArrivalsStopPicker.station(row.stationID))
    }

    private var nearbyExpansionButton: some View {
        Section {
            HStack {
                Spacer()
                ExpansionInfoButton(
                    titleState: .init(collapsed: .nearbyShowAllButtonTitle, expanded: .nearbyShowLessButtonTitle),
                    isExpanded: $isNearbyExpanded
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

    private func handleTap(on row: StopRow) {
        switch row.kind {
        case .station(let station):
            onAction(.tappedStation(station))
        }
    }

    private func handleNearbyAction(_ action: NearbyStationsSection.Action) {
        switch action {
        case .tappedRefresh:
            onAction(.tappedRefreshNearby)
        case .tappedStation(let station):
            onAction(.tappedStation(station))
        }
    }

    private func moveFavourites(fromOffsets source: IndexSet, toOffset destination: Int) {
        var reorderedStationIDs = favourites.map(\.stationID)
        reorderedStationIDs.move(fromOffsets: source, toOffset: destination)
        onAction(.reorderFavourites(reorderedStationIDs))
    }

    private func removeFavourites(atOffsets offsets: IndexSet) {
        let removedStationIDs = offsets.map { favourites[$0].stationID }
        withAnimation { onAction(.removeFavourites(removedStationIDs)) }
    }
}


private struct FavouriteStopRowCell: View {

    let row: StopRow
    let onTap: () -> Void

    @Environment(\.editMode) private var editMode

    private var isEditing: Bool { editMode?.wrappedValue.isEditing == true }

    var body: some View {
        Group {
            if isEditing {
                // A plain row while editing: it's dragged as a whole station, and a tap mustn't navigate away
                StopRowCell(row: row)
            } else {
                Button(action: onTap) {
                    StopRowCell(row: row)
                }
                .buttonStyle(.plain)
            }
        }
        .accessibilityIdentifier(AccessibilityID.ArrivalsStopPicker.favouriteStation(row.stationID))
    }
}


private extension StopRow {
    var stationID: Station.ID {
        switch kind {
        case .station(let station): station.id
        }
    }
}


// MARK: - Previews

import ModelStubs

private struct Previewer: View {
    var favourites: [StopRow] = previewFavourites
    var recents: [StopRow] = previewRecents
    var nearby: [StopRow] = previewNearby
    var searchResults: (searchTerm: String, stations: [StopRow])?
    var locationAccessState: LocationAccess.State = .allowed(.loaded)

    private var content: ArrivalsStopPickerView.Content {
        if let searchResults {
            .searchResults(searchTerm: searchResults.searchTerm, stations: searchResults.stations)
        } else {
            .browse(favourites: favourites, recents: recents, nearby: nearby)
        }
    }

    var body: some View {
        NavigationStack {
            ArrivalsStopPickerView(
                content: content,
                locationAccess: .init(state: locationAccessState) {
                    print("Permissions requested")
                },
                onAction: { print($0) }
            )
            .navigationTitle("Live arrivals")
        }
    }
}

private let previewFavourites = ModelStubs.stations
    .favourites(matching: [
        .station(id: "HUBKGX"),  // King's Cross & St Pancras International
        .station(id: "HUBPAD"),  // Paddington
        .station(id: "940GZZLUHBT")  // High Barnet
    ])
    .map { StopRow(station: $0) }

private let previewRecents = [ModelStubs.eastFinchleyStation].map { StopRow(station: $0) }

private let previewNearby = [
    ModelStubs.nearbyStationWoodsidePark,
    ModelStubs.nearbyStationWestFinchley,
    ModelStubs.nearbyStationTotteridgeAndWhetstone
].map(StopRow.init)

#Preview("Favourites, recents and nearby") {
    Previewer()
}

#Preview("Nearby - expandable") {
    Previewer(nearby: previewNearby + [StopRow(ModelStubs.nearbyStationFinchleyCentral)])
}

#Preview("New user - location not asked") {
    Previewer(favourites: [], recents: [], nearby: [], locationAccessState: .notAsked)
}

#Preview("New user - location off") {
    Previewer(favourites: [], recents: [], nearby: [], locationAccessState: .denied)
}

#Preview("Location update failure") {
    // Keeps the last nearby stations, as the store does when a refresh fails
    Previewer(locationAccessState: .allowed(.failure(errorMessage: "Location unavailable")))
}

#Preview("Location failure - no stations") {
    Previewer(nearby: [], locationAccessState: .allowed(.failure(errorMessage: "Location unavailable")))
}

#Preview("New user - location allowed") {
    Previewer(favourites: [], recents: [])
}

#Preview("Search results") {
    Previewer(
        searchResults: (
            searchTerm: "finchley",
            stations: [ModelStubs.eastFinchleyStation, ModelStubs.finchleyCentralStation, ModelStubs.westFinchleyStation].map { StopRow(station: $0) }
        )
    )
}

#Preview("Search - no results") {
    Previewer(searchResults: (searchTerm: "xyz", stations: []))
}
