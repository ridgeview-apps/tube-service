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

    private func summary(_ notices: [StationNotice]) -> StationNoticesSummary {
        StationNoticesSummary(notices: notices, stationName: "Wembley Park", now: Self.twoPM, calendar: Self.london)
    }

    @Test
    func currentClosureIsHighlightedAndPreviewedWithoutStationName() {
        let summary = summary([Self.currentClosure, Self.information])

        #expect(summary.count == 2)
        #expect(summary.hasCurrentClosure)
        #expect(summary.closurePreview == .init(text: "Westbound trains will not stop.", startDate: nil))
    }

    @Test
    func closureLaterTodayIsCountedAndPreviewedWithItsStartButNotHighlighted() {
        let summary = summary([Self.closureThisEvening, Self.information])

        #expect(summary.count == 2)
        #expect(!summary.hasCurrentClosure)
        #expect(summary.closurePreview == .init(text: "Exit only after the event.", startDate: Self.closureThisEvening.startDate))
    }

    @Test
    func currentClosureIsPreviewedBeforeOneLaterToday() {
        let summary = summary([Self.closureThisEvening, Self.currentClosure])

        #expect(summary.closurePreview?.startDate == nil)
    }

    @Test
    func noticeStartingOnALaterDayIsLeftToTheSheet() {
        let summary = summary([Self.closureNextWeek, Self.information])

        #expect(summary.count == 1)
        #expect(!summary.hasCurrentClosure)
        #expect(summary.closurePreview == nil)
    }
}
