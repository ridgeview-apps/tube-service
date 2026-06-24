import Foundation
import Models
import UserNotifications

#if DEBUG

    public extension NotificationsDataStore {

        static func stub(
            api: NotificationsAPIClientType = StubNotificationsAPIClient(),
            pushNotificationEnvironment: PushNotificationEnvironment = .init(
                readAuthStatus: { .notDetermined },
                requestAuthorization: { true },
                registerForRemoteNotifications: {}
            ),
            userDefaults: UserDefaults
        ) -> NotificationsDataStore {
            NotificationsDataStore(
                api: api,
                pushNotificationEnvironment: pushNotificationEnvironment,
                userDefaults: userDefaults
            )
        }
    }

#endif
