import DataStores
import Models
import Shared
import UIKit
import UserNotifications

final class AppDelegate: NSObject, UIApplicationDelegate {

    let registeredPushTokens: AsyncStream<String>
    private let pushTokenContinuation: AsyncStream<String>.Continuation

    let notificationLaunches: AsyncStream<LineStatusNotificationPayload>
    private let notificationLaunchContinuation: AsyncStream<LineStatusNotificationPayload>.Continuation

    override init() {
        (registeredPushTokens, pushTokenContinuation) = AsyncStream.makeStream(of: String.self)
        (notificationLaunches, notificationLaunchContinuation) = AsyncStream.makeStream(
            of: LineStatusNotificationPayload.self
        )
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }

    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        pushTokenContinuation.yield(deviceToken.hexString)
    }

    func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error
    ) {
        AppLogger.notifications.error("Failed to register for remote notifications: \(error)")
    }
}

extension AppDelegate: @preconcurrency UNUserNotificationCenterDelegate {
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        let userInfo = response.notification.request.content.userInfo
        if let payload = LineStatusNotificationPayload(userInfo: userInfo) {
            notificationLaunchContinuation.yield(payload)
        }
        completionHandler()
    }
}

private extension Data {
    var hexString: String {
        map { String(format: "%02.2hhx", $0) }.joined()
    }
}
