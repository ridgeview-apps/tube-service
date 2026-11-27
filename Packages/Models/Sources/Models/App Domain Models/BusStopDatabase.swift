import Foundation

public struct BusStopDatabase: Sendable {

    public static let london = BusStopDatabase(stops: TemporaryBusStops.all)

    private let stops: [BusStop]

    init(stops: [BusStop]) {
        self.stops = stops
    }

    /// The stops with the given IDs, in the same order, skipping any that aren't found.
    public func stops(ids: [BusStop.ID]) -> [BusStop] {
        let stopsByID = Dictionary(stops.map { ($0.id, $0) }, uniquingKeysWith: { first, _ in first })
        return ids.compactMap { stopsByID[$0] }
    }

    /// The stops nearest to `location`, nearest first.
    public func nearbyStops(to location: LocationCoordinate, limit: Int) -> [NearbyBusStop] {
        let nearest =
            stops
            .map { NearbyBusStop($0, distance: location.distance(to: $0.location)) }
            .sorted { $0.distance < $1.distance }
        return Array(nearest.prefix(limit))
    }

    /// The places whose nearest stop is within `radius` of `location`, nearest first.
    public func nearbyPlaces(to location: LocationCoordinate, within radius: Double, limit: Int) -> [NearbyBusPlace] {
        // A place within the radius can have stops beyond it, which must be grouped with it
        let places = stops(within: radius + NearbyBusPlace.maxSpan, of: location).groupedByPlace()
        return Array(places.prefix { $0.distance <= radius }.prefix(limit))
    }

    /// The stop across the road, when the stop's place has just one other stop.
    public func oppositeStop(of stop: BusStop) -> BusStop? {
        let place = stops(within: NearbyBusPlace.maxSpan, of: stop.location)
            .groupedByPlace()
            .first { place in place.stops.contains { $0.stop.id == stop.id } }
        guard let place, place.stops.count == 2 else { return nil }
        return place.stops.first { $0.stop.id != stop.id }?.stop
    }

    private func stops(within radius: Double, of location: LocationCoordinate) -> [NearbyBusStop] {
        stops
            .map { NearbyBusStop($0, distance: location.distance(to: $0.location)) }
            .filter { $0.distance <= radius }
    }
}
