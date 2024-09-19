public struct Line: Codable, Identifiable, Hashable, Sendable {
    public let id: TrainLineID
    public let lineStatuses: [LineStatus]?
    
    public init(
        id: TrainLineID,
        lineStatuses: [LineStatus]?
    ) {
        self.id = id
        self.lineStatuses = lineStatuses
    }
}
