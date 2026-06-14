import Foundation

public struct DailyDisruptionSummary: Codable, Hashable, Sendable {
    public let date: Date
    public let timezone: String
    public let lines: [String: LineDisruptionSummary]

    public init(date: Date, timezone: String, lines: [String: LineDisruptionSummary]) {
        self.date = date
        self.timezone = timezone
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
