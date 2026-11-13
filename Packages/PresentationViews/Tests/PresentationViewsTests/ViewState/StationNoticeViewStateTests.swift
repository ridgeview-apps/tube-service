import Foundation
import Models
import Testing

@testable import PresentationViews

struct StationNoticeViewStateTests {

    private static let london: Calendar = {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "Europe/London")!
        return calendar
    }()

    private static func date(_ iso8601: String) -> Date {
        try! Date(iso8601, strategy: .iso8601)
    }

    private static let twoPM = date("2026-11-12T14:00:00Z")

    private static let information = StationNotice(text: "Mini ramps are available.", kind: "Information")
    private static let currentClosure = StationNotice(text: "WEMBLEY PARK STATION: Westbound trains will not stop.", kind: "Part Closure")
    private static let closureThisEvening = StationNotice(
        text: "Exit only after the event.",
        kind: "Exit Only",
        startDate: date("2026-11-12T21:30:00Z"),
        endDate: date("2026-11-12T22:40:00Z")
    )
    private static let closureNextWeek = StationNotice(
        text: "The station will close.",
        kind: "Closure",
        startDate: date("2026-11-19T00:00:00Z")
    )

    // MARK: - Sheet sections

    private func sections(_ notices: [StationNotice]) -> StationNoticeSections {
        StationNoticeSections(notices: notices, stationName: "Wembley Park", now: Self.twoPM, calendar: Self.london)
    }

    @Test
    func currentNoticesSplitIntoClosuresAndNotices() {
        let sections = sections([Self.currentClosure, Self.information])

        #expect(sections.closures.map(\.text) == ["Westbound trains will not stop."])
        #expect(sections.closures.first?.id == Self.currentClosure.text)
        #expect(sections.notices.map(\.text) == ["Mini ramps are available."])
        #expect(sections.later.isEmpty)
    }

    @Test
    func upcomingNoticesAreLaterAndSoonestFirst() {
        let sections = sections([Self.closureNextWeek, Self.closureThisEvening])

        #expect(sections.closures.isEmpty)
        #expect(sections.later.map(\.text) == ["Exit only after the event.", "The station will close."])
    }

    @Test
    func laterTodayShowsItsEndOnlyWhenItEndsTheSameDay() {
        let endsAfterMidnight = StationNotice(
            text: "Exit only after the concert.",
            kind: "Exit Only",
            startDate: Self.date("2026-11-12T23:00:00Z"),
            endDate: Self.date("2026-11-13T01:29:00Z")
        )

        let later = sections([Self.closureThisEvening, endsAfterMidnight]).later

        #expect(
            later.map(\.startTime) == [
                .laterToday(start: Self.date("2026-11-12T21:30:00Z"), end: Self.date("2026-11-12T22:40:00Z")),
                .laterToday(start: Self.date("2026-11-12T23:00:00Z"), end: nil)
            ]
        )
    }

    @Test
    func laterDayShowsItsStartDate() {
        #expect(sections([Self.closureNextWeek]).later.first?.startTime == .laterDay(Self.date("2026-11-19T00:00:00Z")))
    }

    @Test
    func currentNoticesShowNoTime() {
        let rows = sections([Self.currentClosure, Self.information])

        #expect((rows.closures + rows.notices).allSatisfy { $0.startTime == nil })
    }

    @Test
    func tflKindsMapToLabels() {
        #expect(StationNoticeSections.Kind(tflKind: "Part Closure") == .partClosure)
        #expect(StationNoticeSections.Kind(tflKind: "Interchange Message") == .interchange)
        #expect(StationNoticeSections.Kind(tflKind: "Lift Works") == .other("Lift Works"))
    }

    // MARK: - Closure today

    @Test(arguments: [
        ([Self.currentClosure, Self.information], true),
        ([Self.closureThisEvening, Self.information], true),
        ([Self.closureNextWeek, Self.information], false),
        ([Self.information], false)
    ])
    func closureTodayCountsOnlyClosuresOnNowOrLaterToday(notices: [StationNotice], expected: Bool) {
        #expect(sections(notices).hasClosureToday == expected)
    }
}
