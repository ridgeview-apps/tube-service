import Foundation
import Models

enum TransportAPIRoute {
    
    case getCurrentLineStatuses([TransportMode])
    case getLineStatusesForDateRange([LineID], DateInterval)
    case getArrivalPredictions(stationCode: String, [LineID]) // Tube lines only
    case getArrivalDepartures(stationCode: String, [LineID])  // Overground, Thameslink & Elizabeth line
    case getStationDisruptions([TransportMode])
    
    func toURL(relativeTo baseURL: URL, appID: String, appKey: String) throws -> URL {
        var urlComponents = try self.toURLComponents()

        let fixedQueryItems = [
            URLQueryItem(name: "app_id", value: appID),
            URLQueryItem(name: "app_key", value: appKey)
        ]
        
        let routeQueryItems = urlComponents.queryItems ?? []
        
        urlComponents.queryItems = fixedQueryItems + routeQueryItems
        
        guard let url = urlComponents.url(relativeTo: baseURL) else {
            throw TransportAPIError.invalidRequestURL
        }
        
        return url
    }
    
    
    private func makeURLComponents(_ path: String, queryParams: [String: String] = [:]) throws -> URLComponents {
        let sanitizedPath = "\(path)".replacingOccurrences(of: "//", with: "/")
        guard var components = URLComponents(string: sanitizedPath) else {
            throw TransportAPIError.invalidRequestURL
        }
        components.queryItems = queryParams.map(URLQueryItem.init)
        return components
    }
    
    private func toURLComponents() throws -> URLComponents {
        switch self {
        case let .getCurrentLineStatuses(modes):
            let modesParam = modes.toURLPathParam()
            return try makeURLComponents("/Line/Mode/\(modesParam)/Status")
        case let .getLineStatusesForDateRange(lineIDs, dateInterval):
            let lineIDsParam = lineIDs.toURLPathParam()
            let fromDateParam = try dateInterval.start.toAPIYearMonthDayParam()
            let toDateParam = try dateInterval.end.toAPIYearMonthDayParam()
            return try makeURLComponents("/Line/\(lineIDsParam)/Status/\(fromDateParam)/to/\(toDateParam)")
        case let .getArrivalPredictions(stationCode, lineIDs):
            let lineIDsParam = lineIDs.toURLPathParam()
            return try makeURLComponents("/Line/\(lineIDsParam)/Arrivals/\(stationCode)")
        case let .getArrivalDepartures(stationCode, lineIDs):
            let lineIDsParam = lineIDs.toURLPathParam()
            return try makeURLComponents("/StopPoint/\(stationCode)/ArrivalDepartures",
                                     queryParams: ["lineIds": lineIDsParam])
        case let .getStationDisruptions(modes):
            let modesParam = modes.toURLPathParam()
            return try makeURLComponents("/StopPoint/Mode/\(modesParam)/Disruption")
        }
    }
}


// MARK: - Private helpers

private extension Sequence where Element == LineID {
    func toURLPathParam() -> String {
        self.map { $0.rawValue }.joined(separator: ",")
    }
}

private extension Sequence where Element == TransportMode {
    func toURLPathParam() -> String {
        self.map { $0.rawValue }.joined(separator: ",")
    }
}

private extension Date {
    func toAPIYearMonthDayParam() throws -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = .london
        return formatter.string(from: self)
    }
}
