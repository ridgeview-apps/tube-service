@testable import Tube_Service

import DataClients
import XCTest

@MainActor
final class LineStatusModelTests: XCTestCase {
    
    func testRefreshLineStatusesForToday() async {
        // Given
        let clock = FakeClock(initialTime: .now)
        let transportAPI = StubTransportAPIClient()
        let model = LineStatusModel(transportAPI: transportAPI,
                                    now: { clock.currentTime },
                                    calendar: .london)
        
        // When
        XCTAssertNil(model.fetchedData(for: .today))
        await model.refreshLineStatuses(for: .today)
        let fetchedData = model.fetchedData(for: .today)
        
        // Then
        XCTAssertEqual(true, fetchedData?.fetchState.isSuccess)
        XCTAssertEqual(clock.currentTime, fetchedData?.fetchedAt)
        XCTAssertNotNil(fetchedData?.lines)
        XCTAssertEqual(1, transportAPI.fetchCurrentLineStatusesCallCount)
    }
    
    func testRefreshLineStatusesForDateRange() async {
        // Given
        let clock = FakeClock(initialTime: .now)
        let oneDay: TimeInterval = 60 * 60 * 24
        let transportAPI = StubTransportAPIClient()
        let model = LineStatusModel(transportAPI: transportAPI,
                                    now: { clock.currentTime },
                                    calendar: .london)
        
        // When
        let dateInterval = DateInterval(start: Date(), duration: oneDay)
        await model.refreshLineStatuses(for: .range(dateInterval))
        let fetchedData = model.fetchedData(for: .range(dateInterval))
        
        // Then
        XCTAssertEqual(true, fetchedData?.fetchState.isSuccess)
        XCTAssertEqual(clock.currentTime, fetchedData?.fetchedAt)
        XCTAssertNotNil(fetchedData?.lines)
        XCTAssertEqual(1, transportAPI.fetchLineStatusesForDateRangeCallCount)
    }
    
    func testRefreshLineStatusesFailure() async {
        // Given
        let clock = FakeClock(initialTime: .now)
        let transportAPI = StubTransportAPIClient()
        let model = LineStatusModel(transportAPI: transportAPI,
                                    now: { clock.currentTime },
                                    calendar: .london)
        
        // When
        transportAPI.fetchCurrentLineStatusesError = TransportAPIError.invalidRequestURL
        await model.refreshLineStatuses(for: .today)
        let fetchedData = model.fetchedData(for: .today)
        
        // Then
        XCTAssertEqual(true, fetchedData?.fetchState.isError)
        XCTAssertNil(fetchedData?.fetchedAt)
        XCTAssertEqual(true, fetchedData?.lines.isEmpty)
        XCTAssertEqual(1, transportAPI.fetchCurrentLineStatusesCallCount)
    }
    
    
    func testRefreshStaleLineStatuses() async {
        // Given
        var clock = FakeClock(initialTime: .now)
        let transportAPI = StubTransportAPIClient()
        let model = LineStatusModel(transportAPI: transportAPI,
                                    now: { clock.currentTime },
                                    calendar: .london)
        
        // Initial data refresh
        XCTAssertNil(model.fetchedData(for: .today))
        await model.refreshLineStatusesIfStale(for: .today)
        XCTAssertEqual(clock.initialTime, model.fetchedData(for: .today)?.fetchedAt)
        XCTAssertEqual(1, transportAPI.fetchCurrentLineStatusesCallCount)
        
        // After 4 minutes (no change - data NOT stale)
        clock.addingMinutes(4)
        await model.refreshLineStatusesIfStale(for: .today)
        XCTAssertEqual(clock.initialTime, model.fetchedData(for: .today)?.fetchedAt) // No change
        XCTAssertEqual(1, transportAPI.fetchCurrentLineStatusesCallCount) // No change

        // After 5 minutes (fetch expected - data IS now stale)
        clock.addingMinutes(5)
        await model.refreshLineStatusesIfStale(for: .today)
        XCTAssertEqual(clock.currentTime, model.fetchedData(for: .today)?.fetchedAt)
        XCTAssertEqual(2, transportAPI.fetchCurrentLineStatusesCallCount)
    }
    
}
