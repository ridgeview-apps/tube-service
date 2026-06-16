import SwiftUI

struct AppLifecycleModifier: ViewModifier {

    @Environment(AppDataStore.self) var appData

    func body(content: Content) -> some View {
        content
            .task {
                await appData.start()
            }
            .onSceneDidBecomeActive {
                Task { await appData.sceneDidBecomeActive() }
            }
    }
}

extension View {

    func appLifecycle() -> some View {
        modifier(AppLifecycleModifier())
    }
}
