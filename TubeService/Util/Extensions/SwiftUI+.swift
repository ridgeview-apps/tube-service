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

extension View {
    
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
}
