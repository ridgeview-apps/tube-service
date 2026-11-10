import CoreLocation
import Foundation
import Models

#if DEBUG

    /// Returns no name, so the current location stays unnamed rather than being looked up over the network.
    public struct StubReverseGeocoder: ReverseGeocoderType {

        public init() {}

        public func locationName(for location: CLLocation) async throws -> LocationName? {
            nil
        }
    }

#endif
