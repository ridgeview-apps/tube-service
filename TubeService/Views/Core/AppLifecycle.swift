import SwiftUI
import Shared

struct AppLifecycleModifier: ViewModifier {

    let appData: AppDataStore
    let appDelegate: AppDelegate
    let appNavigator: AppNavigator

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
                    appNavigator.handleNotificationLaunch(payload)
                }
            }
            .onChange(of: appData.purchases.hasTubeServicePlus) { _, hasTubeServicePlus in
                Task { await appData.tubeServicePlusDidChange(hasTubeServicePlus) }
            }
            .onSceneDidBecomeActive {
                Task { await appData.sceneDidBecomeActive() }
            }
    }
}

extension View {

    func appLifecycle(appData: AppDataStore, appDelegate: AppDelegate, appNavigator: AppNavigator) -> some View {
        modifier(AppLifecycleModifier(appData: appData, appDelegate: appDelegate, appNavigator: appNavigator))
    }
}
