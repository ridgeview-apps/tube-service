import Foundation

public struct BusStop: Identifiable, Hashable, Sendable {
    public typealias ID = String

    /// The stop's NaPTAN ID, which TfL's arrivals take.
    public let id: ID
    public let name: String
    /// The letter on the stop's flag, e.g. "H" or "KX". Many outer London stops have none.
    public let letter: String?
    public let towards: String?
    /// TfL's stop area, shared by some stops on either side of a road. The busiest stops often have none.
    public let stopAreaID: String?
    public let location: LocationCoordinate
    public let routes: [String]

    public init(
        id: ID,
        name: String,
        letter: String?,
        towards: String?,
        stopAreaID: String?,
        location: LocationCoordinate,
        routes: [String]
    ) {
        self.id = id
        self.name = name
        self.letter = letter
        self.towards = towards
        self.stopAreaID = stopAreaID
        self.location = location
        self.routes = routes
    }
}

public struct NearbyBusStop: Hashable, Sendable {
    public let stop: BusStop
    public let distance: Double

    public init(_ stop: BusStop, distance: Double) {
        self.stop = stop
        self.distance = distance
    }
}

/// Stops that read as one place, e.g. a stop on each side of the road.
public struct NearbyBusPlace: Identifiable, Hashable, Sendable {
    /// The nearest stop's ID.
    public let id: BusStop.ID
    public let name: String
    public let distance: Double
    /// Nearest first.
    public let stops: [NearbyBusStop]
}

extension Sequence where Element == NearbyBusStop {

    /// Groups stops into places, nearest first. Stops join a place if they share its stop area or name, and are
    /// within 150 m of its nearest stop, since some stop areas stretch along a road for half a kilometre.
    public func groupedByPlace() -> [NearbyBusPlace] {
        let maxPlaceSpan: Double = 150
        var groups: [[NearbyBusStop]] = []
        for nearbyStop in sorted(by: { $0.distance < $1.distance }) {
            let index = groups.firstIndex { group in
                group[0].stop.location.distance(to: nearbyStop.stop.location) <= maxPlaceSpan
                    && group.contains { $0.stop.isSamePlace(as: nearbyStop.stop) }
            }
            if let index {
                groups[index].append(nearbyStop)
            } else {
                groups.append([nearbyStop])
            }
        }
        return groups.map { stops in
            NearbyBusPlace(id: stops[0].stop.id, name: stops[0].stop.name, distance: stops[0].distance, stops: stops)
        }
    }
}

private extension BusStop {
    func isSamePlace(as other: BusStop) -> Bool {
        if let stopAreaID, stopAreaID == other.stopAreaID {
            return true
        }
        return name == other.name
    }
}
