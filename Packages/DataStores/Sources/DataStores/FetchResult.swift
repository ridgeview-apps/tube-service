import Foundation

public struct FetchResult<Value: Sendable>: Sendable {
    public var value: Value
    public var fetchedAt: Date?
    public var fetchState: DataFetchState
}
