import Foundation

public struct Station: Identifiable, Hashable, Codable {
    public let id: String
    public let icsCode: String
    public let name: String
    public let location: LocationCoordinate
    public let lineGroups: [LineGroup]
    
    public init(
        id: String,
        icsCode: String,
        name: String,
        location: LocationCoordinate,
        lineGroups: [Station.LineGroup]
    ) {
        self.id = id
        self.name = name
        self.icsCode = icsCode
        self.location = location
        self.lineGroups = lineGroups
    }
}

public extension Station {
    
    struct LineGroup: Hashable, Equatable, Codable {
        public let atcoCode: String
        public let lineIds: [TrainLineID]
        
        public init(
            atcoCode: String,
            lineIds: [TrainLineID]
        ) {
            self.atcoCode = atcoCode
            self.lineIds = lineIds
        }
    }
}

extension Station.LineGroup: Identifiable {
    
    public var id: String {
        "\(atcoCode)-\(commaSeparatedLineIDs)"
    }
    
    private var commaSeparatedLineIDs: String {
        lineIds
            .sorted { $0.name < $1.name }
            .map(\.rawValue).joined(separator: ",")
    }
}
