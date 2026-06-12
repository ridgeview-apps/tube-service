import Foundation
import Models

// MARK: - Data types

public protocol TflAPIClientType: Sendable {
    func fetchCurrentLineStatuses() async throws -> HTTPResponse<[Line]>
    func fetchLineStatuses(for dateInterval: DateInterval) async throws -> HTTPResponse<[Line]>
    func fetchArrivalPredictions(forLineGroup lineGroup: Station.LineGroup) async throws -> HTTPResponse<[ArrivalPrediction]>
    func fetchArrivalDepartures(forLineGroup lineGroup: Station.LineGroup) async throws -> HTTPResponse<[ArrivalDeparture]>
    func fetchStationDisruptions() async throws -> HTTPResponse<[DisruptedPoint]>
    func fetchJourneyResults(for params: JourneyRequestParams) async throws -> HTTPResponse<JourneyResults>
}


// MARK: - API Routes

enum TflAPIRoute {

    case getCurrentLineStatuses([ModeID])
    case getLineStatusesForDateRange([TrainLineID], DateInterval)
    case getArrivalPredictions(stationCode: String, [TrainLineID])  // Tube lines only
    case getArrivalDepartures(stationCode: String, [TrainLineID])  // Overground, Thameslink & Elizabeth line
    case getStationDisruptions([ModeID])
    case getJourneyResults(JourneyRequestParams)

    func toURL(relativeTo baseURL: URL, appKey: String) throws -> URL {
        var urlComponents = try self.toURLComponents(relativeTo: baseURL)

        let fixedQueryItems = [
            URLQueryItem(name: "app_key", value: appKey)
        ]

        let routeQueryItems = urlComponents.queryItems ?? []

        urlComponents.queryItems = fixedQueryItems + routeQueryItems

        guard let url = urlComponents.url else {
            throw HTTPError.invalidRequestURL
        }

        return url
    }

    func toURLRequest(relativeTo baseURL: URL, appKey: String) throws -> URLRequest {
        var request = URLRequest(url: try toURL(relativeTo: baseURL, appKey: appKey))
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }


    private func toURLComponents(relativeTo baseURL: URL) throws -> URLComponents {
        switch self {
        case let .getCurrentLineStatuses(modes):
            let modesParam = modes.toURLPathParam()
            return try .route(
                relativeTo: baseURL,
                pathComponents: ["Line", "Mode", modesParam, "Status"]
            )
        case let .getLineStatusesForDateRange(lineIDs, dateInterval):
            let lineIDsParam = lineIDs.toURLPathParam()
            let fromDateParam = dateInterval.start.toAPIDateParam()
            let toDateParam = dateInterval.end.toAPIDateParam()
            return try .route(
                relativeTo: baseURL,
                pathComponents: ["Line", lineIDsParam, "Status", fromDateParam, "to", toDateParam]
            )
        case let .getArrivalPredictions(stationCode, lineIDs):
            let lineIDsParam = lineIDs.toURLPathParam()
            return try .route(
                relativeTo: baseURL,
                pathComponents: ["Line", lineIDsParam, "Arrivals", stationCode]
            )
        case let .getArrivalDepartures(stationCode, lineIDs):
            let lineIDsParam = lineIDs.toURLPathParam()
            return try .route(
                relativeTo: baseURL,
                pathComponents: ["StopPoint", stationCode, "ArrivalDepartures"],
                queryItems: [URLQueryItem(name: "lineIds", value: lineIDsParam)]
            )
        case let .getStationDisruptions(modes):
            let modesParam = modes.toURLPathParam()
            return try .route(
                relativeTo: baseURL,
                pathComponents: ["StopPoint", "Mode", modesParam, "Disruption"]
            )
        case let .getJourneyResults(params):
            return try journeyURLComponents(for: params, relativeTo: baseURL)
        }
    }

    private func journeyURLComponents(
        for params: JourneyRequestParams,
        relativeTo baseURL: URL
    ) throws -> URLComponents {
        let fromParam = params.from.toURLPathParam()
        let toParam = params.to.toURLPathParam()
        let alternativeCycle = params.modeIDs.contains(.cycle) || params.modeIDs.contains(.cycleHire)

        var queryItems = [
            URLQueryItem(
                name: "routeBetweenEntrances",
                value: "\(params.routeBetweenEntrances)"
            ),
            URLQueryItem(name: "mode", value: params.modeIDs.toURLPathParam()),
            URLQueryItem(name: "alternativeCycle", value: "\(alternativeCycle)")
        ]

        if let via = params.via {
            queryItems.append(URLQueryItem(name: "via", value: via.toURLPathParam()))
        }

        if let timeOption = params.timeOption {
            queryItems.append(contentsOf: timeOption.toURLQueryItems)
        }

        return try .route(
            relativeTo: baseURL,
            pathComponents: ["Journey", "JourneyResults", fromParam, "to", toParam],
            queryItems: queryItems
        )
    }
}


// MARK: - TflAPIClient

public struct TflAPIClient: TflAPIClientType {

    private let baseURL: URL
    private let appKey: String
    private let urlSession: URLSession
    private let jsonDecoder: JSONDecoder


    // MARK: - Init

    public init(
        baseURL: URL,
        appKey: String,
        urlSession: URLSession = .shared,
        jsonDecoder: JSONDecoder = .defaultModelDecoder
    ) {
        self.baseURL = baseURL
        self.appKey = appKey
        self.urlSession = urlSession
        self.jsonDecoder = jsonDecoder
    }


    // MARK: - Data fetching

    public func fetchCurrentLineStatuses() async throws -> HTTPResponse<[Line]> {
        return try await fetchData(for: .getCurrentLineStatuses(ModeID.trains), mappedTo: [Line].self)
    }

    public func fetchLineStatuses(for dateInterval: DateInterval) async throws -> HTTPResponse<[Line]> {
        let lineIDS = TrainLineID.allCases.filter { $0 != .overground }
        return try await fetchData(
            for: .getLineStatusesForDateRange(lineIDS, dateInterval),
            mappedTo: [Line].self
        )
    }

    public func fetchArrivalPredictions(forLineGroup lineGroup: Station.LineGroup) async throws -> HTTPResponse<[ArrivalPrediction]> {
        return try await fetchData(
            for: .getArrivalPredictions(stationCode: lineGroup.atcoCode, lineGroup.lineIds),
            mappedTo: [ArrivalPrediction].self
        )
    }

    public func fetchArrivalDepartures(forLineGroup lineGroup: Station.LineGroup) async throws -> HTTPResponse<[ArrivalDeparture]> {
        return try await fetchData(
            for: .getArrivalDepartures(stationCode: lineGroup.atcoCode, lineGroup.lineIds),
            mappedTo: [ArrivalDeparture].self
        )
    }

    public func fetchStationDisruptions() async throws -> HTTPResponse<[DisruptedPoint]> {
        return try await fetchData(
            for: .getStationDisruptions(ModeID.trains),
            mappedTo: [DisruptedPoint].self
        )
    }

    public func fetchJourneyResults(for params: JourneyRequestParams) async throws -> HTTPResponse<JourneyResults> {
        return try await fetchData(
            for: .getJourneyResults(params),
            mappedTo: JourneyResults.self
        )
    }

    private func fetchData<T: Decodable>(for route: TflAPIRoute, mappedTo model: T.Type) async throws -> HTTPResponse<T> {
        let request = try route.toURLRequest(relativeTo: baseURL, appKey: appKey)
        return try await urlSession.data(for: request, decodedBy: jsonDecoder, as: model)
    }
}
