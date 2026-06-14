import Foundation

public struct LineDisruptionSummary: Codable, Hashable, Identifiable, Sendable {
    public var id: TrainLineID { lineId }

    public let lineId: TrainLineID
    public let disrupted: Bool?

    public init(
        lineId: TrainLineID,
        disrupted: Bool?
    ) {
        self.lineId = lineId
        self.disrupted = disrupted
    }
}
