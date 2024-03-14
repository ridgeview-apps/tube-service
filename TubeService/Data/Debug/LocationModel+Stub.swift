import DataStores
import Foundation

#if DEBUG

extension LocationDataStore {
    
    static func stub() -> LocationDataStore {
        return .init(locationManager: StubLocationManager(), stations: .stub())
    }
}

#endif
