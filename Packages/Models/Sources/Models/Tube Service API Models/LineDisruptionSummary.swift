import Foundation

public struct DailyDisruptionSummary: Codable, Hashable, Sendable {
    public let operationalDate: Date
    public let timezone: String
    public let startsAt: Date
    public let endsAt: Date
    public let lines: [String: LineDisruptionSummary]

    public init(
        operationalDate: Date,
        timezone: String,
        startsAt: Date,
        endsAt: Date,
        lines: [String: LineDisruptionSummary]
    ) {
        self.operationalDate = operationalDate
        self.timezone = timezone
        self.startsAt = startsAt
        self.endsAt = endsAt
        self.lines = lines
    }
}

public struct LineDisruptionSummary: Codable, Hashable, Sendable {
    public let disrupted: Bool
    public let disruptionCount: Int
    public let latestDisruptionAt: Date?

    public init(disrupted: Bool, disruptionCount: Int, latestDisruptionAt: Date?) {
        self.disrupted = disrupted
        self.disruptionCount = disruptionCount
        self.latestDisruptionAt = latestDisruptionAt
    }
}
