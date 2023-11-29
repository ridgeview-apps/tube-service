import Foundation

public struct NearbyStation: Hashable {
    public let distance: Double
    public let station: Station
    
    public init(distance: Double, station: Station) {
        self.distance = distance
        self.station = station
    }
}
