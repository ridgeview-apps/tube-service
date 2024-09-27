import Foundation
import Models

// MARK: - Data types

public protocol SystemStatusAPIClientType: Sendable {
    func fetchSystemStatus() async throws -> HTTPResponse<SystemStatus>
}


// MARK: - API Routes

enum SystemStatusAPIRoute {
    
    case getSystemStatus(fileName: String)
    
    func toURL(relativeTo baseURL: URL) throws -> URL {
        let urlComponents = try self.toURLComponents()
        guard let url = urlComponents.url(relativeTo: baseURL) else {
            throw HTTPError.invalidRequestURL
        }
        return url
    }
    
    
    private func toURLComponents() throws -> URLComponents {
        switch self {
        case let .getSystemStatus(fileName):
            return try .fromPath("/system-status/\(fileName)")
        }
    }
}

// MARK: - SystemStatusAPIClient

public struct SystemStatusAPIClient: SystemStatusAPIClientType {
    
    public let baseURL: URL
    public let urlSession: URLSession
    public let jsonDecoder: JSONDecoder
    public let fileName: String
    
    
    // MARK: - Init
    
    public init(baseURL: URL,
                urlSession: URLSession = .shared,
                jsonDecoder: JSONDecoder = .defaultModelDecoder,
                fileName: String) {
        self.baseURL = baseURL
        self.urlSession = urlSession
        self.jsonDecoder = jsonDecoder
        self.fileName = fileName
    }
    
    
    // MARK: - Data fetching
    
    public func fetchSystemStatus() async throws -> HTTPResponse<SystemStatus> {
        try await fetchData(for: .getSystemStatus(fileName: fileName), mappedTo: SystemStatus.self)
    }
    
    private func fetchData<T: Decodable>(for route: SystemStatusAPIRoute, mappedTo model: T.Type) async throws -> HTTPResponse<T> {
        let url = try route.toURL(relativeTo: baseURL)
        return try await urlSession.get(url: url, decodedBy: jsonDecoder, as: model)
    }
}
