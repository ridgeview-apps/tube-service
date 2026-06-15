import Foundation
import Models

public protocol TflAPIClientType: Sendable {
    func fetchCurrentLineStatuses() async throws -> HTTPResponse<[Line]>
    func fetchLineStatuses(for dateInterval: DateInterval) async throws -> HTTPResponse<[Line]>
    func fetchArrivalPredictions(
        forLineGroup lineGroup: Station.LineGroup
    ) async throws -> HTTPResponse<[ArrivalPrediction]>
    func fetchArrivalDepartures(
        forLineGroup lineGroup: Station.LineGroup
    ) async throws -> HTTPResponse<[ArrivalDeparture]>
    func fetchStationDisruptions() async throws -> HTTPResponse<[DisruptedPoint]>
    func fetchJourneyResults(
        for params: JourneyRequestParams
    ) async throws -> HTTPResponse<JourneyResults>
}
