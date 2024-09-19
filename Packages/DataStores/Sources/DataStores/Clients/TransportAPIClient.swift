import Foundation
import Models

// MARK: - Data types

public protocol TransportAPIClientType: Sendable {
    func fetchCurrentLineStatuses() async throws -> APIResponse<[Line]>
    func fetchLineStatuses(for dateInterval: DateInterval) async throws -> APIResponse<[Line]>
    func fetchArrivalPredictions(forLineGroup lineGroup: Station.LineGroup) async throws -> APIResponse<[ArrivalPrediction]>
    func fetchArrivalDepartures(forLineGroup lineGroup: Station.LineGroup) async throws -> APIResponse<[ArrivalDeparture]>
    func fetchStationDisruptions() async throws -> APIResponse<[DisruptedPoint]>
    func fetchJourneyItinerary(for params: JourneyRequestParams) async throws -> APIResponse<JourneyItinerary>
}

public enum TransportAPIError: Error {
    case invalidRequestURL
    case httpStatusCodeMissing
    case connection(Error)
    case httpStatusCode(Int, APIResponseErrorModel?)
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
    
    public func fetchCurrentLineStatuses() async throws -> APIResponse<[Line]> {
        return try await fetchData(for: .getCurrentLineStatuses(ModeID.trains), mappedTo: [Line].self)
    }
    
    public func fetchLineStatuses(for dateInterval: DateInterval) async throws -> APIResponse<[Line]> {
        return try await fetchData(for: .getLineStatusesForDateRange(TrainLineID.allCases, dateInterval),
                                   mappedTo: [Line].self)
    }
    
    public func fetchArrivalPredictions(forLineGroup lineGroup: Station.LineGroup) async throws -> APIResponse<[ArrivalPrediction]> {
        return try await fetchData(for: .getArrivalPredictions(stationCode: lineGroup.atcoCode, lineGroup.lineIds),
                                   mappedTo: [ArrivalPrediction].self)
    }
    
    public func fetchArrivalDepartures(forLineGroup lineGroup: Station.LineGroup) async throws -> APIResponse<[ArrivalDeparture]> {
        return try await fetchData(for: .getArrivalDepartures(stationCode: lineGroup.atcoCode, lineGroup.lineIds),
                                   mappedTo: [ArrivalDeparture].self)
    }
    
    public func fetchStationDisruptions() async throws -> APIResponse<[DisruptedPoint]> {
        return try await fetchData(for: .getStationDisruptions(ModeID.trains),
                                   mappedTo: [DisruptedPoint].self)
    }
    
    public func fetchJourneyItinerary(for params: JourneyRequestParams) async throws -> APIResponse<JourneyItinerary> {
        return try await fetchData(for: .getJourneyItinerary(params),
                                   mappedTo: JourneyItinerary.self)
    }
    
    private func fetchData<T: Decodable>(for route: TransportAPIRoute, mappedTo model: T.Type) async throws -> APIResponse<T> {
        let url = try route.toURL(relativeTo: baseURL, appID: appID, appKey: appKey)
        return try await urlSession.get(url: url, decodedBy: jsonDecoder, as: model)
    }
}


// MARK: - Private helpers

private extension URLSession {
    
    // swiftlint:disable identifier_name
    func get<T: Decodable>(url: URL, decodedBy jsonDecoder: JSONDecoder, as: T.Type) async throws -> APIResponse<T> {
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let response: (data: Data, urlResponse: URLResponse)
        do {
            response = try await self.data(for: request)
        } catch {
            throw TransportAPIError.connection(error)
        }
        
        guard let statusCode = (response.urlResponse as? HTTPURLResponse)?.statusCode else {
            throw TransportAPIError.httpStatusCodeMissing
        }
        
        let isClientOrServerError = (400..<600).contains(statusCode)
        
        guard !isClientOrServerError else {
            let errorModel = try? jsonDecoder.decode(APIResponseErrorModel.self, from: response.data)
            throw TransportAPIError.httpStatusCode(statusCode, errorModel)
        }
        
        let decodedModel: T = try jsonDecoder.decode(T.self, from: response.data)
        return APIResponse(httpStatusCode: statusCode, decodedModel: decodedModel)
    }
    // swiftlint:enable identifier_name
}
