import Foundation

public struct LocationCoordinate: Codable, Hashable {
    public let lat: Double
    public let lon: Double
    
    public init(lat: Double, lon: Double) {
        self.lat = lat
        self.lon = lon
    }
}

extension LocationCoordinate: Identifiable {
    public var id: Double { lat + lon }
}

public struct LocationName: Codable, Hashable, Identifiable {
    public var id: Self { self }
    
    public let title: String
    public let subtitle: String
    
    public init(title: String, subtitle: String) {
        self.title = title
        self.subtitle = subtitle
    }
}
