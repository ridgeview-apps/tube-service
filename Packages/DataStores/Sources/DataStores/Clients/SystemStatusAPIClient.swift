import Foundation
import Models

// MARK: - Data types

public protocol SystemStatusAPIClientType: Sendable {
    func fetchSystemStatus() async throws -> HTTPResponse<SystemStatus>
}


// MARK: - API Routes

enum SystemStatusAPIRoute {

    case systemStatus(fileName: String)

    func toURL(relativeTo baseURL: URL) throws -> URL {
        let urlComponents = try self.toURLComponents(relativeTo: baseURL)
        guard let url = urlComponents.url else {
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


    private func toURLComponents(relativeTo baseURL: URL) throws -> URLComponents {
        switch self {
        case let .systemStatus(fileName):
            return try .route(
                relativeTo: baseURL,
                pathComponents: ["system-status", fileName]
            )
        }
    }
}

// MARK: - SystemStatusAPIClient

public struct SystemStatusAPIClient: SystemStatusAPIClientType {

    private let baseURL: URL
    private let urlSession: URLSession
    private let jsonDecoder: JSONDecoder
    private let fileName: String


    // MARK: - Init

    public init(
        baseURL: URL,
        urlSession: URLSession = .shared,
        jsonDecoder: JSONDecoder = .defaultModelDecoder,
        fileName: String
    ) {
        self.baseURL = baseURL
        self.urlSession = urlSession
        self.jsonDecoder = jsonDecoder
        self.fileName = fileName
    }


    // MARK: - Data fetching

    public func fetchSystemStatus() async throws -> HTTPResponse<SystemStatus> {
        try await fetchData(for: .systemStatus(fileName: fileName), mappedTo: SystemStatus.self)
    }

    private func fetchData<T: Decodable>(for route: SystemStatusAPIRoute, mappedTo model: T.Type) async throws -> HTTPResponse<T> {
        let request = try route.toURLRequest(relativeTo: baseURL)
        return try await urlSession.data(for: request, decodedBy: jsonDecoder, as: model)
    }
}
