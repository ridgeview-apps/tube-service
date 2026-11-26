import Foundation
import Models
import ModelStubs
import Shared

#if DEBUG

    public final class StubTflAPIClient: TflAPIClientType, @unchecked Sendable {

        public init() {}

        public private(set) var fetchCurrentLineStatusesCallCount = 0
        public var stubbedLineStatuses: HTTPResponse<[Line]> = .success200(ModelStubs.lineStatusesToday)
        public var fetchCurrentLineStatusesError: Error?
        public func fetchCurrentLineStatuses() async throws -> HTTPResponse<[Line]> {
            fetchCurrentLineStatusesCallCount += 1
            if let fetchCurrentLineStatusesError { throw fetchCurrentLineStatusesError }
            return stubbedLineStatuses
        }

        public private(set) var fetchLineStatusesForDateRangeCallCount = 0
        public var stubbedLineStatusesForDateRange: HTTPResponse<[Line]> = .success200(ModelStubs.lineStatusesFuture)
        public func fetchLineStatuses(for dateInterval: DateInterval) async throws -> HTTPResponse<[Line]> {
            fetchLineStatusesForDateRangeCallCount += 1
            return stubbedLineStatusesForDateRange
        }

        public private(set) var fetchArrivalPredictionsCallCount = 0
        public var stubbedArrivalPredictions: HTTPResponse<[ArrivalPrediction]> = .success200(ModelStubs.northernLineBothPlatforms)
        public var fetchArrivalPredictionsError: Error?
        /// Holds each response back, like a slow network. Cancelling the fetch throws a `CancellationError`, as `URLSession` does.
        public var fetchArrivalPredictionsDelay: Duration?
        public func fetchArrivalPredictions(forLineGroup lineGroup: Station.LineGroup) async throws -> HTTPResponse<[ArrivalPrediction]> {
            fetchArrivalPredictionsCallCount += 1
            if let fetchArrivalPredictionsDelay { try await Task.sleep(for: fetchArrivalPredictionsDelay) }
            if let fetchArrivalPredictionsError { throw fetchArrivalPredictionsError }
            return stubbedArrivalPredictions
        }

        public private(set) var fetchArrivalDeparturesCallCount = 0
        public var stubbedArrivalDepartures: HTTPResponse<[ArrivalDeparture]> = .success200(ModelStubs.elizabethLineBothPlatforms)
        public var fetchArrivalDeparturesError: Error?
        public var fetchArrivalDeparturesDelay: Duration?
        public func fetchArrivalDepartures(forLineGroup lineGroup: Station.LineGroup) async throws -> HTTPResponse<[ArrivalDeparture]> {
            fetchArrivalDeparturesCallCount += 1
            if let fetchArrivalDeparturesDelay { try await Task.sleep(for: fetchArrivalDeparturesDelay) }
            if let fetchArrivalDeparturesError { throw fetchArrivalDeparturesError }
            return stubbedArrivalDepartures
        }

        public private(set) var fetchStationDisruptionsCallCount = 0
        public var stubbedDisruptedPoints: HTTPResponse<[DisruptedPoint]> = .success200(ModelStubs.disruptedStations)
        public var fetchStationDisruptionsError: Error?
        public func fetchStationDisruptions() async throws -> HTTPResponse<[DisruptedPoint]> {
            fetchStationDisruptionsCallCount += 1
            if let fetchStationDisruptionsError { throw fetchStationDisruptionsError }
            return stubbedDisruptedPoints
        }

        public private(set) var fetchBusArrivalsCallCount = 0
        public var stubbedBusArrivals: HTTPResponse<[BusArrival]> = .success200(ModelStubs.busArrivalsKingsCrossStationR)
        public var fetchBusArrivalsError: Error?
        public var fetchBusArrivalsDelay: Duration?
        public func fetchBusArrivals(stopID: BusStop.ID) async throws -> HTTPResponse<[BusArrival]> {
            fetchBusArrivalsCallCount += 1
            if let fetchBusArrivalsDelay { try await Task.sleep(for: fetchBusArrivalsDelay) }
            if let fetchBusArrivalsError { throw fetchBusArrivalsError }
            return stubbedBusArrivals
        }

        public private(set) var fetchBusStopDisruptionsCallCount = 0
        public var stubbedBusStopDisruptions: HTTPResponse<[DisruptedPoint]> = .success200(ModelStubs.busStopDisruptions)
        public var fetchBusStopDisruptionsError: Error?
        public func fetchBusStopDisruptions(stopID: BusStop.ID) async throws -> HTTPResponse<[DisruptedPoint]> {
            fetchBusStopDisruptionsCallCount += 1
            if let fetchBusStopDisruptionsError { throw fetchBusStopDisruptionsError }
            return stubbedBusStopDisruptions
        }

        public private(set) var fetchJourneyResultsCallCount = 0
        public var stubbedJourneyResults: HTTPResponse<JourneyResults> = .success200(ModelStubs.journeyResultsKingsXToWaterlooNow)
        public var fetchJourneyResultsError: Error?
        public func fetchJourneyResults(for params: JourneyRequestParams) async throws -> HTTPResponse<JourneyResults> {
            fetchJourneyResultsCallCount += 1
            if let fetchJourneyResultsError { throw fetchJourneyResultsError }
            return stubbedJourneyResults
        }
    }

    extension HTTPResponse {
        static func success200(_ decodeModel: T) -> HTTPResponse<T> {
            .init(statusCode: 200, decodedModel: decodeModel)
        }
    }

#endif
