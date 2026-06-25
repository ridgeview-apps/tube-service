import Foundation

public enum DataFetchState: Sendable {
    case idle
    case fetching
    case success
    case failure(Error)
}
