import CoreLocation

public extension LocationCoordinate {
    func toCLLocation() -> CLLocation {
        .init(latitude: lat, longitude: lon)
    }

    /// The distance in metres.
    func distance(to other: LocationCoordinate) -> Double {
        toCLLocation().distance(from: other.toCLLocation())
    }
}

public extension CLLocation {
    func toLocation() -> LocationCoordinate {
        .init(
            lat: self.coordinate.latitude,
            lon: self.coordinate.longitude
        )
    }
}
