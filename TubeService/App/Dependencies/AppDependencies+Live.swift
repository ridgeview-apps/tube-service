import CoreLocation
import DataStores
import Foundation
@preconcurrency import MapKit
import UIKit
import UserNotifications

extension AppDependencies {
    static let live = AppDependencies(
        tflAPI: TflAPIClient.live,
        tubeServiceAPI: TubeServiceAPIClient.live,
        notificationsAPI: TubeServiceAPIClient.live,
        systemStatusAPI: SystemStatusAPIClient.live,
        locationManager: CLLocationManager(),
        localSearchCompleterClient: MKLocalSearchCompleter(),
        userDefaults: .live,
        pushNotificationEnvironment: .live
    )
}

extension AppDataStore {
    static let live: AppDataStore = .init(dependencies: .live)
}

extension TflAPIClient {
    static let live = TflAPIClient(
        baseURL: AppConfig.main.tflAPI.baseURL,
        appKey: AppConfig.main.tflAPI.appKey
    )
}

extension TubeServiceAPIClient {
    static let live = TubeServiceAPIClient(
        baseURL: AppConfig.main.tubeServiceAPI.baseURL,
        apiKey: AppConfig.main.tubeServiceAPI.apiKey
    )
}

extension SystemStatusAPIClient {
    static let live = SystemStatusAPIClient(
        baseURL: AppConfig.main.systemStatusAPI.baseURL,
        fileName: AppConfig.main.systemStatusAPI.fileName
    )
}

extension UserDefaultsProvider {
    static let live = UserDefaultsProvider(.standard)
}

extension PushNotificationEnvironment {
    static let live = PushNotificationEnvironment(
        readAuthStatus: {
            await UNUserNotificationCenter.current().notificationSettings().authorizationStatus
        },
        requestAuthorization: {
            try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound])
        },
        registerForRemoteNotifications: { @MainActor in
            UIApplication.shared.registerForRemoteNotifications()
        }
    )
}
