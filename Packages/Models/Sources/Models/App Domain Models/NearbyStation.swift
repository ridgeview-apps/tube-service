import Foundation

public struct NearbyStation: Hashable, Sendable {
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
