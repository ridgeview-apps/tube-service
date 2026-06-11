import Foundation

public struct LineStatusSnapshot: Codable, Hashable, Sendable {
    public let lineId: TrainLineID
    public let lineName: String
    public let modeName: String
    public let observedAt: Date
    public let statuses: [Status]

    public init(
        lineId: TrainLineID,
        lineName: String,
        modeName: String,
        observedAt: Date,
        statuses: [Status]
    ) {
        self.lineId = lineId
        self.lineName = lineName
        self.modeName = modeName
        self.observedAt = observedAt
        self.statuses = statuses
    }

    public struct Status: Codable, Hashable, Sendable {
        public let statusSeverity: Int
        public let statusDescription: String
        public let reason: String?
        public let disruptionCategory: String?
        public let additionalInfo: String?

        public init(
            statusSeverity: Int,
            statusDescription: String,
            reason: String?,
            disruptionCategory: String?,
            additionalInfo: String?
        ) {
            self.statusSeverity = statusSeverity
            self.statusDescription = statusDescription
            self.reason = reason
            self.disruptionCategory = disruptionCategory
            self.additionalInfo = additionalInfo
        }
    }
}

public extension LineStatusSnapshot.Status {

    var severity: LineStatusSeverity? {
        LineStatusSeverity(rawValue: statusSeverity)
    }

    var category: DisruptionCategory? {
        disruptionCategory.flatMap(DisruptionCategory.init(rawValue:))
    }
}
