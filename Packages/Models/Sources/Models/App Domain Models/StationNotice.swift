import Foundation

/// A TfL notice about a station, such as a closure, an exit only entrance or step-free access information.
public struct StationNotice: Hashable, Sendable {

    public enum Timing: Equatable, Sendable {
        case current
        case laterToday
        case laterDay
        case ended
    }

    /// TfL's description, as published. TfL gives notices no stable ID, so the text is what identifies one.
    public let text: String
    /// TfL's free-text kind of notice, e.g. "Part Closure", "Exit Only" or "Information".
    public let kind: String?
    public let category: DisruptionCategory?
    public let startDate: Date?
    public let endDate: Date?

    public init(
        text: String,
        kind: String? = nil,
        category: DisruptionCategory? = nil,
        startDate: Date? = nil,
        endDate: Date? = nil
    ) {
        self.text = text
        self.kind = kind
        self.category = category
        self.startDate = startDate
        self.endDate = endDate
    }

    /// Closures change how people use the station, e.g. trains not stopping or an exit only entrance.
    public var isClosure: Bool {
        guard let kind else { return false }
        return kind.localizedCaseInsensitiveContains("closure") || kind.localizedCaseInsensitiveCompare("Exit Only") == .orderedSame
    }

    /// TfL publishes notices before they start, e.g. an evening's exit only entrance is listed all day.
    /// A missing date leaves that end of the notice open.
    public func timing(at now: Date, calendar: Calendar = .current) -> Timing {
        if let endDate, endDate <= now {
            return .ended
        }
        if let startDate, startDate > now {
            return calendar.isDate(startDate, inSameDayAs: now) ? .laterToday : .laterDay
        }
        return .current
    }

    /// Closures come first, then by how current the notice is.
    /// TfL marks long-running notices (e.g. weeks of escalator works) as real-time too, so the category alone isn't enough.
    public var priority: Int {
        if isClosure { return 0 }
        return switch category {
        case .realTime, .statusAlert: 1
        case .crowding, .event: 2
        case .plannedWork: 3
        case .information, nil: 4
        }
    }
}

public extension StationNotice {
    init?(_ disruptedPoint: DisruptedPoint) {
        guard let text = disruptedPoint.description?.trimmingCharacters(in: .whitespacesAndNewlines), !text.isEmpty else {
            return nil
        }
        self.init(
            text: text,
            kind: disruptedPoint.type,
            category: disruptedPoint.appearance,
            startDate: disruptedPoint.fromDate,
            endDate: disruptedPoint.toDate
        )
    }
}
