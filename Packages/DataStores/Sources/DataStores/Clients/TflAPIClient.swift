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
        let response = try await perform(.currentLineStatuses(ModeID.trains), as: LossyDecodableArray<Line>.self)
        return HTTPResponse(statusCode: response.statusCode, decodedModel: response.decodedModel.elements)
    }

    public func fetchLineStatuses(for dateInterval: DateInterval) async throws -> HTTPResponse<[Line]> {
        let response = try await perform(
            .lineStatusesForDateRange(TrainLineID.allCases, dateInterval),
            as: LossyDecodableArray<Line>.self
        )
        return HTTPResponse(statusCode: response.statusCode, decodedModel: response.decodedModel.elements)
    }

    public func fetchArrivalPredictions(forLineGroup lineGroup: Station.LineGroup) async throws -> HTTPResponse<[ArrivalPrediction]> {
        return try await perform(
            .arrivalPredictions(stationCode: lineGroup.atcoCode, lineGroup.lineIds),
            as: [ArrivalPrediction].self
        )
    }

    public func fetchArrivalDepartures(forLineGroup lineGroup: Station.LineGroup) async throws -> HTTPResponse<[ArrivalDeparture]> {
        return try await perform(
            .arrivalDepartures(stationCode: lineGroup.atcoCode, lineGroup.lineIds),
            as: [ArrivalDeparture].self
        )
    }

    public func fetchStationDisruptions() async throws -> HTTPResponse<[DisruptedPoint]> {
        return try await perform(
            .stationDisruptions(ModeID.trains),
            as: [DisruptedPoint].self
        )
    }

    public func fetchJourneyResults(for params: JourneyRequestParams) async throws -> HTTPResponse<JourneyResults> {
        return try await perform(
            .journeyResults(params),
            as: JourneyResults.self
        )
    }

    // MARK: - Implementation

    private func perform<T: Decodable>(_ route: TflAPIRoute, as type: T.Type) async throws -> HTTPResponse<T> {
        let request = try route.toURLRequest(relativeTo: baseURL, appKey: appKey)
        return try await urlSession.data(for: request, decodedBy: jsonDecoder, as: type)
    }
}
