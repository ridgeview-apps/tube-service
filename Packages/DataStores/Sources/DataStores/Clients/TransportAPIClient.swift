import Foundation
import Models

// MARK: - Data types

public protocol TransportAPIClientType: Sendable {
    func fetchCurrentLineStatuses() async throws -> HTTPResponse<[Line]>
    func fetchLineStatuses(for dateInterval: DateInterval) async throws -> HTTPResponse<[Line]>
    func fetchArrivalPredictions(forLineGroup lineGroup: Station.LineGroup) async throws -> HTTPResponse<[ArrivalPrediction]>
    func fetchArrivalDepartures(forLineGroup lineGroup: Station.LineGroup) async throws -> HTTPResponse<[ArrivalDeparture]>
    func fetchStationDisruptions() async throws -> HTTPResponse<[DisruptedPoint]>
    func fetchJourneyItinerary(for params: JourneyRequestParams) async throws -> HTTPResponse<JourneyItinerary>
}


// MARK: - API Routes

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
            throw HTTPError.invalidRequestURL
        }
        
        return url
    }
    
    
    private func toURLComponents() throws -> URLComponents {
        switch self {
        case let .getCurrentLineStatuses(modes):
            let modesParam = modes.toURLPathParam()
            return try .fromPath("/Line/Mode/\(modesParam)/Status")
        case let .getLineStatusesForDateRange(lineIDs, dateInterval):
            let lineIDsParam = lineIDs.toURLPathParam()
            let fromDateParam = dateInterval.start.toAPIDateParam()
            let toDateParam = dateInterval.end.toAPIDateParam()
            return try .fromPath("/Line/\(lineIDsParam)/Status/\(fromDateParam)/to/\(toDateParam)")
        case let .getArrivalPredictions(stationCode, lineIDs):
            let lineIDsParam = lineIDs.toURLPathParam()
            return try .fromPath("/Line/\(lineIDsParam)/Arrivals/\(stationCode)")
        case let .getArrivalDepartures(stationCode, lineIDs):
            let lineIDsParam = lineIDs.toURLPathParam()
            return try .fromPath("/StopPoint/\(stationCode)/ArrivalDepartures",
                                 queryParams: ["lineIds": lineIDsParam])
        case let .getStationDisruptions(modes):
            let modesParam = modes.toURLPathParam()
            return try .fromPath("/StopPoint/Mode/\(modesParam)/Disruption")
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
            
            return try .fromPath("/Journey/JourneyResults/\(fromParam)/to/\(toParam)",
                                 queryParams: queryParams)

        }
    }
}


// MARK: - TransportAPIClient

public struct TransportAPIClient: TransportAPIClientType {
    
    public let baseURL: URL
    public let appID: String
    public let appKey: String
    public let urlSession: URLSession
    public let jsonDecoder: JSONDecoder
    
    
    // MARK: - Init
    
    public init(baseURL: URL,
                appID: String,
                appKey: String,
                urlSession: URLSession = .shared,
                jsonDecoder: JSONDecoder = .defaultModelDecoder) {
        self.baseURL = baseURL
        self.appID = appID
        self.appKey = appKey
        self.urlSession = urlSession
        self.jsonDecoder = jsonDecoder
    }
    
    
    // MARK: - Data fetching
    
    public func fetchCurrentLineStatuses() async throws -> HTTPResponse<[Line]> {
        return try await fetchData(for: .getCurrentLineStatuses(ModeID.trains), mappedTo: [Line].self)
    }
    
    public func fetchLineStatuses(for dateInterval: DateInterval) async throws -> HTTPResponse<[Line]> {
        return try await fetchData(for: .getLineStatusesForDateRange(TrainLineID.allCases, dateInterval),
                                   mappedTo: [Line].self)
    }
    
    public func fetchArrivalPredictions(forLineGroup lineGroup: Station.LineGroup) async throws -> HTTPResponse<[ArrivalPrediction]> {
        return try await fetchData(for: .getArrivalPredictions(stationCode: lineGroup.atcoCode, lineGroup.lineIds),
                                   mappedTo: [ArrivalPrediction].self)
    }
    
    public func fetchArrivalDepartures(forLineGroup lineGroup: Station.LineGroup) async throws -> HTTPResponse<[ArrivalDeparture]> {
        return try await fetchData(for: .getArrivalDepartures(stationCode: lineGroup.atcoCode, lineGroup.lineIds),
                                   mappedTo: [ArrivalDeparture].self)
    }
    
    public func fetchStationDisruptions() async throws -> HTTPResponse<[DisruptedPoint]> {
        return try await fetchData(for: .getStationDisruptions(ModeID.trains),
                                   mappedTo: [DisruptedPoint].self)
    }
    
    public func fetchJourneyItinerary(for params: JourneyRequestParams) async throws -> HTTPResponse<JourneyItinerary> {
        return try await fetchData(for: .getJourneyItinerary(params),
                                   mappedTo: JourneyItinerary.self)
    }
    
    private func fetchData<T: Decodable>(for route: TransportAPIRoute, mappedTo model: T.Type) async throws -> HTTPResponse<T> {
        let url = try route.toURL(relativeTo: baseURL, appID: appID, appKey: appKey)
        return try await urlSession.get(url: url, decodedBy: jsonDecoder, as: model)
    }
}
