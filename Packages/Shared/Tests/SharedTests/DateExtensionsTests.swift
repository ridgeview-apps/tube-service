import Foundation
import Testing
@testable import Shared

struct DateExtensionsTests {

    @Test
    func utcDateUsesGMTTimeZone() throws {
        let date = try #require(Date.utc(year: 2024, month: 4, day: 15, hour: 10, minute: 30))
        let components = Calendar.iso8601(in: .utc).dateComponents(
            [.year, .month, .day, .hour, .minute],
            from: date
        )

        #expect(components.year == 2024)
        #expect(components.month == 4)
        #expect(components.day == 15)
        #expect(components.hour == 10)
        #expect(components.minute == 30)
    }

    @Test
    func iso8601DateReturnsNilForInvalidDateComponents() {
        let date = Date.iso8601(timeZone: .utc, year: 2024, month: 2, day: 31)

        #expect(date == nil)
    }

    @Test
    func iso8601DateReturnsNilForNonexistentLocalTime() {
        let date = Date.iso8601(
            timeZone: TimeZone(identifier: "Europe/London")!,
            year: 2024,
            month: 3,
            day: 31,
            hour: 1
        )

        #expect(date == nil)
    }
}
