import Foundation

public struct LocatedStation: Hashable, Sendable {
    public let distance: Double
    public let station: Station

    public init(
        _ station: Station,
        distance: Double
    ) {
        self.station = station
        self.distance = distance
    }
}
