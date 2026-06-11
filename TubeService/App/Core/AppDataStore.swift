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

    var tflAPI: TflAPIClientType {
        dependencies.tflAPI
    }

    init(dependencies: AppDependencies) {
        self.dependencies = dependencies

        let stations = StationsDataStore(tflAPI: dependencies.tflAPI)
        self.stations = stations

        self.lineStatus = LineStatusDataStore(
            tflAPI: dependencies.tflAPI,
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
