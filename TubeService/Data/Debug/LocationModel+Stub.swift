import DataStores
import Foundation

#if DEBUG

extension LocationDataStore {
    
    static func stub(stations: StationsDataStore) -> LocationDataStore {
        return .init(locationManager: StubLocationManager(), stations: stations)
    }
}

#endif
