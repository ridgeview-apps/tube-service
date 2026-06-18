import Foundation

public struct DailyDisruptionSummary: Codable, Hashable, Sendable {
    public let operationalDate: Date
    public let timezone: String
    public let startsAt: Date
    public let endsAt: Date
    public let lines: [String: [LineStatusSnapshot]]

    public init(
        operationalDate: Date,
        timezone: String,
        startsAt: Date,
        endsAt: Date,
        lines: [String: [LineStatusSnapshot]]
    ) {
        self.operationalDate = operationalDate
        self.timezone = timezone
        self.startsAt = startsAt
        self.endsAt = endsAt
        self.lines = lines
    }
}
