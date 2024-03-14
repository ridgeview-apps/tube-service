import SwiftUI


struct NavigationState<DestinationID: Hashable & Identifiable> {
    enum Style {
        case modal, push
    }
    
    var style: Style
    var modalDestinationID: DestinationID?
    var navigationPath: NavigationPath
    
    mutating func modal(to destinationID: DestinationID) {
        style = .modal
        self.modalDestinationID = destinationID
    }
    
    mutating func push(to destinationID: DestinationID) {
        style = .push
        navigationPath.append(destinationID)
    }
    
    mutating func popOrDismiss() {
        switch style {
        case .modal:
            modalDestinationID = nil
        case .push:
            navigationPath.removeLast()
        }
    }
    
    static var root: NavigationState {
        .init(style: .push, modalDestinationID: nil, navigationPath: NavigationPath())
    }
}

extension View {
    
       func withNavigationState<DestinationID: Hashable & Identifiable>(
        _ navigationState: Binding<NavigationState<DestinationID>>,
        showsCloseButton: Bool = true,
        destination: @escaping (DestinationID) -> some View
    ) -> some View {
        self
            .navigationDestination(for: DestinationID.self) { destinationID in
                destination(destinationID)
            }
            .sheet(item: navigationState.modalDestinationID) { destinationID in
                NavigationStack {
                    destination(destinationID)
                        .toolbar {
                            if showsCloseButton {
                                NavigationButton.Close {
                                    navigationState.wrappedValue.modalDestinationID = nil
                                }
                            }
                        }
                }
            }
    }

}
