import CoreLocation

public extension LocationCoordinate {
    func toCLLocation() -> CLLocation {
        .init(latitude: lat, longitude: lon)
    }
}

public extension CLLocation {
    func toLocation() -> LocationCoordinate {
        .init(lat: self.coordinate.latitude,
              lon: self.coordinate.longitude)
    }
}
