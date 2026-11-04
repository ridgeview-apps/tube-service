import Foundation
import Testing

@testable import Shared

struct RelativeDateFormatterTests {

    // Deliberately years from the real date, so the system clock can't be what makes these pass.
    let now = Self.date(18, 10, 2023, hour: 10, minute: 30)

    let formatter = RelativeDateFormatter(
        dateStyle: .short,
        timeStyle: .short,
        context: .middleOfSentence,
        locale: Locale(identifier: "en_GB"),
        timeZone: .london
    )

    @Test
    func sameDay_isToday() {
        #expect(formatter.string(from: Self.date(18, 10, 2023, hour: 8, minute: 5), relativeTo: now) == "today, 08:05")
    }

    @Test
    func previousDay_isYesterday() {
        #expect(formatter.string(from: Self.date(17, 10, 2023, hour: 23, minute: 59), relativeTo: now) == "yesterday, 23:59")
    }

    @Test
    func nextDay_isTomorrow() {
        #expect(formatter.string(from: Self.date(19, 10, 2023, hour: 0, minute: 0), relativeTo: now) == "tomorrow, 00:00")
    }

    @Test
    func olderDate_isAbsolute() {
        #expect(formatter.string(from: Self.date(15, 10, 2023, hour: 9, minute: 0), relativeTo: now) == "15/10/2023, 09:00")
    }

    private static func date(_ day: Int, _ month: Int, _ year: Int, hour: Int, minute: Int) -> Date {
        let calendar = Calendar.iso8601(in: .london)
        let components = DateComponents(
            calendar: calendar,
            timeZone: calendar.timeZone,
            year: year,
            month: month,
            day: day,
            hour: hour,
            minute: minute
        )
        return calendar.date(from: components)!
    }
}
