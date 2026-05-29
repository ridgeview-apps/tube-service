import Foundation
import Models

// MARK: - Journey API models

// swiftlint:disable identifier_name
public struct JourneyRequestParams: Sendable {
    public enum JourneyLocation: Sendable {
        case icsCode(String)
        case coordinate(LocationCoordinate)
    }

    public struct TimeOptionParam: Sendable {
        public enum OptionType: String, Sendable {
            case arriving = "Arriving"
            case departing = "Departing"
        }
        public let type: OptionType
        public let queryDate: String  // yyyyMMdd
        public let queryTime: String  // HHmm

        private static let dateFormat = "yyyyMMdd"
        private static let timeFormat = "HHmm"

        public static func arriving(at date: Date) -> Self {
            .arriving(
                queryDate: date.toAPIDateParam(dateFormat: dateFormat),
                queryTime: date.toAPIDateParam(dateFormat: timeFormat)
            )
        }
        
        public static func arriving(queryDate: String, queryTime: String) -> Self {
            .init(type: .arriving, queryDate: queryDate, queryTime: queryTime)
        }
        
        public static func departing(at date: Date) -> Self {
            .departing(
                queryDate: date.toAPIDateParam(dateFormat: dateFormat),
                queryTime: date.toAPIDateParam(dateFormat: timeFormat)
            )
        }
        
        public static func departing(queryDate: String, queryTime: String) -> Self {
            .init(type: .departing, queryDate: queryDate, queryTime: queryTime)
        }

    }

    public let from: JourneyLocation
    public let to: JourneyLocation
    public let via: JourneyLocation?
    public let modeIDs: Set<ModeID>
    public let timeOption: TimeOptionParam?
    public let routeBetweenEntrances: Bool

    public init(
        from: JourneyLocation,
        to: JourneyLocation,
        via: JourneyLocation?,
        modeIDs: Set<ModeID>,
        timeOption: TimeOptionParam?,
        routeBetweenEntrances: Bool = false
    ) {
        self.from = from
        self.to = to
        self.via = via
        self.modeIDs = modeIDs
        self.timeOption = timeOption
        self.routeBetweenEntrances = routeBetweenEntrances
    }
}
// swiftlint:enable identifier_name

extension JourneyRequestParams.TimeOptionParam {

    var toAPIQueryParams: [String: String] {
        [
            "timeIs": type.rawValue,
            "date": queryDate,
            "time": queryTime
        ]
    }
}

extension JourneyRequestParams.JourneyLocation {
    func toURLPathParam() -> String {
        switch self {
        case .icsCode(let value):
            return value
        case .coordinate(let location):
            return "\(location.lat),\(location.lon)"
        }
    }
}

// MARK: - Private helpers

extension Date {

    func toAPIDateParam(dateFormat: String = "yyyy-MM-dd") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        return formatter.string(from: self)
    }
}

extension Sequence where Element == TrainLineID {
    func toURLPathParam() -> String {
        self.map { $0.rawValue }.joined(separator: ",")
    }
}

extension Sequence where Element == ModeID {
    func toURLPathParam() -> String {
        self.map { $0.rawValue }.joined(separator: ",")
    }
}
