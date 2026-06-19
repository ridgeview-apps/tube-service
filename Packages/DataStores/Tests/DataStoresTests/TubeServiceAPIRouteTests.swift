import Foundation
import Models
import Testing

@testable import DataStores

struct TubeServiceAPIRouteTests {

    private let baseURL = URL(string: "https://foo.com")!

    @Test
    func dailyLineTimelineEndpointWithoutDate() throws {
        // Given
        let route: TubeServiceAPIRoute = .dailyLineTimeline(lineID: .victoria, operationalDate: nil)

        // When
        let url = try route.toURL(relativeTo: baseURL)

        // Then
        let expectedValue = "https://foo.com/v1/line-status/timeline?line_id=victoria"
        #expect(url.absoluteString == expectedValue)
    }

    @Test
    func dailyLineTimelineEndpointWithDate() throws {
        // Given
        let date = dayMonthYear(11, 6, 2026, hour: 12, in: .london)
        let route: TubeServiceAPIRoute = .dailyLineTimeline(lineID: .hammersmithAndCity, operationalDate: date)

        // When
        let url = try route.toURL(relativeTo: baseURL)

        // Then
        let expectedValue = "https://foo.com/v1/line-status/timeline?line_id=hammersmith-city&date=2026-06-11"
        #expect(url.absoluteString == expectedValue)
    }

    @Test
    func dailyLineDisruptionSummaryEndpointWithoutDate() throws {
        // Given
        let route: TubeServiceAPIRoute = .dailyLineDisruptionSummary(operationalDate: nil)

        // When
        let url = try route.toURL(relativeTo: baseURL)

        // Then
        let expectedValue = "https://foo.com/v1/line-status/disruption-summary"
        #expect(url.absoluteString == expectedValue)
    }

    @Test
    func dailyLineDisruptionSummaryEndpointWithDate() throws {
        // Given
        let date = dayMonthYear(11, 6, 2026, hour: 12, in: .london)
        let route: TubeServiceAPIRoute = .dailyLineDisruptionSummary(operationalDate: date)

        // When
        let url = try route.toURL(relativeTo: baseURL)

        // Then
        let expectedValue = "https://foo.com/v1/line-status/disruption-summary?date=2026-06-11"
        #expect(url.absoluteString == expectedValue)
    }

    @Test
    func dailyLineTimelineEndpointMapsEarlyMorningToPreviousOperationalDay() throws {
        // Given — 1AM on June 11 is still the June 10 operational day (cutoff is 4AM)
        let date = dayMonthYear(11, 6, 2026, hour: 1, in: .london)
        let route: TubeServiceAPIRoute = .dailyLineTimeline(lineID: .victoria, operationalDate: date)

        // When
        let url = try route.toURL(relativeTo: baseURL)

        // Then
        let expectedValue = "https://foo.com/v1/line-status/timeline?line_id=victoria&date=2026-06-10"
        #expect(url.absoluteString == expectedValue)
    }

    // MARK: - Notification routes

    @Test
    func registerDeviceEndpoint() throws {
        // Given
        let route: TubeServiceAPIRoute = .registerDevice(deviceId: "device-abc", body: Data())

        // When
        let request = try route.toURLRequest(relativeTo: baseURL, apiKey: "test-key")

        // Then
        #expect(request.url?.absoluteString == "https://foo.com/v1/notification-devices/device-abc")
        #expect(request.httpMethod == "PUT")
        #expect(request.value(forHTTPHeaderField: "Content-Type") == "application/json")
    }

    @Test
    func deleteDeviceEndpoint() throws {
        // Given
        let route: TubeServiceAPIRoute = .deleteDevice(deviceId: "device-abc")

        // When
        let request = try route.toURLRequest(relativeTo: baseURL, apiKey: "test-key")

        // Then
        #expect(request.url?.absoluteString == "https://foo.com/v1/notification-devices/device-abc")
        #expect(request.httpMethod == "DELETE")
    }

    @Test
    func disableDeviceEndpoint() throws {
        // Given
        let route: TubeServiceAPIRoute = .disableDevice(deviceId: "device-abc")

        // When
        let request = try route.toURLRequest(relativeTo: baseURL, apiKey: "test-key")

        // Then
        #expect(request.url?.absoluteString == "https://foo.com/v1/notification-devices/device-abc/disable")
        #expect(request.httpMethod == "POST")
    }

    @Test
    func fetchPreferencesEndpoint() throws {
        // Given
        let route: TubeServiceAPIRoute = .fetchPreferences(deviceId: "device-abc")

        // When
        let request = try route.toURLRequest(relativeTo: baseURL, apiKey: "test-key")

        // Then
        #expect(request.url?.absoluteString == "https://foo.com/v1/notification-devices/device-abc/preferences")
        #expect(request.httpMethod == "GET")
    }

    @Test
    func updatePreferencesEndpoint() throws {
        // Given
        let route: TubeServiceAPIRoute = .updatePreferences(deviceId: "device-abc", body: Data())

        // When
        let request = try route.toURLRequest(relativeTo: baseURL, apiKey: "test-key")

        // Then
        #expect(request.url?.absoluteString == "https://foo.com/v1/notification-devices/device-abc/preferences")
        #expect(request.httpMethod == "PUT")
        #expect(request.value(forHTTPHeaderField: "Content-Type") == "application/json")
    }
}


// MARK: - Private helpers

private extension TubeServiceAPIRouteTests {

    private func dayMonthYear(_ day: Int, _ month: Int, _ year: Int, hour: Int, in timeZone: TimeZone) -> Date {
        let calendar = Calendar.iso8601(in: timeZone)
        let dateComponents = DateComponents(
            calendar: calendar,
            timeZone: calendar.timeZone,
            year: year,
            month: month,
            day: day,
            hour: hour
        )
        return calendar.date(from: dateComponents)!
    }
}
