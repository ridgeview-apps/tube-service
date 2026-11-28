import MapKit
import Models
import SwiftUI

/// Arrivals' Buses mode: favourite and recent stops, then a map of the nearby stops above a list of them, grouped
/// into places.
public struct BusStopsView: View {

    public enum Action: Sendable {
        case tappedStop(BusStop)
        case tappedRefreshNearby
        case tappedClearRecents
        case removeRecent(BusStop.ID)
        case reorderFavourites([BusStop.ID])
        case removeFavourites([BusStop.ID])
    }

    let favourites: [BusStop]
    let recents: [BusStop]
    let nearby: [NearbyBusPlace]
    let locationAccess: LocationAccess
    let onAction: (Action) -> Void

    private static let collapsedNearbyCount = 3

    @State private var editMode: EditMode = .inactive
    @State private var isNearbyExpanded = false
    @State private var expandedPlaceIDs: Set<NearbyBusPlace.ID> = []

    private var canEditFavourites: Bool { !favourites.isEmpty }

    private var mapPlaces: [NearbyBusPlace] { Array(nearby.prefix(Self.collapsedNearbyCount)) }
    private var isNearbyExpandable: Bool { nearby.count > Self.collapsedNearbyCount }
    private var visibleNearby: [NearbyBusPlace] { isNearbyExpanded ? nearby : mapPlaces }

    private var firstNewNearbyScrollID: String? {
        nearby.dropFirst(Self.collapsedNearbyCount).first.map(Self.nearbyScrollID)
    }

    // A place's ID is its nearest stop's, which the stop tiles inside its row use too
    private static func nearbyScrollID(for place: NearbyBusPlace) -> String { "nearby-\(place.id)" }

    public init(
        favourites: [BusStop],
        recents: [BusStop],
        nearby: [NearbyBusPlace],
        locationAccess: LocationAccess,
        onAction: @escaping (Action) -> Void
    ) {
        self.favourites = favourites
        self.recents = recents
        self.nearby = nearby
        self.locationAccess = locationAccess
        self.onAction = onAction
    }

    public var body: some View {
        ScrollViewReader { reader in
            List {
                favouritesSection
                recentsSection
                if !mapPlaces.isEmpty {
                    Section {
                        NearbyBusStopsMap(places: mapPlaces)
                            .frame(height: 160)
                            .listRowInsets(EdgeInsets())
                    }
                }
                NearbySection(
                    title: .searchNearbySectionTitle,
                    locationAccess: locationAccess,
                    isEmpty: nearby.isEmpty,
                    noResultsText: .nearbyBusStopsNoResults,
                    onRefresh: { onAction(.tappedRefreshNearby) }
                ) {
                    ForEach(visibleNearby) { place in
                        BusPlaceCell(place: place, isExpanded: expandedPlaceIDs.contains(place.id)) { action in
                            handlePlaceAction(action, in: place)
                        }
                        .id(Self.nearbyScrollID(for: place))
                    }
                }
                if isNearbyExpandable {
                    NearbyExpansionButton(isExpanded: $isNearbyExpanded)
                }
            }
            .onChange(of: isNearbyExpanded) {
                // With no anchor, this only scrolls if the place is off screen, and only far enough to show it
                if isNearbyExpanded, let firstNewNearbyScrollID {
                    withAnimation { reader.scrollTo(firstNewNearbyScrollID) }
                }
            }
            .onChange(of: Set(nearby.map(\.id))) {
                isNearbyExpanded = false
                expandedPlaceIDs = []
            }
        }
        .defaultMaxWidthWithFullBackground()
        .environment(\.editMode, $editMode)
        .onChange(of: canEditFavourites) {
            if !canEditFavourites { editMode = .inactive }
        }
    }

    private var favouritesSection: some View {
        Section {
            if favourites.isEmpty {
                NoFavouritesHintRow(subtitle: .arrivalsNoFavouritesBusSubtitle)
            } else {
                ForEach(favourites) { stop in
                    FavouriteBusStopCell(stop: stop) {
                        onAction(.tappedStop(stop))
                    }
                }
                .onMove(perform: moveFavourites)
                .onDelete(perform: removeFavourites)
                .moveDisabled(favourites.count < 2)
                // Empty swipe actions replace onDelete's swipe-to-delete, so stops are only removable from edit mode
                .swipeActions {}
            }
        } header: {
            HStack {
                LineGroupSectionHeader(title: .globalFavourites, imageName: "star.fill")
                Spacer()
                if canEditFavourites {
                    EditModeButton(editMode: $editMode)
                }
            }
            .secondarySectionHeaderStyle()
        }
        .lineGroupListRowStyle()
    }

