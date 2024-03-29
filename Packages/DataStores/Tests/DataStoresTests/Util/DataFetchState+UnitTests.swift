@testable import DataStores

extension DataFetchState {
    
    var isSuccess: Bool {
        guard case .success = self else { return false }
        return true
    }
    
    var isError: Bool {
        guard case .failure = self else { return false }
        return true
    }
}
