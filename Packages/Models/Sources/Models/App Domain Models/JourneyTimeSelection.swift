import Foundation

public struct JourneyTimeSelection: Hashable, Sendable {

    public enum Option: CaseIterable, Sendable {
        case leaveNow, leaveAt, arriveBy
    }

    public var option: Option
    /// For `.leaveNow`, `date` isn't sent with the request (TfL plans from the current time); it's where the date
    /// picker starts if the user switches to a later time.
    public var date: Date

    public init(option: Option, date: Date) {
        self.option = option
        self.date = date
    }

    public static func leaveNow() -> JourneyTimeSelection {
        .init(option: .leaveNow, date: .now)
    }

    public static func leaveAt(_ date: Date) -> JourneyTimeSelection {
        .init(option: .leaveAt, date: date)
    }

    public static func arriveBy(_ date: Date) -> JourneyTimeSelection {
        .init(option: .arriveBy, date: date)
    }
}
