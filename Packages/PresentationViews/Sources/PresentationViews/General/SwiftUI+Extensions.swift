import SwiftUI

public extension AnyTransition {
    
    static var slideUp: AnyTransition {
        if #available(iOS 16.0, *) {
            return .push(from: .bottom)
        }
        
        let insertion = AnyTransition.move(edge: .bottom)
                                     .combined(with: .opacity)

        let removal = AnyTransition.move(edge: .top)
                                     .combined(with: .opacity)

        return .asymmetric(insertion: insertion, removal: removal)
    }
    
    static var slideDown: AnyTransition {
        if #available(iOS 16.0, *) {
            return .push(from: .top)
        }
        let insertion = AnyTransition.move(edge: .top)
                                     .combined(with: .opacity)

        let removal = AnyTransition.move(edge: .bottom)
                                     .combined(with: .opacity)

        return .asymmetric(insertion: insertion, removal: removal)
    }
}
