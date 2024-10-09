import Foundation
import Testing

@testable import DataStores

@MainActor
struct SystemStatusDataStoreTests {
    
    @Test
    func fetchSystemStatusIfStale() async {
        // Given
        var clock = FakeClock(initialTime: .now)
        let systemStatusAPI = StubSystemStatusAPIClient()
        let model = SystemStatusDataStore(systemStatusAPI: systemStatusAPI,
                                          now: { clock.currentTime },
                                          calendar: .london)
        
        // Initial data refresh
        #expect(model.currentStatus == nil)
        await model.fetchSystemStatusIfStale()
        #expect(model.lastFetchedAt == clock.initialTime)
        #expect(systemStatusAPI.fetchSystemStatusCallCount == 1)
        
        // After 9 minutes (no change - data NOT stale)
        clock.addingMinutes(9)
        await model.fetchSystemStatusIfStale()
        #expect(model.lastFetchedAt == clock.initialTime) // No change
        #expect(systemStatusAPI.fetchSystemStatusCallCount == 1) // No change

        // After 10 minutes (fetch expected - data IS now stale)
        clock.addingMinutes(10)
        await model.fetchSystemStatusIfStale()
        #expect(model.lastFetchedAt == clock.currentTime)
        #expect(systemStatusAPI.fetchSystemStatusCallCount == 2)
    }
    
    
    @Test
    func fetchSystemStatusFailure() async throws {
        // Given
        let clock = FakeClock(initialTime: .now)
        let systemStatusAPI = StubSystemStatusAPIClient()
        let model = SystemStatusDataStore(systemStatusAPI: systemStatusAPI,
                                          now: { clock.currentTime },
                                          calendar: .london)
        
        // When
        systemStatusAPI.fetchSystemStatusError = .invalidRequestURL
        await model.fetchSystemStatusIfStale()
        
        // Then
        let requiredFetchState = try #require(model.fetchState)
        #expect(requiredFetchState.isError)
        #expect(model.lastFetchedAt == .distantPast)
        #expect(model.currentStatus == nil)
        #expect(systemStatusAPI.fetchSystemStatusCallCount == 1)
    }
    
}
