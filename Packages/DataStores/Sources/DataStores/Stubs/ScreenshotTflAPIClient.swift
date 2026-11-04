import Foundation
import Models
import ModelStubs

#if DEBUG

    /// Answers from the App Store screenshot fixtures. Unlike `StubTflAPIClient`, arrivals are filtered to the
    /// requested station and lines, so each board shows its own trains (and stations that weren't captured show none).
    public struct ScreenshotTflAPIClient: TflAPIClientType {

        private typealias Fixtures = ModelStubs.Screenshots

        public init() {}

        public func fetchCurrentLineStatuses() async throws -> HTTPResponse<[Line]> {
            .success200(Fixtures.lineStatusesToday)
        }

        public func fetchLineStatuses(for dateInterval: DateInterval) async throws -> HTTPResponse<[Line]> {
            .success200(Fixtures.lineStatusesFuture)
        }

        public func fetchArrivalPredictions(
            forLineGroup lineGroup: Station.LineGroup
        ) async throws -> HTTPResponse<[ArrivalPrediction]> {
            .success200(
                Fixtures.kingsCrossArrivals.filter { prediction in
                    prediction.naptanID == lineGroup.atcoCode
                        && prediction.lineID.map(lineGroup.lineIds.contains) == true
                }
            )
        }

        public func fetchArrivalDepartures(
            forLineGroup lineGroup: Station.LineGroup
        ) async throws -> HTTPResponse<[ArrivalDeparture]> {
            .success200(Fixtures.abbeyWoodDepartures.filter { $0.naptanId == lineGroup.atcoCode })
        }

        public func fetchStationDisruptions() async throws -> HTTPResponse<[DisruptedPoint]> {
            .success200(Fixtures.disruptedStations)
        }

        public func fetchJourneyResults(for params: JourneyRequestParams) async throws -> HTTPResponse<JourneyResults> {
            .success200(Fixtures.journeyResults)
        }
    }

#endif
