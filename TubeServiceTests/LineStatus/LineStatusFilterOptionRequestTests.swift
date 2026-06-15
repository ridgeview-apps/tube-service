import DataStores
import Foundation
import PresentationViews
import Shared
import Testing

@testable import Tube_Service

struct LineStatusFilterOptionRequestTests {

    @Test
    func today_returnsLive() {
        #expect(LineStatusFilterOption.today.toLineStatusRequest() == .live)
    }

    @Test
    func future_withToday_returnsLive() {
        #expect(LineStatusFilterOption.future.toLineStatusRequest(for: .now) == .live)
    }

    @Test
    func future_withFutureDate_returnsPlannedInterval() throws {
        let tomorrow = try #require(Calendar.london.startOfTomorrow())
        let dayAfter = try #require(Calendar.london.startOfNextDay(after: tomorrow))

        let result = LineStatusFilterOption.future.toLineStatusRequest(for: tomorrow)

        #expect(result == .planned(.init(start: tomorrow, end: dayAfter)))
    }

    @Test
    func tomorrow_returnsPlannedStartingAtMidnightTomorrow() throws {
        let expectedStart = try #require(Calendar.london.startOfTomorrow())
        let expectedEnd = try #require(Calendar.london.startOfNextDay(after: expectedStart))

        let result = LineStatusFilterOption.tomorrow.toLineStatusRequest()

        #expect(result == .planned(.init(start: expectedStart, end: expectedEnd)))
    }

    @Test
    func thisWeekend_returnsPlannedWeekendInterval() throws {
        let expectedInterval = try #require(Calendar.london.thisOrNextWeekendDateInterval(for: .now))

        let result = LineStatusFilterOption.thisWeekend.toLineStatusRequest()

        #expect(result == .planned(expectedInterval))
    }
}
