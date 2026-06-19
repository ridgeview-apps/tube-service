import Foundation
import Models

#if DEBUG

    public extension NotificationsDataStore {

        static func stub(
            api: NotificationsAPIClientType = StubNotificationsAPIClient()
        ) -> NotificationsDataStore {
            .init(api: api)
        }
    }

#endif
