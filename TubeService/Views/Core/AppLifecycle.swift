import SwiftUI

struct AppLifecycleModifier: ViewModifier {

    let appData: AppDataStore
    let appDelegate: AppDelegate

    func body(content: Content) -> some View {
        content
            .task {
                await appData.start()
                for await token in appDelegate.registeredPushTokens {
                    await appData.handleRegisteredPushToken(token)
                }
            }
            .onSceneDidBecomeActive {
                Task { await appData.sceneDidBecomeActive() }
            }
    }
}

extension View {

    func appLifecycle(appData: AppDataStore, appDelegate: AppDelegate) -> some View {
        modifier(AppLifecycleModifier(appData: appData, appDelegate: appDelegate))
    }
}
