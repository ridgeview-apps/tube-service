@testable import DataStores
import XCTest

final class SystemStatusDataStoreTests: XCTestCase {
    
    @MainActor
    func testFetchSystemStatusIfStale() async {
        // Given
        var clock = FakeClock(initialTime: .now)
        let systemStatusAPI = StubSystemStatusAPIClient()
        let model = SystemStatusDataStore(systemStatusAPI: systemStatusAPI,
                                          now: { clock.currentTime },
                                          calendar: .london)
        
        // Initial data refresh
        XCTAssertNil(model.currentStatus)
        await model.fetchSystemStatusIfStale()
        XCTAssertEqual(clock.initialTime, model.lastFetchedAt)
        XCTAssertEqual(1, systemStatusAPI.fetchSystemStatusCallCount)
        
        // After 9 minutes (no change - data NOT stale)
        clock.addingMinutes(9)
        await model.fetchSystemStatusIfStale()
        XCTAssertEqual(clock.initialTime, model.lastFetchedAt) // No change
        XCTAssertEqual(1, systemStatusAPI.fetchSystemStatusCallCount) // No change

        // After 10 minutes (fetch expected - data IS now stale)
        clock.addingMinutes(10)
        await model.fetchSystemStatusIfStale()
        XCTAssertEqual(clock.currentTime, model.lastFetchedAt)
        XCTAssertEqual(2, systemStatusAPI.fetchSystemStatusCallCount)
    }
    
    
    @MainActor
    func testFetchSystemStatusFailure() async {
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
        XCTAssertEqual(true, model.fetchState?.isError)
        XCTAssertEqual(model.lastFetchedAt, .distantPast)
        XCTAssertNil(model.currentStatus)
        XCTAssertEqual(1, systemStatusAPI.fetchSystemStatusCallCount)
    }
    
}
