import Combine
import ComposableArchitecture
import Model

struct TransportAPI {
    var lineStatuses: () -> Effect<[LineStatus], APIFailure>
    var arrivals: (ArrivalsRequest) -> Effect<[Arrival], APIFailure>
}

extension TransportAPI {
    struct APIFailure: Error, Equatable {
        private let error: NSError

        init(error: Swift.Error) {
          self.error = error as NSError
        }
        
        var localizedDescription: String {
            error.localizedDescription
        }
    }
}

// MARK: - Models
struct ArrivalsRequest {
    let arrivalsGroup: Station.ArrivalsGroup
}

struct ArrivalsResponse: Codable, Equatable {
    let arrivals: [Arrival]
}


// MARK: - Real instance
extension TransportAPI {
    
    private struct RequestURL {
        let config: AppConfig = .real
        let route: String
        
        var url: URL {
            let urlString = "\(config.transportAPI.baseURL)/\(route)".replacingOccurrences(of: "//", with: "/")
            var components = URLComponents(string: urlString)!
            
            components.queryItems = [
                URLQueryItem(name: "app_id", value: config.transportAPI.appId),
                URLQueryItem(name: "app_key", value: config.transportAPI.appKey)
            ]
            
            return components.url!

        }
    }
    
    static let real = TransportAPI(
        lineStatuses: { () -> Effect<[LineStatus], APIFailure> in

            let url = RequestURL(route: "/Line/Mode/tube,dlr,overground,tram,tflrail/Status").url
            
            return URLSession.shared.dataTaskPublisher(for: url)
                .map { data, _ in data }
                .decode(type: [LineStatus].self, decoder: jsonDecoder)
                .mapError(APIFailure.init)
                .eraseToEffect()
        },
        
        arrivals: { request -> Effect<[Arrival], APIFailure> in
            
            let lineIds = request.arrivalsGroup.lineIds.toId()
            let stationCode = request.arrivalsGroup.atcoCode
            
            let url = RequestURL(route: "/Line/\(lineIds)/Arrivals/\(stationCode)").url
            
            return URLSession.shared.dataTaskPublisher(for: url)
                .map { $0.data }
                .decode(type: [Arrival].self, decoder: jsonDecoder)
                .mapError(APIFailure.init)
                .eraseToEffect()
        }
    )
}

// MARK: - Fake instance
#if DEBUG
extension TransportAPI {
    static let fake = TransportAPI(
        lineStatuses: { () -> Effect<[LineStatus], APIFailure> in
            return Effect(value: .fakes())
        },
        arrivals: { request -> Effect<[Arrival], APIFailure> in
            return Effect(value: .fakes(ofTypes: .multiLine))
        }
    )
}
#endif

private let jsonDecoder: JSONDecoder = JSONDecoder()
