import Foundation

extension Date {
    public static func utc(
        year: Int = 1970,
        month: Int = 1,
        day: Int = 1,
        hour: Int = 0,
        minute: Int = 0,
        second: Int = 0,
        nanosecond: Int = 0
    ) -> Date? {
        iso8601(
            timeZone: .utc,
            year: year,
            month: month,
            day: day,
            hour: hour,
            minute: minute,
            second: second,
            nanosecond: nanosecond
        )
    }

    public static func iso8601(
        timeZone: TimeZone,
        year: Int = 1970,
        month: Int = 1,
        day: Int = 1,
        hour: Int = 0,
        minute: Int = 0,
        second: Int = 0,
        nanosecond: Int = 0
    ) -> Date? {
        var calendar = Calendar(identifier: .iso8601)
        calendar.timeZone = timeZone

        let components = DateComponents(
            calendar: calendar,
            timeZone: timeZone,
            year: year,
            month: month,
            day: day,
            hour: hour,
            minute: minute,
            second: second,
            nanosecond: nanosecond
        )

        guard let date = calendar.date(from: components) else {
            return nil
        }

        let resolvedComponents = calendar.dateComponents(
            [.year, .month, .day, .hour, .minute, .second, .nanosecond],
            from: date
        )

        guard resolvedComponents.year == year,
            resolvedComponents.month == month,
            resolvedComponents.day == day,
            resolvedComponents.hour == hour,
            resolvedComponents.minute == minute,
            resolvedComponents.second == second,
            resolvedComponents.nanosecond == nanosecond
        else {
            return nil
        }

        return date
    }
}

extension TimeZone {

    public static let utc = TimeZone(secondsFromGMT: 0)!

}
