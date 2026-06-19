import DataStores
import UIKit

final class AppDelegate: NSObject, UIApplicationDelegate {

    let pushTokens: AsyncStream<String>
    private let pushTokenContinuation: AsyncStream<String>.Continuation

    override init() {
        (pushTokens, pushTokenContinuation) = AsyncStream.makeStream(of: String.self)
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
        // Token unavailable; nothing to yield
    }
}

private extension Data {
    var hexString: String {
        map { String(format: "%02.2hhx", $0) }.joined()
    }
}
