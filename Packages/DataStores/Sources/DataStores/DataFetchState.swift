import Foundation

public enum DataFetchState: Sendable {
    case fetching
    case success
    case failure(Error)
}
