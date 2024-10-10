import Foundation
import Models

// MARK: - Network API models

public struct HTTPResponseErrorModel: Decodable {
    public let message: String?
}

public struct HTTPResponse<T: Decodable & Sendable>: Sendable {
    public let statusCode: Int
    public let decodedModel: T
        
    public init(statusCode: Int,
                decodedModel: T) {
        self.decodedModel = decodedModel
        self.statusCode = statusCode
    }
}

public enum HTTPError: Error {
    case invalidRequestURL
    case statusCodeMissing
    case connection(Error)
    case statusCode(Int, HTTPResponseErrorModel?)
}

extension URLComponents {
    
    static func fromPath(_ path: String, queryParams: [String: String] = [:]) throws -> URLComponents {
        let sanitizedPath = "\(path)".replacingOccurrences(of: "//", with: "/")
        guard var components = URLComponents(string: sanitizedPath) else {
            throw HTTPError.invalidRequestURL
        }
        components.queryItems = queryParams.map(URLQueryItem.init)
        return components
    }
}

extension URLSession {
    
    // swiftlint:disable identifier_name
    func get<T: Decodable>(url: URL, decodedBy jsonDecoder: JSONDecoder, as: T.Type) async throws -> HTTPResponse<T> {
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let response: (data: Data, urlResponse: URLResponse)
        do {
            response = try await self.data(for: request)
        } catch {
            throw HTTPError.connection(error)
        }
        
        guard let statusCode = (response.urlResponse as? HTTPURLResponse)?.statusCode else {
            throw HTTPError.statusCodeMissing
        }
        
        let isClientOrServerError = (400..<600).contains(statusCode)
        
        guard !isClientOrServerError else {
            let errorModel = try? jsonDecoder.decode(HTTPResponseErrorModel.self, from: response.data)
            throw HTTPError.statusCode(statusCode, errorModel)
        }
        
        let decodedModel: T = try jsonDecoder.decode(T.self, from: response.data)
        return HTTPResponse(statusCode: statusCode, decodedModel: decodedModel)
    }
    // swiftlint:enable identifier_name
}
