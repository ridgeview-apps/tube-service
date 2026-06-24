import Foundation

public struct RemoteData<Value: Sendable>: Sendable {
    public var value: Value
    public var fetchedAt: Date?
    public var fetchState: DataFetchState

    public mutating func succeed(with newValue: Value, fetchedAt: Date = .now) {
        value = newValue
        self.fetchedAt = fetchedAt
        fetchState = .success
    }
}
