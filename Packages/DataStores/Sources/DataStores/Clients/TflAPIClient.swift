import Foundation
import Models

public struct TflAPIClient: TflAPIClientType {
    // MARK: - State

    private let baseURL: URL
    private let appKey: String
    private let urlSession: URLSession
    private let jsonDecoder: JSONDecoder

    public init(
        baseURL: URL,
        appKey: String,
        urlSession: URLSession = .shared,
        jsonDecoder: JSONDecoder = .tflModelDecoder
    ) {
        self.baseURL = baseURL
        self.appKey = appKey
        self.urlSession = urlSession
        self.jsonDecoder = jsonDecoder
    }

    // MARK: - Requests

    public func fetchCurrentLineStatuses() async throws -> HTTPResponse<[Line]> {
        let response = try await fetchData(for: .currentLineStatuses(ModeID.trains), mappedTo: LossyDecodableArray<Line>.self)
        return HTTPResponse(statusCode: response.statusCode, decodedModel: response.decodedModel.elements)
    }

    public func fetchLineStatuses(for dateInterval: DateInterval) async throws -> HTTPResponse<[Line]> {
        let response = try await fetchData(
            for: .lineStatusesForDateRange(TrainLineID.allCases, dateInterval),
            mappedTo: LossyDecodableArray<Line>.self
        )
        return HTTPResponse(statusCode: response.statusCode, decodedModel: response.decodedModel.elements)
    }

    public func fetchArrivalPredictions(forLineGroup lineGroup: Station.LineGroup) async throws -> HTTPResponse<[ArrivalPrediction]> {
        return try await fetchData(
            for: .arrivalPredictions(stationCode: lineGroup.atcoCode, lineGroup.lineIds),
            mappedTo: [ArrivalPrediction].self
        )
    }

    public func fetchArrivalDepartures(forLineGroup lineGroup: Station.LineGroup) async throws -> HTTPResponse<[ArrivalDeparture]> {
        return try await fetchData(
            for: .arrivalDepartures(stationCode: lineGroup.atcoCode, lineGroup.lineIds),
            mappedTo: [ArrivalDeparture].self
        )
    }

    public func fetchStationDisruptions() async throws -> HTTPResponse<[DisruptedPoint]> {
        return try await fetchData(
            for: .stationDisruptions(ModeID.trains),
            mappedTo: [DisruptedPoint].self
        )
    }

    public func fetchJourneyResults(for params: JourneyRequestParams) async throws -> HTTPResponse<JourneyResults> {
        return try await fetchData(
            for: .journeyResults(params),
            mappedTo: JourneyResults.self
        )
    }

    // MARK: - Implementation

    private func fetchData<T: Decodable>(for route: TflAPIRoute, mappedTo model: T.Type) async throws -> HTTPResponse<T> {
        let request = try route.toURLRequest(relativeTo: baseURL, appKey: appKey)
        return try await urlSession.data(for: request, decodedBy: jsonDecoder, as: model)
    }
}
