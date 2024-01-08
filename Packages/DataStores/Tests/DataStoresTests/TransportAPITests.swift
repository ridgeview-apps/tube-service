@testable import DataStores

import Models
import XCTest

final class TransportAPIRouteTests: XCTestCase {
    
    private let baseURL = URL(string: "https://foo.com/")!
    private let appID = "testAppID"
    private let appKey = "testAppKey"
    
    func testGetCurrentLineStatusesEndpoint() throws {
        // Given
        let route: TransportAPIRoute = .getCurrentLineStatuses(TransportMode.allCases)
        
        // When
        let url = try route.toURL(relativeTo: baseURL, appID: appID, appKey: appKey)
        
        // Then
        XCTAssertEqual(
            "https://foo.com/Line/Mode/tube,dlr,overground,tram,elizabeth-line/Status?app_id=testAppID&app_key=testAppKey",
            url.absoluteString
        )
    }
    
    func testGetFutureLineStatusesEndpoint() throws {
        // Given
        let startDate = dayMonthYear(1, 2, 2023, in: .london)
        let endDate = dayMonthYear(2, 2, 2023, in: .london)
        let dateInterval = DateInterval(start: startDate, end: endDate)
        let route: TransportAPIRoute = .getLineStatusesForDateRange(LineID.allCases, dateInterval)
        
        // When
        let url = try route.toURL(relativeTo: baseURL, appID: appID, appKey: appKey)
        
        // Then
        XCTAssertEqual(
            "https://foo.com/Line/bakerloo,central,circle,district,dlr,elizabeth,hammersmith-city,jubilee,metropolitan,northern,piccadilly,victoria,waterloo-city,tram,london-overground/Status/2023-02-01/to/2023-02-02?app_id=testAppID&app_key=testAppKey",
            url.absoluteString
        )
    }
    
    func testArrivalPredictionsEndpoint() throws {
        // Given
        let route: TransportAPIRoute = .getArrivalPredictions(stationCode: "FAKE_STATION_CODE", [.circle, .hammersmithAndCity, .district, .northern])
        
        // When
        let url = try route.toURL(relativeTo: baseURL, appID: appID, appKey: appKey)
        
        // Then
        XCTAssertEqual(
            "https://foo.com/Line/circle,hammersmith-city,district,northern/Arrivals/FAKE_STATION_CODE?app_id=testAppID&app_key=testAppKey",
            url.absoluteString
        )
    }
    
    func testArrivalDeparturesEndpoint() throws {
        // Given
        let route: TransportAPIRoute = .getArrivalDepartures(stationCode: "FAKE_STATION_CODE", [.elizabeth])
        
        // When
        let url = try route.toURL(relativeTo: baseURL, appID: appID, appKey: appKey)
        
        // Then
        XCTAssertEqual(
            "https://foo.com/StopPoint/FAKE_STATION_CODE/ArrivalDepartures?app_id=testAppID&app_key=testAppKey&lineIds=elizabeth",
            url.absoluteString
        )
    }
    
    
    func testStationDisruptionsEndpoint() throws {
        // Given
        let route: TransportAPIRoute = .getStationDisruptions(TransportMode.allCases)
        
        // When
        let url = try route.toURL(relativeTo: baseURL, appID: appID, appKey: appKey)
        
        // Then
        XCTAssertEqual(
            "https://foo.com/StopPoint/Mode/tube,dlr,overground,tram,elizabeth-line/Disruption?app_id=testAppID&app_key=testAppKey",
            url.absoluteString
        )
    }
}


// MARK: - Private helpers

private extension TransportAPIRouteTests {
    

    private func dayMonthYear(_ day: Int, _ month: Int, _ year: Int, in timeZone: TimeZone) -> Date {
        let calendar = Calendar.iso8601(in: timeZone)
        let dateComponents = DateComponents(calendar: calendar,
                                            timeZone: calendar.timeZone,
                                            year: year,
                                            month: month,
                                            day: day)
        return calendar.date(from: dateComponents)!
    }
}
