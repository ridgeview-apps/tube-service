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
                notificationsAPI: StubNotificationsAPIClient(),
                systemStatusAPI: StubSystemStatusAPIClient(),
                locationManager: locationManager,
                localSearchCompleterClient: StubLocalSearchCompleterClient(),
                userDefaults: .stub,
                pushNotificationEnvironment: .stub,
                purchaseProductIDs: .stub
            )
        }()
    }

    extension AppDataStore {
        static let stub: AppDataStore = .init(dependencies: .stub)
    }

    extension UserDefaultsProvider {
        static let stub = UserDefaultsProvider(.init(suiteName: "StubbedSuite")!)
    }

    extension PushNotificationEnvironment {
        static let stub = PushNotificationEnvironment(
            readAuthStatus: { .authorized },
            requestAuthorization: { true },
            registerForRemoteNotifications: {}
        )
    }

    extension Array where Element == PurchaseStore.ProductID {
        static let stub: [PurchaseStore.ProductID] = [
            PurchaseStore.ProductID("stub.tube-service.plus"),
            PurchaseStore.ProductID("stub.tube-service.plus.monthly")
        ]
    }

#endif
