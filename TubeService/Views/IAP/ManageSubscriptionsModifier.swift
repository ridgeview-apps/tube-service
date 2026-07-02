import StoreKit
import SwiftUI

private struct ManageSubscriptionsModifier: ViewModifier {
    @Binding var isPresented: Bool

    func body(content: Content) -> some View {
        content.manageSubscriptionsSheet(isPresented: $isPresented)
    }
}

extension View {
    func manageSubscriptions(isPresented: Binding<Bool>) -> some View {
        modifier(ManageSubscriptionsModifier(isPresented: isPresented))
    }
}
