import Foundation

public struct Station: Identifiable, Equatable, Hashable, Codable {
    public let id: String
    public let name: String
    public let arrivalsGroups: [ArrivalsGroup]
    
    public init(
        id: String,
        name: String,
        arrivalsGroups: [Station.ArrivalsGroup]
    ) {
        self.id = id
        self.name = name
        self.arrivalsGroups = arrivalsGroups
    }
}

public extension Station {
    
    struct ArrivalsGroup: Hashable, Equatable, Codable {
        public let atcoCode: String
        public let lineIds: [TrainLine]
        
        public init(
            atcoCode: String,
            lineIds: [TrainLine]
        ) {
            self.atcoCode = atcoCode
            self.lineIds = lineIds
        }
    }
}

extension Station.ArrivalsGroup: Identifiable {
    
    public var id: String {
        "\(atcoCode)-\(lineIds.toId())"
    }
}
