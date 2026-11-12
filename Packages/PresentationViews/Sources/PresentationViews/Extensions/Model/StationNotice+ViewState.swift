import Foundation
import Models

/// What the Station screen's notices card shows. Notices starting on a later day are left to the notices sheet, so a
/// closure weeks away doesn't take the card every day until then.
struct StationNoticesSummary: Equatable {

    struct ClosurePreview: Equatable {
        let text: String
        /// Set while the closure hasn't started yet.
        let startDate: Date?
    }

    let count: Int
    let hasCurrentClosure: Bool
    let closurePreview: ClosurePreview?

    /// - Parameter notices: closures first, as `StationsDataStore` sorts them.
    init(notices: [StationNotice], stationName: String, now: Date, calendar: Calendar = .current) {
        let timedNotices = notices.map { (notice: $0, timing: $0.timing(at: now, calendar: calendar)) }
        let cardNotices = timedNotices.filter { $0.timing == .current || $0.timing == .laterToday }

        count = cardNotices.count
        hasCurrentClosure = cardNotices.contains { $0.notice.isClosure && $0.timing == .current }
        // A current closure matters more than one starting later today
        let previewed =
            cardNotices.first { $0.notice.isClosure && $0.timing == .current }
            ?? cardNotices.first { $0.notice.isClosure }
        closurePreview = previewed.map {
            ClosurePreview(
                text: $0.notice.text.removingStationNamePrefix(stationName),
                startDate: $0.timing == .laterToday ? $0.notice.startDate : nil
            )
        }
    }
}
