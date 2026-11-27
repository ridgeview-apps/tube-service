import Foundation

/// A stop the user has favourited.
public enum FavouriteStop: Hashable, Codable, Sendable {
    case station(id: Station.ID)
    case busStop(id: BusStop.ID)
}

extension Sequence where Element == FavouriteStop {

    public var busStopIDs: [BusStop.ID] {
        compactMap { stop in
            guard case .busStop(let id) = stop else { return nil }
            return id
        }
    }
}
