import SwiftUI

extension AnyTransition {
    
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

extension Binding {
    func debug(_ prefix: String) -> Binding {
        Binding(
            get: {
                print("\(prefix): getting \(self.wrappedValue)")
                return self.wrappedValue
        },
            set: {
                print("\(prefix): setting \(self.wrappedValue) to \($0)")
                self.wrappedValue = $0
        })
    }
}

extension View {
    
    func embeddedInNavigationView() -> some View {
        NavigationView { self }
    }
    
    func eraseToAnyView() -> AnyView {
        AnyView(self)
    }
    
    var phoneOnlyStackNavigationViewForIOS13: some View {
        // See: https://www.hackingwithswift.com/books/ios-swiftui/making-navigationview-work-in-landscape
        //
        // On iOS13, SwiftUI navigation links etc have a LOT of issues (which Apple never resolved until iOS14).
        // For iOS13, the simplest workaround is to force "StackNavigationViewStyle" on iPhone devices.
        //
        Group {
            if #available(iOS 14, *) {
                self
            } else {
                // iOS13
                if UIDevice.current.userInterfaceIdiom == .phone {
                    self.navigationViewStyle(StackNavigationViewStyle())
                } else {
                    self
                }
            }
        }
    }
    
    func roundedBorder(_ color: Color,
                       cornerRadius: CGFloat = 4,
                       lineWidth: CGFloat = 1) -> some View {
        self.cornerRadius(cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(color, lineWidth: lineWidth)
            )
    }
    
//    func onChange<V>(of srcValue: V, to targetValue: V, perform action: @escaping (V) -> Void) -> some View where V : Equatable {
//        self.onChange(of: srcValue, perform: { newValue in
//            if newValue == targetValue {
//                action(newValue)
//            }
//        })
//    }
//
    func onSceneDidBecomeActive(action: @escaping () -> ()) -> some View {
        self
            .modifier(OnChangeOfScenePhaseModifier(to: .active, action: action))
    }
    
    func onSceneDidBecomeInactive(action: @escaping () -> ()) -> some View {
        self
            .modifier(OnChangeOfScenePhaseModifier(to: .inactive, action: action))
    }
    
    func onSceneDidEnterBackground(action: @escaping () -> ()) -> some View {
        self
            .modifier(OnChangeOfScenePhaseModifier(to: .background, action: action))
    }
    
}

struct OnChangeOfScenePhaseModifier: ViewModifier {
    @Environment(\.scenePhase) private var scenePhase
    
    public let to: ScenePhase
    
    public let action: () -> ()
    
    public func body(content: Content) -> some View {
        content
            .onChange(of: scenePhase) { newPhase in
                if (newPhase == to) {
                    action()
                }
            }
    }
}
