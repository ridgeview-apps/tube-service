import MapKit
import Models
import SwiftUI

/// Arrivals' Buses mode: a map of the nearby stops above a list of them, grouped into places.
public struct BusStopsView: View {

    public enum Action: Sendable {
        case tappedStop(BusStop)
        case tappedRefreshNearby
    }

    let nearby: [NearbyBusPlace]
    let locationAccess: LocationAccess
    let onAction: (Action) -> Void

    private static let collapsedNearbyCount = 3

    @State private var isNearbyExpanded = false
    @State private var expandedPlaceIDs: Set<NearbyBusPlace.ID> = []

    private var mapPlaces: [NearbyBusPlace] { Array(nearby.prefix(Self.collapsedNearbyCount)) }
    private var isNearbyExpandable: Bool { nearby.count > Self.collapsedNearbyCount }
    private var visibleNearby: [NearbyBusPlace] { isNearbyExpanded ? nearby : mapPlaces }

    private var firstNewNearbyScrollID: String? {
        nearby.dropFirst(Self.collapsedNearbyCount).first.map(Self.nearbyScrollID)
    }

    // A place's ID is its nearest stop's, which the stop tiles inside its row use too
    private static func nearbyScrollID(for place: NearbyBusPlace) -> String { "nearby-\(place.id)" }

    public init(
        nearby: [NearbyBusPlace],
        locationAccess: LocationAccess,
        onAction: @escaping (Action) -> Void
    ) {
        self.nearby = nearby
        self.locationAccess = locationAccess
        self.onAction = onAction
    }

    public var body: some View {
        ScrollViewReader { reader in
            List {
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
    var placeCount = 20

    private var places: [NearbyBusPlace] {
        BusStopDatabase.london.nearbyPlaces(to: location, within: 500, limit: placeCount)
    }

    var body: some View {
        NavigationStack {
            BusStopsView(
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

#Preview("Totteridge & Whetstone") {
    Previewer(location: LocationCoordinate(lat: 51.6302, lon: -0.1791))
}

#Preview("Location off") {
    Previewer(locationAccessState: .denied, placeCount: 0)
}

#Preview("Location failure - no stops") {
    Previewer(locationAccessState: .allowed(.failure(errorMessage: "Location unavailable")), placeCount: 0)
}
