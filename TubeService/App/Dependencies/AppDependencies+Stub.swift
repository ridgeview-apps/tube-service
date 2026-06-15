import CoreLocation
import DataStores
import Foundation

#if DEBUG

    extension AppDependencies {
        static let stub: AppDependencies = {
            let locationManager = StubLocationManager()
            locationManager.locationsToReturnOnRequest = [
                CLLocation(latitude: 51.530823, longitude: -0.123821)
            ]

            return AppDependencies(
                tflAPI: StubTflAPIClient(),
                tubeServiceAPI: StubTubeServiceAPIClient(),
                systemStatusAPI: StubSystemStatusAPIClient(),
                locationManager: locationManager,
                localSearchCompleterClient: StubLocalSearchCompleterClient(),
                userDefaults: .stub
            )
        }()
    }

    extension AppDataStore {
        static let stub: AppDataStore = .init(dependencies: .stub)
    }

    extension UserDefaultsProvider {
        static let stub = UserDefaultsProvider(.init(suiteName: "StubbedSuite")!)
    }

#endif
