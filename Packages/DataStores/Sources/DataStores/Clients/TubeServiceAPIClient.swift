import Foundation
import Models

// MARK: - Data types

public protocol TubeServiceAPIClientType: Sendable {
    func fetchDailyLineTimeline(lineID: TrainLineID, date: Date?) async throws -> HTTPResponse<DailyLineTimeline>
    func fetchDailyLineDisruptionSummary(date: Date?) async throws -> HTTPResponse<[LineDisruptionSummary]>
}


// MARK: - API Routes

enum TubeServiceAPIRoute {

    case getDailyLineTimeline(lineID: TrainLineID, date: Date?)
    case getDailyLineDisruptionSummary(date: Date?)

    func toURL(relativeTo baseURL: URL) throws -> URL {
        let urlComponents = try self.toURLComponents()

        guard let url = urlComponents.url(relativeTo: baseURL) else {
            throw HTTPError.invalidRequestURL
        }

        return url
    }

    func toURLRequest(relativeTo baseURL: URL) throws -> URLRequest {
        var request = URLRequest(url: try toURL(relativeTo: baseURL))
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }


    private func toURLComponents() throws -> URLComponents {
        let path: String
        var queryItems = [URLQueryItem]()

        switch self {
        case let .getDailyLineTimeline(lineID, date):
            path = "/v1/line-status/timeline"
            queryItems.append(URLQueryItem(name: "line_id", value: lineID.rawValue))
            if let date {
                queryItems.append(URLQueryItem(name: "date", value: date.toAPIDateParam()))
            }
        case let .getDailyLineDisruptionSummary(date):
            path = "/v1/line-status/disruption-summary"
            if let date {
                queryItems.append(URLQueryItem(name: "date", value: date.toAPIDateParam()))
            }
        }

        guard var components = URLComponents(string: path) else {
            throw HTTPError.invalidRequestURL
        }
        components.queryItems = queryItems.isEmpty ? nil : queryItems
        return components
    }
}


// MARK: - TubeServiceAPIClient

public struct TubeServiceAPIClient: TubeServiceAPIClientType {

    private let baseURL: URL
    private let urlSession: URLSession
    private let jsonDecoder: JSONDecoder


    // MARK: - Init

    public init(
        baseURL: URL,
        urlSession: URLSession = .shared,
        jsonDecoder: JSONDecoder = .tubeServiceModelDecoder
    ) {
        self.baseURL = baseURL
        self.urlSession = urlSession
        self.jsonDecoder = jsonDecoder
    }


    // MARK: - Data fetching

    public func fetchDailyLineTimeline(lineID: TrainLineID, date: Date?) async throws -> HTTPResponse<DailyLineTimeline> {
        try await fetchData(
            for: .getDailyLineTimeline(lineID: lineID, date: date),
            mappedTo: DailyLineTimeline.self
        )
    }

    public func fetchDailyLineDisruptionSummary(date: Date?) async throws -> HTTPResponse<[LineDisruptionSummary]> {
        try await fetchData(
            for: .getDailyLineDisruptionSummary(date: date),
            mappedTo: [LineDisruptionSummary].self
        )
    }

    private func fetchData<T: Decodable>(for route: TubeServiceAPIRoute, mappedTo model: T.Type) async throws -> HTTPResponse<T> {
        let request = try route.toURLRequest(relativeTo: baseURL)
        return try await urlSession.data(for: request, decodedBy: jsonDecoder, as: model)
    }
}
