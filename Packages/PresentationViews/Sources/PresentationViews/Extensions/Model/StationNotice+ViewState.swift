import Foundation
import Models

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

    /// A closure on now or later today, which turns the notices button's badge orange. One on a later day doesn't, so
    /// a closure weeks away doesn't take the badge every day until then.
    var hasClosureToday: Bool {
        !closures.isEmpty
            || later.contains { row in
                guard row.isClosure, case .laterToday = row.startTime else { return false }
                return true
            }
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
