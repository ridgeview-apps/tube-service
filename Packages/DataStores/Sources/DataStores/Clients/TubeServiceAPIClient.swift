import Foundation
import Models

// MARK: - Data types

public protocol TubeServiceAPIClientType: Sendable {
    func fetchDailyLineTimeline(lineID: TrainLineID, date: Date?) async throws -> HTTPResponse<DailyLineTimeline>
    func fetchDailyLineDisruptionSummary(date: Date?) async throws -> HTTPResponse<DailyDisruptionSummary>
}


// MARK: - API Routes

enum TubeServiceAPIRoute {

    case dailyLineTimeline(lineID: TrainLineID, date: Date?)
    case dailyLineDisruptionSummary(date: Date?)

    func toURL(relativeTo baseURL: URL) throws -> URL {
        let urlComponents = try self.toURLComponents(relativeTo: baseURL)

        guard let url = urlComponents.url else {
            throw HTTPError.invalidRequestURL
        }

        return url
    }


    func toURLRequest(relativeTo baseURL: URL, apiKey: String) throws -> URLRequest {
        var request = URLRequest(url: try toURL(relativeTo: baseURL))
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(apiKey, forHTTPHeaderField: "X-API-KEY")
        return request
    }


    private func toURLComponents(relativeTo baseURL: URL) throws -> URLComponents {
        let pathComponents: [String]
        var queryItems = [URLQueryItem]()

        switch self {
        case let .dailyLineTimeline(lineID, date):
            pathComponents = ["v1", "line-status", "timeline"]
            queryItems.append(URLQueryItem(name: "line_id", value: lineID.rawValue))
            if let date {
                queryItems.append(URLQueryItem(name: "date", value: date.toAPIDateParam()))
            }
        case let .dailyLineDisruptionSummary(date):
            pathComponents = ["v1", "line-status", "disruption-summary"]
            if let date {
                queryItems.append(URLQueryItem(name: "date", value: date.toAPIDateParam()))
            }
        }

        var components = try URLComponents.route(
            relativeTo: baseURL,
            pathComponents: pathComponents
        )
        components.queryItems = queryItems.isEmpty ? nil : queryItems
        return components
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

    public func fetchDailyLineTimeline(lineID: TrainLineID, date: Date?) async throws -> HTTPResponse<DailyLineTimeline> {
        try await fetchData(
            for: .dailyLineTimeline(lineID: lineID, date: date),
            mappedTo: DailyLineTimeline.self
        )
    }

    public func fetchDailyLineDisruptionSummary(date: Date?) async throws -> HTTPResponse<DailyDisruptionSummary> {
        try await fetchData(
            for: .dailyLineDisruptionSummary(date: date),
            mappedTo: DailyDisruptionSummary.self
        )
    }

    private func fetchData<T: Decodable>(for route: TubeServiceAPIRoute, mappedTo model: T.Type) async throws -> HTTPResponse<T> {
        let request = try route.toURLRequest(relativeTo: baseURL, apiKey: apiKey)
        return try await urlSession.data(for: request, decodedBy: jsonDecoder, as: model)
    }
}
