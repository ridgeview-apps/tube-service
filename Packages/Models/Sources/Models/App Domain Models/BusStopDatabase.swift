import Foundation

public struct BusStopDatabase: Sendable {

    public static let london = BusStopDatabase(stops: TemporaryBusStops.all)

    private let stops: [BusStop]

    init(stops: [BusStop]) {
        self.stops = stops
    }

    /// The stops nearest to `location`, nearest first.
    public func nearbyStops(to location: LocationCoordinate, limit: Int) -> [NearbyBusStop] {
        let nearest =
            stops
            .map { NearbyBusStop($0, distance: location.distance(to: $0.location)) }
            .sorted { $0.distance < $1.distance }
        return Array(nearest.prefix(limit))
    }

    /// The stop across the road, when the stop's place has just one other stop.
    public func oppositeStop(of stop: BusStop) -> BusStop? {
        let place = nearbyStops(to: stop.location, limit: 20)
            .groupedByPlace()
            .first { place in place.stops.contains { $0.stop.id == stop.id } }
        guard let place, place.stops.count == 2 else { return nil }
        return place.stops.first { $0.stop.id != stop.id }?.stop
    }
}
