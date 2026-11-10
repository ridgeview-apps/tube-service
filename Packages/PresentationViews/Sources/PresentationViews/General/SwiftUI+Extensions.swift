import SwiftUI

public extension AnyTransition {

    static var slideUp: AnyTransition {
        .push(from: .bottom)
    }

    static var slideDown: AnyTransition {
        .push(from: .top)
    }
}
