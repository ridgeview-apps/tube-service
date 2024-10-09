import Foundation
import Testing

@testable import DataStores


@MainActor
struct LineStatusDataStoreTests {
    
    @Test
    func refreshLineStatusesForToday() async throws {
        // Given
        let clock = FakeClock(initialTime: .now)
        let transportAPI = StubTransportAPIClient()
        let model = LineStatusDataStore(transportAPI: transportAPI,
                                        now: { clock.currentTime },
                                        calendar: .london)
        
        // When
        #expect(model.fetchedData(for: .today) == nil)
        await model.refreshLineStatuses(for: .today)
        let fetchedData = model.fetchedData(for: .today)
        
        // Then
        let requiredFetchedData = try #require(fetchedData)
        #expect(requiredFetchedData.fetchState.isSuccess)
        #expect(requiredFetchedData.fetchedAt == clock.currentTime)
        #expect(!requiredFetchedData.lines.isEmpty)
        #expect(transportAPI.fetchCurrentLineStatusesCallCount == 1)
    }
    
    @Test
    func refreshLineStatusesForDateRange() async throws {
        // Given
        let clock = FakeClock(initialTime: .now)
        let oneDay: TimeInterval = 60 * 60 * 24
        let transportAPI = StubTransportAPIClient()
        let model = LineStatusDataStore(transportAPI: transportAPI,
                                        now: { clock.currentTime },
                                        calendar: .london)
        
        // When
        let dateInterval = DateInterval(start: Date(), duration: oneDay)
        await model.refreshLineStatuses(for: .range(dateInterval))
        let fetchedData = model.fetchedData(for: .range(dateInterval))
        
        // Then
        let requiredFetchedData = try #require(fetchedData)
        #expect(requiredFetchedData.fetchState.isSuccess)
        #expect(requiredFetchedData.fetchedAt == clock.currentTime)
        #expect(!requiredFetchedData.lines.isEmpty)
        #expect(transportAPI.fetchLineStatusesForDateRangeCallCount == 1)
    }
    
    @Test
    func refreshLineStatusesFailure() async throws {
        // Given
        let clock = FakeClock(initialTime: .now)
        let transportAPI = StubTransportAPIClient()
        let model = LineStatusDataStore(transportAPI: transportAPI,
                                        now: { clock.currentTime },
                                        calendar: .london)
        
        // When
        transportAPI.fetchCurrentLineStatusesError = HTTPError.invalidRequestURL
        await model.refreshLineStatuses(for: .today)
        let fetchedData = model.fetchedData(for: .today)
        
        // Then
        let requiredFetchedData = try #require(fetchedData)
        #expect(requiredFetchedData.fetchState.isError)
        #expect(requiredFetchedData.fetchedAt == nil)
        #expect(requiredFetchedData.lines.isEmpty)
        #expect(transportAPI.fetchCurrentLineStatusesCallCount == 1)
    }
    
    @Test
    func refreshStaleLineStatuses() async throws {
        // Given
        var clock = FakeClock(initialTime: .now)
        let transportAPI = StubTransportAPIClient()
        let model = LineStatusDataStore(transportAPI: transportAPI,
                                        now: { clock.currentTime },
                                        calendar: .london)
        
        // Initial data refresh
        #expect(model.fetchedData(for: .today) == nil)
        await model.refreshLineStatusesIfStale(for: .today)
        #expect(model.fetchedData(for: .today)?.fetchedAt == clock.initialTime)
        #expect(transportAPI.fetchCurrentLineStatusesCallCount == 1)
        
        // After 4 minutes (no change - data NOT stale)
        clock.addingMinutes(4)
        await model.refreshLineStatusesIfStale(for: .today)
        #expect(model.fetchedData(for: .today)?.fetchedAt == clock.initialTime) // No change
        #expect(transportAPI.fetchCurrentLineStatusesCallCount == 1) // No change

        // After 5 minutes (fetch expected - data IS now stale)
        clock.addingMinutes(5)
        await model.refreshLineStatusesIfStale(for: .today)
        #expect(model.fetchedData(for: .today)?.fetchedAt == clock.currentTime)
        #expect(transportAPI.fetchCurrentLineStatusesCallCount == 2)
    }
    
}
