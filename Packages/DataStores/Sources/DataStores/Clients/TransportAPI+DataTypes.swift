import Foundation
import Models

// MARK: - Network API models

public struct APIResponseErrorModel: Decodable {
    public let message: String?
}

public struct APIResponse<T: Decodable> {
    public let httpStatusCode: Int
    public let decodedModel: T
        
    public init(httpStatusCode: Int,
                decodedModel: T) {
        self.decodedModel = decodedModel
        self.httpStatusCode = httpStatusCode
    }
}

// MARK: - Journey API models

// swiftlint:disable identifier_name
public struct JourneyRequestParams {
    public enum JourneyLocation {
        case icsCode(String)
        case coordinate(LocationCoordinate)
    }
    
    public enum TimeOption {
        case arriving(Date)
        case departing(Date)
    }
    
    public let from: JourneyLocation
    public let to: JourneyLocation
    public let via: JourneyLocation?
    public let modeIDs: Set<ModeID>
    public let timeOption: TimeOption?
    public let routeBetweenEntrances: Bool

    
    public init(from: JourneyLocation,
                to: JourneyLocation,
                via: JourneyLocation?,
                modeIDs: Set<ModeID>,
                timeOption: TimeOption?,
                routeBetweenEntrances: Bool = true) {
        self.from = from
        self.to = to
        self.via = via
        self.modeIDs = modeIDs
        self.timeOption = timeOption
        self.routeBetweenEntrances = routeBetweenEntrances
    }
}
// swiftlint:enable identifier_name

extension JourneyRequestParams.TimeOption {
    
    var toQueryParams: [String: String] {
        switch self {
        case .arriving(let date):
            [
                "timeIs": "Arriving",
                "date": date.toAPIDateParam(dateFormat: "yyyyMMdd"),
                "time": date.toAPIDateParam(dateFormat: "HHmm")
            ]
        case .departing(let date):
            [
                "timeIs": "Departing",
                "date": date.toAPIDateParam(dateFormat: "yyyyMMdd"),
                "time": date.toAPIDateParam(dateFormat: "HHmm")
            ]
        }
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
