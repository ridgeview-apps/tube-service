import Foundation

public enum JourneyLocation: Hashable, Sendable {

    case station(Station)
    case nationalRail(StopPoint)
    case namedLocation(JourneyNamedLocation)

    public static func currentLocation(name: LocationName?, coordinate: LocationCoordinate?) -> JourneyLocation {
        .namedLocation(.init(name: name, coordinate: coordinate, isCurrentLocation: true))
    }

    public static let unknownCurrentLocation = JourneyLocation.namedLocation(
        .init(name: nil, coordinate: nil, isCurrentLocation: true)
    )

    public var isCurrentLocation: Bool {
        switch self {
        case .station, .nationalRail: return false
        case .namedLocation(let loc): return loc.isCurrentLocation
        }
    }
}

public struct JourneyNamedLocation: Hashable, Sendable {
    public let name: LocationName?
    public let coordinate: LocationCoordinate?
    public let isCurrentLocation: Bool

    public var isResolved: Bool { coordinate != nil }

    public init(name: LocationName?, coordinate: LocationCoordinate?, isCurrentLocation: Bool) {
        self.name = name
        self.coordinate = coordinate
        self.isCurrentLocation = isCurrentLocation
    }
}
