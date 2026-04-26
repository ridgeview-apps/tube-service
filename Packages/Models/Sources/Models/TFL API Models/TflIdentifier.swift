public struct TflIdentifier: Codable, Hashable, Sendable {
    public let id: String?
    public let name: String?
}

extension TflIdentifier {
    
    var trainLineID: TrainLineID? {
        guard let id else { return nil }
        return TrainLineID(rawValue: id)
    }
    
    var modeID: ModeID? {
        guard let id else { return nil }
        return ModeID(rawValue: id)
    }
}
