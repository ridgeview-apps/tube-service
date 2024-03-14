import CoreLocation
import DataStores
import Models
import SwiftUI

enum DetectLocationChangesAction {
    case coordinateChanged(LocationCoordinate?)
    case nameChanged(LocationName?)
    case authorizationStatusChanged(CLAuthorizationStatus)
}

struct DetectsLocationChangesViewModifier: ViewModifier {
    @EnvironmentObject var location: LocationDataStore
    
    let action: (DetectLocationChangesAction) -> Void
    
    func body(content: Content) -> some View {
        content
            .onAppear { resumeLocationDetection() }
            .onSceneDidBecomeActive { resumeLocationDetection() }
            .onDisappear { location.stopDetectingCurrentLocation() }
            .onSceneDidBecomeInactive { location.stopDetectingCurrentLocation() }
            .onChange(of: location.currentLocationCoordinate) { updatedValue in
                action(.coordinateChanged(updatedValue))
            }
            .onChange(of: location.currentLocationName) { updatedValue in
                action(.nameChanged(updatedValue))
            }
            .onChange(of: location.authorizationStatus) { updatedValue in
                action(.authorizationStatusChanged(updatedValue))
            }
    }
    
    private func resumeLocationDetection() {
        location.startDetectingCurrentLocationIfAuthorized()
    }
}

extension View {
    func detectsLocationChanges(action: @escaping (DetectLocationChangesAction) -> Void) -> some View {
        self.modifier(
            DetectsLocationChangesViewModifier(action: action)
        )
    }
}
