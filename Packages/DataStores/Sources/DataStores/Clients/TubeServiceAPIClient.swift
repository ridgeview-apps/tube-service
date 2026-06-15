import Foundation
import Models

// MARK: - Data types

public protocol TubeServiceAPIClientType: Sendable {
    func fetchDailyLineTimeline(lineID: TrainLineID, operationalDate: Date?) async throws -> HTTPResponse<DailyLineTimeline>
    func fetchDailyLineDisruptionSummary(operationalDate: Date?) async throws -> HTTPResponse<DailyDisruptionSummary>
}


// MARK: - API Routes

enum TubeServiceAPIRoute {

    case dailyLineTimeline(lineID: TrainLineID, operationalDate: Date?)
    case dailyLineDisruptionSummary(operationalDate: Date?)

    func toURL(relativeTo baseURL: URL) throws -> URL {
        guard let url = try toURLComponents(relativeTo: baseURL).url else {
            throw HTTPError.invalidRequestURL
        }
        return url
    }

    func toURLRequest(relativeTo baseURL: URL, apiKey: String) throws -> URLRequest {
        var request = URLRequest(url: try toURL(relativeTo: baseURL))
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(apiKey, forHTTPHeaderField: "X-API-Key")
        return request
    }


    private var pathComponents: [String] {
        switch self {
        case .dailyLineTimeline:
            return ["v1", "line-status", "timeline"]
        case .dailyLineDisruptionSummary:
            return ["v1", "line-status", "disruption-summary"]
        }
    }

    private var queryItems: [URLQueryItem] {
        switch self {
        case let .dailyLineTimeline(lineID, operationalDate):
            var items = [URLQueryItem(name: "line_id", value: lineID.rawValue)]
            if let operationalDate {
                items.append(URLQueryItem(name: "date", value: operationalDate.toOperationalDateParam()))
            }
            return items
        case let .dailyLineDisruptionSummary(operationalDate):
            guard let operationalDate else { return [] }
            return [URLQueryItem(name: "date", value: operationalDate.toOperationalDateParam())]
        }
    }

    private func toURLComponents(relativeTo baseURL: URL) throws -> URLComponents {
        try .route(relativeTo: baseURL, pathComponents: pathComponents, queryItems: queryItems)
    }
}


// MARK: - TubeServiceAPIClient

public struct TubeServiceAPIClient: TubeServiceAPIClientType {

    private let baseURL: URL
    private let apiKey: String
    private let urlSession: URLSession
    private let jsonDecoder: JSONDecoder


    // MARK: - Init

    public init(
        baseURL: URL,
        apiKey: String,
        urlSession: URLSession = .shared,
        jsonDecoder: JSONDecoder = .tubeServiceModelDecoder
    ) {
        self.baseURL = baseURL
        self.apiKey = apiKey
        self.urlSession = urlSession
        self.jsonDecoder = jsonDecoder
    }


    // MARK: - Data fetching

    public func fetchDailyLineTimeline(lineID: TrainLineID, operationalDate: Date?) async throws -> HTTPResponse<DailyLineTimeline> {
        try await fetchData(
            for: .dailyLineTimeline(lineID: lineID, operationalDate: operationalDate),
            mappedTo: DailyLineTimeline.self
        )
    }

    public func fetchDailyLineDisruptionSummary(operationalDate: Date?) async throws -> HTTPResponse<DailyDisruptionSummary> {
        try await fetchData(
            for: .dailyLineDisruptionSummary(operationalDate: operationalDate),
            mappedTo: DailyDisruptionSummary.self
        )
    }

    private func fetchData<T: Decodable>(for route: TubeServiceAPIRoute, mappedTo model: T.Type) async throws -> HTTPResponse<T> {
        let request = try route.toURLRequest(relativeTo: baseURL, apiKey: apiKey)
        return try await urlSession.data(for: request, decodedBy: jsonDecoder, as: model)
    }
}
