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
                resumeLocationDetection()
            }
            .onDisappear {
                isVisible = false
                location.stopLocationUpdates()
            }
            .onSceneDidBecomeActive {
                if isVisible {
                    resumeLocationDetection()
                }
            }
            .onSceneDidBecomeInactive {
                location.stopLocationUpdates()
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
    
    private func resumeLocationDetection() {
        location.startLocationUpdatesIfAuthorized()
    }
}

extension View {
    func detectsLocationChanges(action: @escaping (DetectLocationChangesAction) -> Void) -> some View {
        self.modifier(
            DetectsLocationChangesViewModifier(action: action)
        )
    }
}
