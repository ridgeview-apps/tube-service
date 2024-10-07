import SwiftUI


struct NavigationState<DestinationID: Hashable & Identifiable> {

    var navigationPath: NavigationPath = NavigationPath()
    
    mutating func push(to destinationID: DestinationID) {
        navigationPath.append(destinationID)
    }
    
    mutating func pop() {
        navigationPath.removeLast()
    }
}

extension View {
    
    func withNavigationState<DestinationID: Hashable & Identifiable>(
        _ navigationState: Binding<NavigationState<DestinationID>>,
        destination: @escaping (DestinationID) -> some View
    ) -> some View {
        navigationDestination(for: DestinationID.self) { destinationID in
            destination(destinationID)
        }
    }

}
