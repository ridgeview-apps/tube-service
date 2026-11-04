import CoreLocation
import Foundation

#if DEBUG

    /// Finds no placemarks, so the current location has no name rather than one looked up over the network.
    public struct StubReverseGeocoder: ReverseGeocoderType {

        public init() {}

        public func reverseGeocodeLocation(_ location: CLLocation) async throws -> [CLPlacemark] {
            []
        }
    }

#endif
