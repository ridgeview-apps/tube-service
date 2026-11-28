import Foundation

public struct BusStop: Identifiable, Hashable, Sendable {
    public typealias ID = String

    /// The stop's NaPTAN ID, which TfL's arrivals take.
    public let id: ID
    public let name: String
    /// NaPTAN's locality, e.g. "Pentonville". Stops outside London have none.
    public let locality: String?
    /// The letter on the stop's flag, e.g. "H", "KX" or "155". Many outer London stops have none.
    public let letter: String?
    public let towards: String?
    /// The 5-digit code on the stop's flag. A few codes are shared by two stops.
    public let stopCode: String?
    /// TfL's stop area, shared by some stops on either side of a road. The busiest stops often have none.
    public let stopAreaID: String?
    public let location: LocationCoordinate
    /// The direction buses travel from the stop, e.g. "SE".
    public let bearing: String?
    public let isHailAndRide: Bool
    public let routes: [String]

    public init(
        id: ID,
        name: String,
        locality: String?,
        letter: String?,
        towards: String?,
        stopCode: String?,
        stopAreaID: String?,
        location: LocationCoordinate,
        bearing: String?,
        isHailAndRide: Bool,
        routes: [String]
    ) {
        self.id = id
        self.name = name
        self.locality = locality
        self.letter = letter
        self.towards = towards
        self.stopCode = stopCode
        self.stopAreaID = stopAreaID
        self.location = location
        self.bearing = bearing
        self.isHailAndRide = isHailAndRide
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

    static let maxSpan: Double = 150
}

extension Sequence where Element == NearbyBusStop {

    /// Groups stops into places, nearest first. Stops join a place if they share its stop area or name, and are
    /// within 150 m of its nearest stop, since some stop areas stretch along a road for half a kilometre.
    public func groupedByPlace() -> [NearbyBusPlace] {
        var groups: [[NearbyBusStop]] = []
        for nearbyStop in sorted(by: { $0.distance < $1.distance }) {
            let index = groups.firstIndex { group in
                group[0].stop.location.distance(to: nearbyStop.stop.location) <= NearbyBusPlace.maxSpan
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
