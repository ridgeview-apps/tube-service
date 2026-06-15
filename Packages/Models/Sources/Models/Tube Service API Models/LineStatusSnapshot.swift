import Foundation

public enum LineStatusTransition: String, Codable, Hashable, Sendable {
    case baseline
    case disruptionStarted = "disruption_started"
    case disruptionChanged = "disruption_changed"
    case serviceResumed = "service_resumed"
    case statusChanged = "status_changed"
}

public struct LineStatusSnapshot: Codable, Hashable, Sendable {
    public let lineId: TrainLineID
    public let observedAt: Date
    public let transition: LineStatusTransition
    public let statuses: [LineStatus]

    public init(
        lineId: TrainLineID,
        observedAt: Date,
        transition: LineStatusTransition,
        statuses: [LineStatus]
    ) {
        self.lineId = lineId
        self.observedAt = observedAt
        self.transition = transition
        self.statuses = statuses
    }
}
