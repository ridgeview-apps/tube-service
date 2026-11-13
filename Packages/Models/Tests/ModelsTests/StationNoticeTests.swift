import Foundation
import Models
import Testing

struct StationNoticeTests {

    private static let london: Calendar = {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "Europe/London")!
        return calendar
    }()

    private static func date(_ iso8601: String) -> Date {
        try! Date(iso8601, strategy: .iso8601)
    }

    private static let twoPM = date("2026-11-12T14:00:00Z")

    // MARK: - Decoding

    @Test
    func decodesTflDates() throws {
        let json = """
            {
                "atcoCode": "940GZZLUWYP",
                "description": "Exit only after the event.",
                "type": "Exit Only",
                "fromDate": "2026-11-12T21:30:00Z",
                "toDate": "2026-11-12T22:40:00Z"
            }
            """
        let point = try JSONDecoder.tflModelDecoder.decode(DisruptedPoint.self, from: Data(json.utf8))

        #expect(point.fromDate == Self.date("2026-11-12T21:30:00Z"))
        #expect(point.toDate == Self.date("2026-11-12T22:40:00Z"))
    }

    @Test
    func missingOrMalformedDatesDecodeAsNil() throws {
        let json = """
            { "atcoCode": "940GZZLUWYP", "description": "Mini ramps are available.", "fromDate": "next Tuesday" }
            """
        let point = try JSONDecoder.tflModelDecoder.decode(DisruptedPoint.self, from: Data(json.utf8))

        #expect(point.fromDate == nil)
        #expect(point.toDate == nil)
    }

    // MARK: - Timing

    @Test
    func noticeWithoutDatesIsCurrent() {
        let notice = StationNotice(text: "Mini ramps are available.")
        #expect(notice.timing(at: Self.twoPM, calendar: Self.london) == .current)
    }

    @Test
    func noticeThatHasStartedIsCurrent() {
        let notice = StationNotice(
            text: "Lifts are closed.",
            startDate: Self.date("2026-11-01T00:00:00Z"),
            endDate: Self.date("2026-11-30T00:00:00Z")
        )
        #expect(notice.timing(at: Self.twoPM, calendar: Self.london) == .current)
    }

    @Test
    func noticeStartingThisEveningIsLaterToday() {
        let notice = StationNotice(
            text: "Exit only after the event.",
            startDate: Self.date("2026-11-12T21:30:00Z"),
            endDate: Self.date("2026-11-12T22:40:00Z")
        )
        #expect(notice.timing(at: Self.twoPM, calendar: Self.london) == .laterToday)
    }

    @Test
    func noticeStartingAfterMidnightIsLaterDay() {
        let notice = StationNotice(text: "The station will close.", startDate: Self.date("2026-11-13T00:30:00Z"))
        #expect(notice.timing(at: Self.date("2026-11-12T23:30:00Z"), calendar: Self.london) == .laterDay)
    }

    @Test
    func noticeWhoseEndHasPassedHasEnded() {
        let notice = StationNotice(
            text: "Exit only after the event.",
            startDate: Self.date("2026-11-12T11:30:00Z"),
            endDate: Self.date("2026-11-12T12:40:00Z")
        )
        #expect(notice.timing(at: Self.twoPM, calendar: Self.london) == .ended)
    }
}
