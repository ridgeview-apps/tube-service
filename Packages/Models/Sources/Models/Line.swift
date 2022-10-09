public struct Line: Codable, Identifiable, Hashable {
    public let id: LineID
    public let lineStatuses: [LineStatus]?
    
    public init(
        id: LineID,
        lineStatuses: [LineStatus]?
    ) {
        self.id = id
        self.lineStatuses = lineStatuses
    }
}
