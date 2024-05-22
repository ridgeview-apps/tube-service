import Combine
import Foundation
import Models
import ModelStubs
import Shared

#if DEBUG

public final class StubTransportAPIClient: TransportAPIClientType {
    
    public init() {}
    
    public private(set) var fetchCurrentLineStatusesCallCount = 0
    public var stubbedLineStatuses: APIResponse<[Line]> = .success200(ModelStubs.lineStatusesToday)
    public var fetchCurrentLineStatusesError: Error?
    public func fetchCurrentLineStatuses() async throws -> APIResponse<[Line]> {
        fetchCurrentLineStatusesCallCount += 1
        if let fetchCurrentLineStatusesError { throw fetchCurrentLineStatusesError }
        return stubbedLineStatuses
    }
    
    public private(set) var fetchLineStatusesForDateRangeCallCount = 0
    public var stubbedLineStatusesForDateRange: APIResponse<[Line]> = .success200(ModelStubs.lineStatusesFuture)
    public func fetchLineStatuses(for dateInterval: DateInterval) async throws -> APIResponse<[Line]> {
        fetchLineStatusesForDateRangeCallCount += 1
        return stubbedLineStatusesForDateRange
    }
    
    public private(set) var fetchArrivalPredictionsCallCount = 0
    public var stubbedArrivalPredictions: APIResponse<[ArrivalPrediction]> = .success200(ModelStubs.northernLineBothPlatforms)
    public func fetchArrivalPredictions(forLineGroup lineGroup: Station.LineGroup) async throws -> APIResponse<[ArrivalPrediction]> {
        fetchArrivalPredictionsCallCount += 1
        return stubbedArrivalPredictions
    }
    
    public private(set) var fetchArrivalDeparturesCallCount = 0
    public var stubbedArrivalDepartures: APIResponse<[ArrivalDeparture]> = .success200(ModelStubs.elizabethLineBothPlatforms)
    public func fetchArrivalDepartures(forLineGroup lineGroup: Station.LineGroup) async throws -> APIResponse<[ArrivalDeparture]> {
        fetchArrivalDeparturesCallCount += 1
        return stubbedArrivalDepartures
    }

    public private(set) var fetchStationDisruptionsCallCount = 0
    public var stubbedDisruptedPoints: APIResponse<[DisruptedPoint]> = .success200(ModelStubs.disruptedStations)
    public func fetchStationDisruptions() async throws -> APIResponse<[DisruptedPoint]> {
        fetchStationDisruptionsCallCount += 1
        return stubbedDisruptedPoints
    }
    
    public private(set) var fetchJourneyItineraryCallCount = 0
    public var stubbedJourneyItinerary: APIResponse<JourneyItinerary> = .success200(ModelStubs.journeyItineraryKingsXToWaterloo)
    public func fetchJourneyItinerary(for params: JourneyRequestParams) async throws -> APIResponse<JourneyItinerary> {
        fetchJourneyItineraryCallCount += 1
        return stubbedJourneyItinerary
    }
}

extension APIResponse {
    static func success200(_ decodeModel: T) -> APIResponse<T> {
        .init(httpStatusCode: 200, decodedModel: decodeModel)
    }
}

#endif
