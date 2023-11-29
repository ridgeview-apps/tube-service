import DataClients
import Foundation

#if DEBUG

extension LocationModel {
    
    static func stub() -> LocationModel {
        return .init(locationManager: StubLocationClient())
    }
}

#endif
