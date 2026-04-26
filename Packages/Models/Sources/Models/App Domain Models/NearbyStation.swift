import Foundation

public struct NearbyStation: Hashable, Sendable {
    public let distance: Double
    public let station: Station
    
    public init(distance: Double, station: Station) {
        self.distance = distance
        self.station = station
    }
}
