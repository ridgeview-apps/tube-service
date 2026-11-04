import DataStores
import Foundation
import PresentationViews
import Shared
import Testing

@testable import Tube_Service

struct LineStatusFilterOptionRequestTests {

    // Wednesday 18th October 2023, 10:00 in London.
    let now = Self.date(18, 10, 2023, hour: 10)

    @Test
    func today_returnsLive() {
        #expect(LineStatusFilterOption.today.toLineStatusRequest(for: now, now: now) == .live)
    }

    @Test
    func future_withToday_returnsLive() {
        let laterToday = Self.date(18, 10, 2023, hour: 23)

        #expect(LineStatusFilterOption.future.toLineStatusRequest(for: laterToday, now: now) == .live)
    }

    @Test
    func future_withFutureDate_returnsPlannedInterval() {
        let tomorrow = Self.date(19, 10, 2023)
        let dayAfter = Self.date(20, 10, 2023)

        let result = LineStatusFilterOption.future.toLineStatusRequest(for: tomorrow, now: now)

        #expect(result == .planned(.init(start: tomorrow, end: dayAfter)))
    }

    @Test
    func tomorrow_returnsPlannedStartingAtMidnightTomorrow() {
        let result = LineStatusFilterOption.tomorrow.toLineStatusRequest(for: now, now: now)

        #expect(result == .planned(.init(start: Self.date(19, 10, 2023), end: Self.date(20, 10, 2023))))
    }

    @Test
    func thisWeekend_returnsPlannedWeekendInterval() {
        let result = LineStatusFilterOption.thisWeekend.toLineStatusRequest(for: now, now: now)

        #expect(result == .planned(.init(start: Self.date(21, 10, 2023), end: Self.date(23, 10, 2023))))
    }

    @Test
    func thisWeekend_ignoresPassedDate_andAnchorsOnToday() {
        let nextMonth = Self.date(18, 11, 2023)

        let result = LineStatusFilterOption.thisWeekend.toLineStatusRequest(for: nextMonth, now: now)

        #expect(result == .planned(.init(start: Self.date(21, 10, 2023), end: Self.date(23, 10, 2023))))
    }

    @Test
    func thisWeekend_withSaturdayFilter_returnsSaturdayOnly() {
        let result = LineStatusFilterOption.thisWeekend.toLineStatusRequest(
            for: now,
            weekendDayFilter: .saturday,
            now: now
        )

        #expect(result == .planned(.init(start: Self.date(21, 10, 2023), end: Self.date(22, 10, 2023))))
    }

    private static func date(_ day: Int, _ month: Int, _ year: Int, hour: Int = 0) -> Date {
        let components = DateComponents(
            calendar: .london,
            timeZone: .london,
            year: year,
            month: month,
            day: day,
            hour: hour
        )
        return Calendar.london.date(from: components)!
    }
}
