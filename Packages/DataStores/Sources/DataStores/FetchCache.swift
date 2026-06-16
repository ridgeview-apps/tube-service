import Foundation

struct FetchCache<Key: Hashable, Value> {
    struct Entry {
        var value: Value?
        var fetchedAt: Date?
        var fetchState: DataFetchState

        static var initial: Entry {
            Entry(value: nil, fetchedAt: nil, fetchState: .fetching)
        }
    }

    private var storage: [Key: Entry] = [:]

    subscript(key: Key) -> Entry? { storage[key] }

    mutating func beginFetch(for key: Key) -> Bool {
        if case .fetching = storage[key]?.fetchState { return false }
        storage[key, default: .initial].fetchState = .fetching
        return true
    }

    mutating func setSuccess(for key: Key, value: Value, fetchedAt: Date) {
        storage[key]?.value = value
        storage[key]?.fetchState = .success
        storage[key]?.fetchedAt = fetchedAt
    }

    mutating func setFailure(for key: Key, error: Error) {
        storage[key]?.fetchState = .failure(error)
    }

    mutating func markStale(for key: Key) {
        storage[key]?.fetchedAt = nil
    }
}
