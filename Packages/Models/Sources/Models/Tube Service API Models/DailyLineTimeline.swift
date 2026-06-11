import Foundation

public struct DailyLineTimeline: Codable, Hashable, Sendable {
    public let lineId: TrainLineID
    public let date: Date
    public let timezone: String
    public let snapshots: [LineStatusSnapshot]

    public init(
        lineId: TrainLineID,
        date: Date,
        timezone: String,
        snapshots: [LineStatusSnapshot]
    ) {
        self.lineId = lineId
        self.date = date
        self.timezone = timezone
        self.snapshots = snapshots
    }
}
