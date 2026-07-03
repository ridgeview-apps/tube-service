import SwiftUI

struct AppLifecycleModifier: ViewModifier {

    let appData: AppDataStore
    let appDelegate: AppDelegate
    let router: AppRouter

    func body(content: Content) -> some View {
        content
            .task {
                await appData.start()
                for await token in appDelegate.registeredPushTokens {
                    await appData.handleRegisteredPushToken(token)
                }
            }
            .task {
                for await payload in appDelegate.notificationLaunches {
                    await appData.handleNotificationLaunch(payload)
                    router.handleNotificationLaunch(payload)
                }
            }
            .onSceneDidBecomeActive {
                Task { await appData.sceneDidBecomeActive() }
            }
    }
}

extension View {

    func appLifecycle(appData: AppDataStore, appDelegate: AppDelegate, router: AppRouter) -> some View {
        modifier(AppLifecycleModifier(appData: appData, appDelegate: appDelegate, router: router))
    }
}
