import Foundation
import Models
import ModelStubs
import Shared

#if DEBUG

    public final class StubTubeServiceAPIClient: TubeServiceAPIClientType, @unchecked Sendable {

        public init() {}

        public private(set) var fetchDailyLineTimelineCallCount = 0
        public var stubbedDailyLineTimeline: HTTPResponse<DailyLineTimeline> = .success200(
            .init(
                lineId: .victoria,
                operationalDate: .now,
                timezone: "Europe/London",
                startsAt: .now,
                endsAt: .now,
                snapshots: []
            )
        )
        public var fetchDailyLineTimelineError: Error?
        public func fetchDailyLineTimeline(lineID: TrainLineID, operationalDate: Date?) async throws -> HTTPResponse<DailyLineTimeline> {
            fetchDailyLineTimelineCallCount += 1
            if let fetchDailyLineTimelineError { throw fetchDailyLineTimelineError }
            return stubbedDailyLineTimeline
        }

        public private(set) var fetchDailyLineDisruptionSummaryCallCount = 0
        public var stubbedDailyLineDisruptionSummary: HTTPResponse<DailyDisruptionSummary> = .success200(
            .init(operationalDate: .now, timezone: "Europe/London", startsAt: .now, endsAt: .now, lines: [:])
        )
        public var fetchDailyLineDisruptionSummaryError: Error?
        public func fetchDailyLineDisruptionSummary(operationalDate: Date?) async throws -> HTTPResponse<DailyDisruptionSummary> {
            fetchDailyLineDisruptionSummaryCallCount += 1
            if let fetchDailyLineDisruptionSummaryError { throw fetchDailyLineDisruptionSummaryError }
            return stubbedDailyLineDisruptionSummary
        }
    }

#endif
