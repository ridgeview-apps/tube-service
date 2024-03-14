import DataStores
import PresentationViews

extension LocationDataStore {
    
    func locationUIStyle(showsSetUpHeader: Bool = true) -> LocationUIStatus.Style {
        switch authorizationStatus {
        case .notDetermined:
            return .setUp(showsHeader: showsSetUpHeader)
        case .restricted, .denied:
            return .openSettingsToAllowLocation
        case .authorizedAlways, .authorizedWhenInUse, .authorized:
            return .locationAllowed
        @unknown default:
            return .locationAllowed
        }
    }
}

extension LocationDataStore.DetectionState {
    
    func toLoadingState() -> LoadingState {
        switch self {
        case .detecting:
            return .loading
        case .failed(let error):
            return .failure(errorMessage: error.toUIErrorMessage())
        case .detected:
            return .loaded
        }
    }
}
