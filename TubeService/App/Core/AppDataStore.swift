import CoreLocation
import DataStores
import Foundation
@preconcurrency import MapKit

@MainActor
@Observable
final class AppDataStore {

    private(set) var lineStatus: LineStatusDataStore
    private(set) var stations: StationsDataStore
    private(set) var location: LocationDataStore
    private(set) var localSearchResults: LocalSearchResultsStore
    private(set) var systemStatus: SystemStatusDataStore

    private let dependencies: AppDependencies

    var transportAPI: TransportAPIClientType {
        dependencies.transportAPI
    }

    init(dependencies: AppDependencies) {
        self.dependencies = dependencies

        let stations = StationsDataStore(transportAPI: dependencies.transportAPI)
        self.stations = stations

        self.lineStatus = LineStatusDataStore(
            transportAPI: dependencies.transportAPI,
            now: dependencies.now
        )
        self.location = LocationDataStore(
            locationManager: dependencies.locationManager,
            stations: stations
        )
        self.localSearchResults = LocalSearchResultsStore(completerClient: dependencies.localSearchCompleterClient)
        self.systemStatus = SystemStatusDataStore(
            systemStatusAPI: dependencies.systemStatusAPI,
            now: dependencies.now
        )
    }

    func initialiseAppData() {
        dependencies.userDefaults.value.migrateLegacyValuesIfNeeded()
    }
}
