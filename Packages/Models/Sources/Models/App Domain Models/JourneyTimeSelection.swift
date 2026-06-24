import Foundation

public struct JourneyTimeSelection: Hashable, Sendable {

    public enum Option: CaseIterable, Sendable {
        case leaveNow, leaveAt, arriveBy
    }

    public var option: Option
    public var date: Date

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
