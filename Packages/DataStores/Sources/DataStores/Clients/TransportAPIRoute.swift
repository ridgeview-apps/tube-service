import Foundation
import Models

enum TransportAPIRoute {
    
    case getCurrentLineStatuses([ModeID])
    case getLineStatusesForDateRange([TrainLineID], DateInterval)
    case getArrivalPredictions(stationCode: String, [TrainLineID]) // Tube lines only
    case getArrivalDepartures(stationCode: String, [TrainLineID])  // Overground, Thameslink & Elizabeth line
    case getStationDisruptions([ModeID])
    case getJourneyItinerary(JourneyRequestParams)
    
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
            let fromDateParam = dateInterval.start.toAPIDateParam()
            let toDateParam = dateInterval.end.toAPIDateParam()
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
        case let .getJourneyItinerary(params):
            let fromParam = params.from.toURLPathParam()
            let toParam = params.to.toURLPathParam()
            
            let alternativeCycle = params.modeIDs.contains(.cycle) || params.modeIDs.contains(.cycleHire)
            
            var queryParams = [
                "routeBetweenEntrances": "\(params.routeBetweenEntrances)",
                "mode": params.modeIDs.toURLPathParam(),
                "alternativeCycle": "\(alternativeCycle)"
            ]
            
            if let via = params.via {
                queryParams["via"] = via.toURLPathParam()
            }
            
            if let timeOption = params.timeOption {
                queryParams.merge(timeOption.toQueryParams) { _, newKey in newKey }
            }
            
            return try makeURLComponents("/Journey/JourneyResults/\(fromParam)/to/\(toParam)",
                                         queryParams: queryParams)

        }
    }
}
