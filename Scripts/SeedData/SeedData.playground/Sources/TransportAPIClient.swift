import Combine
import Foundation

public struct TransportAPIClient {
    
    let baseURL: URL
    let appId: String
    let appKey: String
    let urlSession: URLSession
    
    public struct ModesResponse: Codable {
        public let id: LineID
    }
    
    public func lines(forModeIDs modeIDs: [TransportModeID]) async throws -> [LineID] {
        let modeIDsParam = modeIDs.map { $0.rawValue }.joined(separator: ",")
        let url = buildURL(route: "/Line/Mode/\(modeIDsParam)")
        let modesResponses = try await urlSession.get(url: url, mappedTo: [ModesResponse].self)
        return modesResponses.map { $0.id }
    }
    
    public func stopPoints(forLine lineID: LineID) async throws -> [StopPoint] {
        let url = buildURL(route: "/Line/\(lineID.rawValue)/StopPoints")
        return try await urlSession.get(url: url, mappedTo: [StopPoint].self)
    }
        
    private func buildURL(route: String) -> URL {
        RequestURL(
            baseURL: baseURL,
            route: route,
            appId: appId,
            appKey: appKey
        )
        .url
    }
    
    public struct APIFailure: Error, Equatable {
        private let error: NSError

        public init(error: Swift.Error) {
          self.error = error as NSError
        }
        
        public var localizedDescription: String {
            error.localizedDescription
        }
    }
    
    public static func real(baseURL: URL = URL(string: "https://api.tfl.gov.uk")!,
                            appId: String = "{APP_ID}",
                            appKey: String = "{APP_KEY}",
                            urlSession: URLSession = .shared) -> TransportAPIClient {
        .init(baseURL: baseURL, appId: appId, appKey: appKey, urlSession: urlSession)
    }
    
}

// MARK: - Real instance
public extension TransportAPIClient {
    
    private struct RequestURL {
        let baseURL: URL
        let route: String
        let appId: String
        let appKey: String
        
        var url: URL {
            let urlString = "\(baseURL)/\(route)".replacingOccurrences(of: "//", with: "/")
            return URL(string: urlString)!
        }
    }
}

private extension URLSession {
    
    func get<T: Decodable>(url: URL, mappedTo: T.Type) async throws -> T {
        let urlRequest = URLRequest(url: url)
        let (data, _) = try await self.data(for: urlRequest)
        let decodedValue = try jsonDecoder.decode(T.self, from: data)
        return decodedValue
        
    }
    
    func get<T: Decodable>(url: URL, mappedTo: T.Type) -> AnyPublisher<T, TransportAPIClient.APIFailure> {
        dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: T.self, decoder: jsonDecoder)
            .mapError(TransportAPIClient.APIFailure.init)
            .eraseToAnyPublisher()
    }
}

private let jsonDecoder: JSONDecoder = JSONDecoder()


public extension Sequence {
    func asyncForEach(
        _ operation: (Element) async throws -> Void
    ) async rethrows {
        for element in self {
            try await operation(element)
        }
    }
}
