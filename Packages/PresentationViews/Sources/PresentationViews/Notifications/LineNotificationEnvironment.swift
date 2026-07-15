import SwiftUI

public extension EnvironmentValues {
    @Entry var lineSelectionZoomNamespace: Namespace.ID?
}

extension View {
    @ViewBuilder
    func matchedTransitionSourceIfPresent(id: some Hashable, in namespace: Namespace.ID?) -> some View {
        if let namespace {
            matchedTransitionSource(id: id, in: namespace)
        } else {
            self
        }
    }
}
