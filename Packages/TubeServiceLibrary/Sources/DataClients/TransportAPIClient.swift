import Combine
import Foundation
import Model
import Shared

public struct TransportAPIClient {
    public var lineStatuses: () -> AnyPublisher<[LineStatus], APIFailure>
    public var arrivals: (ArrivalsRequest) -> AnyPublisher<[Arrival], APIFailure>
}

public extension TransportAPIClient {
    struct APIFailure: Error, Equatable {
        private let error: NSError

        public init(error: Swift.Error) {
          self.error = error as NSError
        }
        
        public var localizedDescription: String {
            error.localizedDescription
        }
    }
}

// MARK: - Models
public struct ArrivalsRequest {
    public let arrivalsGroup: Station.ArrivalsGroup
    
    public init(arrivalsGroup: Station.ArrivalsGroup) {
        self.arrivalsGroup = arrivalsGroup
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
            var components = URLComponents(string: urlString)!
            
            components.queryItems = [
                URLQueryItem(name: "app_id", value: appId),
                URLQueryItem(name: "app_key", value: appKey)
            ]
            
            return components.url!

        }
    }
    
    static func real(baseURL: URL,
                     appId: String,
                     appKey: String,
                     urlSession: URLSession = .shared) -> TransportAPIClient {
        func buildURL(route: String) -> URL {
            RequestURL(
                baseURL: baseURL,
                route: route,
                appId: appId,
                appKey: appKey
            )
            .url
        }
        
        return .init(
            lineStatuses: {
                let url = buildURL(route: "/Line/Mode/tube,dlr,overground,tram,tflrail/Status")
                return urlSession.get(url: url,
                                      mappedTo: [LineStatus].self)
            },
            
            arrivals: { request in
                let lineIds = request.arrivalsGroup.lineIds.toId()
                let stationCode = request.arrivalsGroup.atcoCode
                
                let url = buildURL(route: "/Line/\(lineIds)/Arrivals/\(stationCode)")
                return urlSession.get(url: url, mappedTo: [Arrival].self)
            }
        )
    }
}

private extension URLSession {
    
    func get<T: Decodable>(url: URL, mappedTo: T.Type) -> AnyPublisher<T, TransportAPIClient.APIFailure> {
        dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: T.self, decoder: jsonDecoder)
            .mapError(TransportAPIClient.APIFailure.init)
            .eraseToAnyPublisher()
    }
}

private let jsonDecoder: JSONDecoder = JSONDecoder()
