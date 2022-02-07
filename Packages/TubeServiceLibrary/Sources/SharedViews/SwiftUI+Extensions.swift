import SwiftUI

public extension AnyTransition {
    
    static var slideUp: AnyTransition {
        let insertion = AnyTransition.move(edge: .bottom)
                                     .combined(with: .opacity)

        let removal = AnyTransition.move(edge: .top)
                                     .combined(with: .opacity)

        return .asymmetric(insertion: insertion, removal: removal)
    }
    
    static var slideDown: AnyTransition {
        let insertion = AnyTransition.move(edge: .top)
                                     .combined(with: .opacity)

        let removal = AnyTransition.move(edge: .bottom)
                                     .combined(with: .opacity)

        return .asymmetric(insertion: insertion, removal: removal)
    }
}

//
//public extension Binding {
//    func debug(_ prefix: String) -> Binding {
//        Binding(
//            get: {
//                print("\(prefix): getting \(self.wrappedValue)")
//                return self.wrappedValue
//        },
//            set: {
//                print("\(prefix): setting \(self.wrappedValue) to \($0)")
//                self.wrappedValue = $0
//        })
//    }
//}
//
//public extension View {
//    
//    func embeddedInNavigationView() -> some View {
//        NavigationView { self }
//    }
//    
//    func eraseToAnyView() -> AnyView {
//        AnyView(self)
//    }
//    
//    func onSceneDidBecomeActive(action: @escaping () -> ()) -> some View {
//        modifier(OnChangeOfScenePhaseModifier(to: .active, action: action))
//    }
//    
//    func onSceneDidBecomeInactive(action: @escaping () -> ()) -> some View {
//        modifier(OnChangeOfScenePhaseModifier(to: .inactive, action: action))
//    }
//    
//    func onSceneDidEnterBackground(action: @escaping () -> ()) -> some View {
//        modifier(OnChangeOfScenePhaseModifier(to: .background, action: action))
//    }
//    
//}
//
//public struct OnChangeOfScenePhaseModifier: ViewModifier {
//    @Environment(\.scenePhase) private var scenePhase
//    
//    public let to: ScenePhase
//    
//    public let action: () -> ()
//    
//    public func body(content: Content) -> some View {
//        content
//            .onChange(of: scenePhase) { newPhase in
//                if (newPhase == to) {
//                    action()
//                }
//            }
//    }
//}
