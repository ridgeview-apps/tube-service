import DataStores
import PresentationViews

extension LocationDataStore {

    func locationAccessState(loadingState: LoadingState) -> LocationAccess.State {
        switch authorizationStatus {
        case .notDetermined:
            return .notAsked
        case .restricted, .denied:
            return .denied
        case .authorizedAlways, .authorizedWhenInUse, .authorized:
            return .allowed(loadingState)
        @unknown default:
            return .allowed(loadingState)
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