    @ViewBuilder private var recentsSection: some View {
        if !recents.isEmpty {
            Section {
                ForEach(recents) { stop in
                    Button {
                        onAction(.tappedStop(stop))
                    } label: {
                        BusStopCell(stop: stop)
                    }
                    .buttonStyle(.plain)
                    .swipeToRemove {
                        onAction(.removeRecent(stop.id))
                    }
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

    private func moveFavourites(fromOffsets source: IndexSet, toOffset destination: Int) {
        var reorderedIDs = favourites.map(\.id)
        reorderedIDs.move(fromOffsets: source, toOffset: destination)
        onAction(.reorderFavourites(reorderedIDs))
    }

    private func removeFavourites(atOffsets offsets: IndexSet) {
        let removedIDs = offsets.map { favourites[$0].id }
        withAnimation { onAction(.removeFavourites(removedIDs)) }
    }

    private func handlePlaceAction(_ action: BusPlaceCell.Action, in place: NearbyBusPlace) {
        switch action {
        case .tappedStop(let stop):
            onAction(.tappedStop(stop))
        case .tappedMoreStops:
            expandedPlaceIDs.insert(place.id)
        }
    }
}

private struct FavouriteBusStopCell: View {

    let stop: BusStop
    let onTap: () -> Void

    @Environment(\.editMode) private var editMode

    var body: some View {
        if editMode?.wrappedValue.isEditing == true {
            BusStopCell(stop: stop)
        } else {
            Button(action: onTap) {
                BusStopCell(stop: stop)
            }
            .buttonStyle(.plain)
        }
    }
}

private struct NearbyBusStopsMap: View {
    let places: [NearbyBusPlace]

    @State private var position: MapCameraPosition = .automatic

    var body: some View {
        // Scrolling the list over a draggable map would keep catching the map instead
        Map(position: $position, interactionModes: []) {
            UserAnnotation()
            ForEach(places.flatMap(\.stops), id: \.stop.id) { nearbyStop in
                marker(for: nearbyStop.stop)
            }
        }
        .mapStyle(.standard(pointsOfInterest: .excludingAll))
        .accessibilityHidden(true)
    }

    private func marker(for stop: BusStop) -> some MapContent {
        let coordinate = stop.location.toCLLocation().coordinate
        return Group {
            if let letter = stop.letter {
                Marker(stop.name, monogram: Text(verbatim: letter), coordinate: coordinate)
            } else {
                Marker(stop.name, systemImage: "bus.doubledecker.fill", coordinate: coordinate)
            }
        }
        .tint(Color.bus)
    }
}

// MARK: - Previews

private struct Previewer: View {
    var location = LocationCoordinate(lat: 51.530823, lon: -0.123821)
    var locationAccessState: LocationAccess.State = .allowed(.loaded)
    var placeCount = 30
    var favouriteIDs = ["490000129D", "490000129R"]
    var recentIDs = ["490000129E"]

    private var places: [NearbyBusPlace] {
        BusStopDatabase.london.nearbyPlaces(to: location, within: 500, limit: placeCount)
    }

    var body: some View {
        NavigationStack {
            BusStopsView(
                favourites: BusStopDatabase.london.stops(ids: favouriteIDs),
                recents: BusStopDatabase.london.stops(ids: recentIDs),
                nearby: places,
                locationAccess: .init(state: locationAccessState) {},
                onAction: { print($0) }
            )
            .navigationTitle("Live arrivals")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview("King's Cross") {
    Previewer()
}

#Preview("No favourites or recents") {
    Previewer(favouriteIDs: [], recentIDs: [])
}

#Preview("Totteridge & Whetstone") {
    Previewer(location: LocationCoordinate(lat: 51.6302, lon: -0.1791))
}

#Preview("Location off") {
    Previewer(locationAccessState: .denied, placeCount: 0)
}

#Preview("Location failure - no stops") {
    Previewer(locationAccessState: .allowed(.failure(errorMessage: "Location unavailable")), placeCount: 0)
}
