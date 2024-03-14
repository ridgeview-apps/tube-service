import Foundation
import Models

// swiftlint:disable identifier_name
public struct JourneyItineraryParams {
    public enum JourneyLocation {
        case icsCode(String)
        case coordinate(Location)
    }
    public enum TimeOption {
        case arriving(Date)
        case Departing(Date)
    }
    
    public let from: JourneyLocation
    public let to: JourneyLocation
    public let routeBetweenEntrances: Bool
    public let modeIDs: [ModeID]
    public let timeOption: TimeOption?
    
    public init(from: JourneyLocation,
                to: JourneyLocation,
                modeIDs: [ModeID] = ModeID.allJourneyPlannerModeIDs,
                routeBetweenEntrances: Bool = true,
                timeOption: TimeOption? = nil) {
        self.from = from
        self.to = to
        self.modeIDs = modeIDs
        self.routeBetweenEntrances = routeBetweenEntrances
        self.timeOption = timeOption
    }
}
// swiftlint:enable identifier_name

extension JourneyItineraryParams.TimeOption {
    
    var toQueryParams: [String: String] {
        switch self {
        case .arriving(let date):
            [
                "timeIs": "Arriving",
                "date": date.toAPIDateParam(dateFormat: "yyyyMMdd"),
                "time": date.toAPIDateParam(dateFormat: "HHmm")
            ]
        case .Departing(let date):
            [
                "timeIs": "Departing",
                "date": date.toAPIDateParam(dateFormat: "yyyyMMdd"),
                "time": date.toAPIDateParam(dateFormat: "HHmm")
            ]
        }
    }
}

extension JourneyItineraryParams.JourneyLocation {
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
        formatter.timeZone = .london
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
