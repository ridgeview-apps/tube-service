import Foundation

public enum DataFetchState {
    case fetching
    case success
    case failure(Error)
}
