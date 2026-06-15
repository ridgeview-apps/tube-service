import Foundation
import Testing

@testable import DataStores

struct FetchCacheTests {

    @Test
    func beginningFetchCreatesFetchingEntry() throws {
        var cache = FetchCache<String, Int>()

        let didBeginFetch = cache.beginFetch(for: "key")

        #expect(didBeginFetch)
        let entry = try #require(cache["key"])
        #expect(entry.value == nil)
        #expect(entry.fetchedAt == nil)
        #expect(entry.fetchState.isFetching)
    }

    @Test
    func beginningFetchWhileAlreadyFetchingIsIgnored() {
        var cache = FetchCache<String, Int>()

        let didBeginFirstFetch = cache.beginFetch(for: "key")
        let didBeginSecondFetch = cache.beginFetch(for: "key")

        #expect(didBeginFirstFetch)
        #expect(!didBeginSecondFetch)
    }

    @Test
    func successfulFetchStoresValueAndDate() throws {
        var cache = FetchCache<String, Int>()
        let fetchedAt = Date()

        let didBeginFetch = cache.beginFetch(for: "key")
        cache.setSuccess(for: "key", value: 42, fetchedAt: fetchedAt)

        #expect(didBeginFetch)
        let entry = try #require(cache["key"])
        #expect(entry.value == 42)
        #expect(entry.fetchedAt == fetchedAt)
        #expect(entry.fetchState.isSuccess)
    }

    @Test
    func refreshingPreservesExistingValueAndDate() throws {
        var cache = FetchCache<String, Int>()
        let fetchedAt = Date()
        let didBeginInitialFetch = cache.beginFetch(for: "key")
        cache.setSuccess(for: "key", value: 42, fetchedAt: fetchedAt)

        let didBeginRefresh = cache.beginFetch(for: "key")

        #expect(didBeginInitialFetch)
        #expect(didBeginRefresh)
        let entry = try #require(cache["key"])
        #expect(entry.value == 42)
        #expect(entry.fetchedAt == fetchedAt)
        #expect(entry.fetchState.isFetching)
    }

    @Test
    func failedRefreshPreservesExistingValueAndDate() throws {
        var cache = FetchCache<String, Int>()
        let fetchedAt = Date()
        let didBeginInitialFetch = cache.beginFetch(for: "key")
        cache.setSuccess(for: "key", value: 42, fetchedAt: fetchedAt)
        let didBeginRefresh = cache.beginFetch(for: "key")

        cache.setFailure(for: "key", error: TestError.example)

        #expect(didBeginInitialFetch)
        #expect(didBeginRefresh)
        let entry = try #require(cache["key"])
        #expect(entry.value == 42)
        #expect(entry.fetchedAt == fetchedAt)
        #expect(entry.fetchState.isError)
    }
}

private enum TestError: Error {
    case example
}

private extension DataFetchState {
    var isFetching: Bool {
        guard case .fetching = self else { return false }
        return true
    }
}
