import Foundation
import Combine
import DataClients

@MainActor
final class AppModel: ObservableObject {
    let dataClients: DataClients
    
    private(set) var lineStatus: LineStatusModel
    private(set) var stations: StationsModel
    private(set) var userPreferences: UserPreferencesModel
    private(set) var location: LocationModel
    
    init(dataClients: DataClients,
         now: @escaping () -> Date = { Date() }) {
        self.dataClients = dataClients
        
        self.lineStatus = LineStatusModel(transportAPI: dataClients.transportAPI, now: now)
        self.stations = StationsModel(stationsClient: dataClients.stations,
                                      transportAPI: dataClients.transportAPI)
        self.userPreferences = UserPreferencesModel(userPreferencesClient: dataClients.userPreferences)
        self.location = LocationModel(locationManager: dataClients.location )
    }
}


extension AppModel {
    static func real() -> AppModel {
        .init(dataClients: .real)
    }
}

#if DEBUG
extension AppModel {
    static func stub() -> AppModel {
        .init(dataClients: .stub)
    }
}
#endif
