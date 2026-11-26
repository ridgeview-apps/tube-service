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
}
