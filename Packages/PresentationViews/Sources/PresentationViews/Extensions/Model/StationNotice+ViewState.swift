import Foundation
import Models

/// What the Station screen's closure banner shows. Closures starting on a later day are left to the notices sheet, so
/// one weeks away doesn't take the banner every day until then.
struct StationNoticesSummary: Equatable {

    struct ClosurePreview: Equatable {
        let text: String
        /// Set while the closure hasn't started yet.
        let startDate: Date?
    }

    let closurePreview: ClosurePreview?

    /// - Parameter notices: closures first, as `StationsDataStore` sorts them.
    init(notices: [StationNotice], stationName: String, now: Date, calendar: Calendar = .current) {
        let timedNotices = notices.map { (notice: $0, timing: $0.timing(at: now, calendar: calendar)) }
        let todaysNotices = timedNotices.filter { $0.timing == .current || $0.timing == .laterToday }

        // A current closure matters more than one starting later today
        let previewed =
            todaysNotices.first { $0.notice.isClosure && $0.timing == .current }
            ?? todaysNotices.first { $0.notice.isClosure }
        closurePreview = previewed.map {
            ClosurePreview(
                text: $0.notice.text.removingStationNamePrefix(stationName),
                startDate: $0.timing == .laterToday ? $0.notice.startDate : nil
            )
        }
    }
}

/// The notices sheet's sections. Closures and notices keep `StationsDataStore`'s order; later ones come soonest first.
struct StationNoticeSections: Equatable {

    struct Row: Identifiable, Equatable {
        /// TfL's text as published, which identifies the notice.
        let id: String
        /// Without TfL's station name prefix.
        let text: String
        let kind: Kind?
        let isClosure: Bool
        let startTime: StartTime?
    }

    enum Kind: Equatable {
        case closure
        case partClosure
        case exitOnly
        case information
        case interchange
        /// A kind TfL may add later, shown as published.
        case other(String)
    }

    /// Only upcoming notices show a time. TfL's end dates are mostly the end of the service day (00:29 or 01:29) and
    /// its rolling notices are republished daily, so "Until …" would mislead; the text states the real period anyway.
    enum StartTime: Equatable {
        case laterToday(start: Date, end: Date?)
        case laterDay(Date)
    }

    let closures: [Row]
    let notices: [Row]
    let later: [Row]

    var isEmpty: Bool {
        closures.isEmpty && notices.isEmpty && later.isEmpty
    }

    init(notices: [StationNotice], stationName: String, now: Date, calendar: Calendar = .current) {
        var closures: [Row] = []
        var current: [Row] = []
        var later: [(row: Row, start: Date)] = []

        for notice in notices {
            let timing = notice.timing(at: now, calendar: calendar)
            func row(startTime: StartTime?) -> Row {
                Row(
                    id: notice.text,
                    text: notice.text.removingStationNamePrefix(stationName),
                    kind: notice.kind.map(Kind.init(tflKind:)),
                    isClosure: notice.isClosure,
                    startTime: startTime
                )
            }

            switch timing {
            case .current:
                if notice.isClosure {
                    closures.append(row(startTime: nil))
                } else {
                    current.append(row(startTime: nil))
                }
            case .laterToday:
                guard let start = notice.startDate else { continue }
                let sameDayEnd = notice.endDate.flatMap { calendar.isDate($0, inSameDayAs: start) ? $0 : nil }
                later.append((row(startTime: .laterToday(start: start, end: sameDayEnd)), start))
            case .laterDay:
                guard let start = notice.startDate else { continue }
                later.append((row(startTime: .laterDay(start)), start))
            case .ended:
                continue
            }
        }

        self.closures = closures
        self.notices = current
        self.later = later.sorted { $0.start < $1.start }.map(\.row)
    }
}

extension StationNoticeSections.Kind {
    init(tflKind: String) {
        self =
            switch tflKind.lowercased() {
            case "closure": .closure
            case "part closure": .partClosure
            case "exit only": .exitOnly
            case "information": .information
            case "interchange message": .interchange
            default: .other(tflKind)
            }
    }
}
