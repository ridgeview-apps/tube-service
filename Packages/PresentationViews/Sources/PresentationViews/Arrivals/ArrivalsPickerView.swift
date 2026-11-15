import Shared
import SwiftUI
import Models

public struct ArrivalsPickerView: View {

    public enum Action: Sendable {
        case tappedStation(Station)
        case tappedFindStation
        case tappedShowMoreNearby
        case tappedRefreshNearby
        case reorderFavourites([Station.ID])
        case removeFavourites([Station.ID])
    }

    let favourites: [StopRow]
    let recents: [StopRow]
    let nearby: [StopRow]
    let canShowMoreNearby: Bool
    let locationAccess: LocationAccess
    let onAction: (Action) -> Void

    @State private var editMode: EditMode = .inactive

    private var canReorderFavourites: Bool { favourites.count > 1 }

    // MARK: - Init

    public init(
        favourites: [StopRow],
        recents: [StopRow],
        nearby: [StopRow],
        canShowMoreNearby: Bool,
        locationAccess: LocationAccess,
        onAction: @escaping (Action) -> Void
    ) {
        self.favourites = favourites
        self.recents = recents
        self.nearby = nearby
        self.canShowMoreNearby = canShowMoreNearby
        self.locationAccess = locationAccess
        self.onAction = onAction
    }

    // MARK: Layout

    public var body: some View {
        ScrollViewReader { reader in
            List {
                favouritesSection
                recentsSection
                LocatedStationsSection(
                    title: .searchNearbySectionTitle,
                    locationAccess: locationAccess,
                    rows: nearby,
                    onAction: handleNearbyAction
                )
                showMoreNearbyButton
            }
            .listSectionSpacing(.compact)
            .onChange(of: nearby.count) {
                withAnimation {
                    reader.scrollTo(Self.showMoreNearbyButtonID)
                }
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
                    title: .arrivalsPickerFavouritesSectionTitle,
                    imageName: "star.fill"
                )
                Spacer()
                if !favourites.isEmpty {
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
                Text(.arrivalsPickerNoFavouritesTitle)
                Text(.arrivalsPickerNoFavouritesSubtitle)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Button(.arrivalsPickerNoFavouritesButtonTitle) {
                onAction(.tappedFindStation)
            }
            .buttonStyle(.bordered)
            .buttonBorderShape(.capsule)
            .controlSize(.small)
        }
        .frame(minHeight: 52)
    }

    @ViewBuilder private var recentsSection: some View {
        if !recents.isEmpty {
            Section {
                ForEach(recents) { row in
                    Button {
                        handleTap(on: row)
                    } label: {
                        StopRowCell(row: row)
                    }
                    .buttonStyle(.plain)
                    .accessibilityIdentifier(AccessibilityID.ArrivalsPicker.station(row.stationID))
                }
            } header: {
                Text(.searchRecentSectionTitle)
            }
            .lineGroupListRowStyle()
        }
    }

    private static let showMoreNearbyButtonID = "showMoreNearbyButton"

    @ViewBuilder private var showMoreNearbyButton: some View {
        if canShowMoreNearby {
            Section {
                HStack {
                    Spacer()
                    PagerButton(style: .down, title: .nearbyStationsMoreResultsButtonTitle) {
                        onAction(.tappedShowMoreNearby)
                    }
                    Spacer()
                }
                .id(Self.showMoreNearbyButtonID)
            }
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
            .listRowInsets(.init(top: 12, leading: 0, bottom: 12, trailing: 0))
        }
    }

    private func handleTap(on row: StopRow) {
        switch row.kind {
        case .station(let station):
            onAction(.tappedStation(station))
        }
    }

    private func handleNearbyAction(_ action: LocatedStationsSection.Action) {
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
        .accessibilityIdentifier(AccessibilityID.ArrivalsPicker.favouriteStation(row.stationID))
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
    var locationAccessState: LocationAccess.State = .allowed(.loaded)

    var body: some View {
        NavigationStack {
            ArrivalsPickerView(
                favourites: favourites,
                recents: recents,
                nearby: nearby,
                canShowMoreNearby: !nearby.isEmpty,
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
    ModelStubs.locatedStationWoodsidePark,
    ModelStubs.locatedStationWestFinchley,
    ModelStubs.locatedStationTotteridgeAndWhetstone
].map(StopRow.init)

#Preview("Favourites, recents and nearby") {
    Previewer()
}

#Preview("New user - location not asked") {
    Previewer(favourites: [], recents: [], nearby: [], locationAccessState: .notAsked)
}

#Preview("New user - location off") {
    Previewer(favourites: [], recents: [], nearby: [], locationAccessState: .denied)
}

#Preview("New user - location allowed") {
    Previewer(favourites: [], recents: [])
}
