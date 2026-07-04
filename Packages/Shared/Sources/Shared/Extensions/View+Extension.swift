import SwiftUI

extension View {

    public func onSceneDidBecomeActive(action: @escaping () -> ()) -> some View {
        modifier(OnChangeOfScenePhaseModifier(to: .active, action: action))
    }

    public func onSceneDidBecomeInactive(action: @escaping () -> ()) -> some View {
        modifier(OnChangeOfScenePhaseModifier(to: .inactive, action: action))
    }

    public func onSceneDidEnterBackground(action: @escaping () -> ()) -> some View {
        modifier(OnChangeOfScenePhaseModifier(to: .background, action: action))
    }

}

struct OnChangeOfScenePhaseModifier: ViewModifier {
    @Environment(\.scenePhase) private var scenePhase

    public let to: ScenePhase

    public let action: () -> ()

    public func body(content: Content) -> some View {
        content
            .onChange(of: scenePhase) { _, newPhase in
                if (newPhase == to) {
                    action()
                }
            }
    }
}
