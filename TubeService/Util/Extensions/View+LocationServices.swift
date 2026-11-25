import CoreLocation
import DataStores
import Models
import SwiftUI

enum DetectLocationChangesAction {
    case coordinateChanged(LocationCoordinate?)
    case nameChanged(LocationName?)
    case authorizationStatusChanged(CLAuthorizationStatus)
}

@MainActor
struct DetectsLocationChangesViewModifier: ViewModifier {
    @Environment(LocationDataStore.self) var location
    @State var isVisible: Bool = false

    let action: (DetectLocationChangesAction) -> Void

    func body(content: Content) -> some View {
        content
            .onAppear {
                isVisible = true
                location.refreshCurrentLocationIfStale()
            }
            .onDisappear {
                isVisible = false
            }
            .onSceneDidBecomeActive {
                if isVisible {
                    location.refreshCurrentLocationIfStale()
                }
            }
            .onChange(of: location.currentLocationCoordinate) { _, updatedValue in
                action(.coordinateChanged(updatedValue))
            }
            .onChange(of: location.currentLocationName) { _, updatedValue in
                action(.nameChanged(updatedValue))
            }
            .onChange(of: location.authorizationStatus) { _, updatedValue in
                action(.authorizationStatusChanged(updatedValue))
            }
    }
}

extension View {
    func detectsLocationChanges(action: @escaping (DetectLocationChangesAction) -> Void = { _ in }) -> some View {
        self.modifier(
            DetectsLocationChangesViewModifier(action: action)
        )
    }
}
