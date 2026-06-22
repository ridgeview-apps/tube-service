import Foundation
import Models
import UserNotifications

#if DEBUG

    public extension NotificationsDataStore {

        static func stub(
            api: NotificationsAPIClientType = StubNotificationsAPIClient(),
            authorizationStatus: UNAuthorizationStatus = .authorized
        ) -> NotificationsDataStore {
            let store = NotificationsDataStore(
                api: api,
                pushNotificationEnvironment: PushNotificationEnvironment(readAuthStatus: { .notDetermined }, requestAuthorization: { true }, registerForRemoteNotifications: {})
            )
            store.authorizationStatus = authorizationStatus
            return store
        }
    }

#endif
