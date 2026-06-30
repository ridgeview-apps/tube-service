import DataStores
import Shared
import UIKit

final class AppDelegate: NSObject, UIApplicationDelegate {

    let registeredPushTokens: AsyncStream<String>
    private let pushTokenContinuation: AsyncStream<String>.Continuation

    override init() {
        (registeredPushTokens, pushTokenContinuation) = AsyncStream.makeStream(of: String.self)
        super.init()
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

private extension Data {
    var hexString: String {
        map { String(format: "%02.2hhx", $0) }.joined()
    }
}
