import Foundation
import Models
import Testing

@testable import DataStores

struct TubeServiceAPIRouteTests {

    private let baseURL = URL(string: "https://foo.com/")!

    @Test
    func dailyLineTimelineEndpointWithoutDate() throws {
        // Given
        let route: TubeServiceAPIRoute = .dailyLineTimeline(lineID: .victoria, date: nil)

        // When
        let url = try route.toURL(relativeTo: baseURL)

        // Then
        let expectedValue = "https://foo.com/v1/line-status/timeline?line_id=victoria"
        #expect(url.absoluteString == expectedValue)
    }

    @Test
    func dailyLineTimelineEndpointWithDate() throws {
        // Given
        let date = dayMonthYear(11, 6, 2026, in: .london)
        let route: TubeServiceAPIRoute = .dailyLineTimeline(lineID: .hammersmithAndCity, date: date)

        // When
        let url = try route.toURL(relativeTo: baseURL)

        // Then
        let expectedValue = "https://foo.com/v1/line-status/timeline?line_id=hammersmith-city&date=2026-06-11"
        #expect(url.absoluteString == expectedValue)
    }

    @Test
    func dailyLineDisruptionSummaryEndpointWithoutDate() throws {
        // Given
        let route: TubeServiceAPIRoute = .dailyLineDisruptionSummary(date: nil)

        // When
        let url = try route.toURL(relativeTo: baseURL)

        // Then
        let expectedValue = "https://foo.com/v1/line-status/disruption-summary"
        #expect(url.absoluteString == expectedValue)
    }

    @Test
    func dailyLineDisruptionSummaryEndpointWithDate() throws {
        // Given
        let date = dayMonthYear(11, 6, 2026, in: .london)
        let route: TubeServiceAPIRoute = .dailyLineDisruptionSummary(date: date)

        // When
        let url = try route.toURL(relativeTo: baseURL)

        // Then
        let expectedValue = "https://foo.com/v1/line-status/disruption-summary?date=2026-06-11"
        #expect(url.absoluteString == expectedValue)
    }
}


// MARK: - Private helpers

private extension TubeServiceAPIRouteTests {

    private func dayMonthYear(_ day: Int, _ month: Int, _ year: Int, in timeZone: TimeZone) -> Date {
        let calendar = Calendar.iso8601(in: timeZone)
        let dateComponents = DateComponents(
            calendar: calendar,
            timeZone: calendar.timeZone,
            year: year,
            month: month,
            day: day
        )
        return calendar.date(from: dateComponents)!
    }
}
