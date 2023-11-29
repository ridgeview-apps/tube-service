import CoreLocation

public extension Location {
    func toCLLocation() -> CLLocation {
        .init(latitude: lat, longitude: lon)
    }
}

public extension CLLocation {
    func toLocation() -> Location {
        .init(lat: self.coordinate.latitude,
              lon: self.coordinate.longitude)
    }
}
