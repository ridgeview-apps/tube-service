import Foundation
import Models

// MARK: - Data types

public protocol TransportAPIClientType {
    func fetchCurrentLineStatuses() async throws -> [Line]
    func fetchFutureLineStatuses(for dateInterval: DateInterval) async throws -> [Line]
    func fetchArrivalPredictions(forLineGroup lineGroup: Station.LineGroup) async throws -> [ArrivalPrediction]
    func fetchArrivalDepartures(forLineGroup lineGroup: Station.LineGroup) async throws -> [ArrivalDeparture]
}

public enum TransportAPIError: Error {
    case invalidRequestURL
    case requestFailure(Error)
}


// MARK: - TransportAPIClient

public struct TransportAPIClient: TransportAPIClientType {
    
    public let baseURL: URL
    public let appID: String
    public let appKey: String
    public let urlSession: URLSession
    public let jsonDecoder: JSONDecoder
    
    
    // MARK: - Init
    
    public init(baseURL: URL,
                appID: String,
                appKey: String,
                urlSession: URLSession = .shared,
                jsonDecoder: JSONDecoder = .defaultModelDecoder) {
        self.baseURL = baseURL
        self.appID = appID
        self.appKey = appKey
        self.urlSession = urlSession
        self.jsonDecoder = jsonDecoder
    }
    
    
    // MARK: - Data fetching
    
    public func fetchCurrentLineStatuses() async throws -> [Line] {
        return try await fetchData(for: .getCurrentLineStatuses(TransportMode.allCases), mappedTo: [Line].self)
    }
    
    public func fetchFutureLineStatuses(for dateInterval: DateInterval) async throws -> [Line] {
        return try await fetchData(for: .getFutureLineStatuses(LineID.allCases, dateInterval),
                                   mappedTo: [Line].self)
    }
    
    public func fetchArrivalPredictions(forLineGroup lineGroup: Station.LineGroup) async throws -> [ArrivalPrediction] {
        return try await fetchData(for: .getArrivalPredictions(stationCode: lineGroup.atcoCode, lineGroup.lineIds),
                                   mappedTo: [ArrivalPrediction].self)
    }
    
    public func fetchArrivalDepartures(forLineGroup lineGroup: Station.LineGroup) async throws -> [ArrivalDeparture] {
        return try await fetchData(for: .getArrivalDepartures(stationCode: lineGroup.atcoCode, lineGroup.lineIds),
                                   mappedTo: [ArrivalDeparture].self)
    }
    
    private func fetchData<T: Decodable>(for route: TransportAPIRoute, mappedTo model: T.Type) async throws -> T {
        let url = try route.toURL(relativeTo: baseURL, appID: appID, appKey: appKey)
        return try await urlSession.get(url: url, decodedBy: jsonDecoder, as: model)
    }
}


// MARK: - Private helpers

private extension URLSession {
    
    func get<T: Decodable>(url: URL, decodedBy jsonDecoder: JSONDecoder, as: T.Type) async throws -> T {
        do {
            var request = URLRequest(url: url)
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            let (data, _) = try await self.data(for: request)
            return try jsonDecoder.decode(T.self, from: data)
        } catch {
            throw TransportAPIError.requestFailure(error)
        }
    }
}
