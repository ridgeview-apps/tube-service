import DataStores
import PresentationViews

extension DataFetchState {

    var loadingState: LoadingState {
        switch self {
        case .idle, .fetching:
            return .loading
        case .success:
            return .loaded
        case let .failure(error):
            return .failure(errorMessage: error.toUIErrorMessage())
        }
    }
}
