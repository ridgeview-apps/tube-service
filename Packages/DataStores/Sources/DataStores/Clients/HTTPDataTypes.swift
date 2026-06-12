import Foundation
import Models

// MARK: - Network API models

public struct HTTPResponseErrorModel: Decodable, Equatable, Sendable {
    public let message: String?
}

public struct HTTPResponse<T: Decodable & Sendable>: Sendable {
    public let statusCode: Int
    public let decodedModel: T

    public init(
        statusCode: Int,
        decodedModel: T
    ) {
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

extension HTTPError: Equatable {

    public static func == (lhs: HTTPError, rhs: HTTPError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidRequestURL, .invalidRequestURL),
            (.statusCodeMissing, .statusCodeMissing):
            return true
        case let (.connection(lhsError), .connection(rhsError)):
            let lhsError = lhsError as NSError
            let rhsError = rhsError as NSError
            return lhsError.domain == rhsError.domain && lhsError.code == rhsError.code
        case let (.statusCode(lhsCode, lhsModel), .statusCode(rhsCode, rhsModel)):
            return lhsCode == rhsCode && lhsModel == rhsModel
        default:
            return false
        }
    }
}

extension HTTPError: LocalizedError {

    public var errorDescription: String? {
        switch self {
        case .invalidRequestURL:
            return "The request URL is invalid."
        case .statusCodeMissing:
            return "The server response did not include an HTTP status code."
        case let .connection(error):
            return error.localizedDescription
        case let .statusCode(statusCode, errorModel):
            return errorModel?.message ?? "The server returned HTTP status code \(statusCode)."
        }
    }
}

extension URLComponents {

    static func fromPath(_ path: String, queryParams: [String: String] = [:]) throws -> URLComponents {
        let sanitizedPath = "\(path)".replacingOccurrences(of: "//", with: "/")
        guard var components = URLComponents(string: sanitizedPath) else {
            throw HTTPError.invalidRequestURL
        }
        components.queryItems = queryParams.isEmpty ? nil : queryParams.map(URLQueryItem.init)
        return components
    }
}

extension URLSession {

    func data<T: Decodable>(for request: URLRequest, decodedBy jsonDecoder: JSONDecoder, as: T.Type) async throws -> HTTPResponse<T> {
        let response: (data: Data, urlResponse: URLResponse)
        do {
            response = try await self.data(for: request)
        } catch {
            throw HTTPError.connection(error)
        }

        guard let statusCode = (response.urlResponse as? HTTPURLResponse)?.statusCode else {
            throw HTTPError.statusCodeMissing
        }

        guard (200..<300).contains(statusCode) else {
            let errorModel = try? jsonDecoder.decode(HTTPResponseErrorModel.self, from: response.data)
            throw HTTPError.statusCode(statusCode, errorModel)
        }

        let decodedModel: T = try jsonDecoder.decode(T.self, from: response.data)
        return HTTPResponse(statusCode: statusCode, decodedModel: decodedModel)
    }
}
