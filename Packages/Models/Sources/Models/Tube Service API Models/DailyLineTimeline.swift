import Foundation

public struct DailyLineTimeline: Codable, Hashable, Sendable {
    public let lineId: TrainLineID
    public let date: Date
    public let timezone: String
    public let startsAt: Date
    public let endsAt: Date
    public let snapshots: [LineStatusSnapshot]

    public init(
        lineId: TrainLineID,
        date: Date,
        timezone: String,
        startsAt: Date,
        endsAt: Date,
        snapshots: [LineStatusSnapshot]
    ) {
        self.lineId = lineId
        self.date = date
        self.timezone = timezone
        self.startsAt = startsAt
        self.endsAt = endsAt
        self.snapshots = snapshots
    }
}
