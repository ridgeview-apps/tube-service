import Foundation

public struct SavedJourney: Identifiable, Hashable, Codable, Sendable {
    public enum LocationType: Hashable, Codable, Sendable {
        case station(id: Station.ID)
        case nationalRail(icsCode: String)
        case specific(LocationName, LocationCoordinate)

        public static func == (lhs: LocationType, rhs: LocationType) -> Bool {
            switch (lhs, rhs) {
            case let (.specific(lhsName, _), .specific(rhsName, _)):
                return lhsName == rhsName
            case let (.station(lhsID), .station(rhsID)):
                return lhsID == rhsID
            case let (.nationalRail(lhsID), .nationalRail(rhsID)):
                return lhsID == rhsID
            default:
                return false
            }
        }

        public func hash(into hasher: inout Hasher) {
            switch self {
            case .station(let stationID):
                hasher.combine(stationID)
            case .nationalRail(let stopPointID):
                hasher.combine(stopPointID)
            case .specific(let locationName, _):
                hasher.combine(locationName)
            }
        }
    }

    public let id: UUID
    public let fromLocation: LocationType
    public let toLocation: LocationType
    public let viaLocation: LocationType?
    public let lastUsed: Date

    public init(
        id: UUID,
        fromLocation: LocationType,
        toLocation: LocationType,
        viaLocation: LocationType?,
        lastUsed: Date
    ) {
        self.id = id
        self.fromLocation = fromLocation
        self.toLocation = toLocation
        self.viaLocation = viaLocation
        self.lastUsed = lastUsed
    }
}

extension SavedJourney.LocationType {
    /// Matches places by distance, not name: a name like "Edgware Road" covers places kilometres apart, and the
    /// same spot can be named differently over time. Kept out of `==`, which can't hash a distance.
    func isSamePlace(as other: SavedJourney.LocationType) -> Bool {
        switch (self, other) {
        case let (.specific(_, lhsCoordinate), .specific(_, rhsCoordinate)):
            let samePlaceMaxDistanceInMetres = 150.0
            return lhsCoordinate.distance(to: rhsCoordinate) <= samePlaceMaxDistanceInMetres
        default:
            return self == other
        }
    }
}

extension SavedJourney {
    func isSameJourney(as otherJourney: SavedJourney) -> Bool {
        fromLocation.isSamePlace(as: otherJourney.fromLocation)
            && toLocation.isSamePlace(as: otherJourney.toLocation)
            && isSameVia(as: otherJourney.viaLocation)
    }

    private func isSameVia(as otherViaLocation: LocationType?) -> Bool {
        switch (viaLocation, otherViaLocation) {
        case (nil, nil): true
        case let (lhs?, rhs?): lhs.isSamePlace(as: rhs)
        default: false
        }
    }

    func isSameOrReverseJourney(of otherJourney: SavedJourney) -> Bool {
        isSameJourney(as: otherJourney) || isReverseJourney(of: otherJourney)
    }

    private func isReverseJourney(of otherJourney: SavedJourney) -> Bool {
        isSameJourney(as: otherJourney.reversed())
    }

    private func reversed() -> SavedJourney {
        .init(
            id: id,
            fromLocation: toLocation,
            toLocation: fromLocation,
            viaLocation: viaLocation,
            lastUsed: lastUsed
        )
    }
}
