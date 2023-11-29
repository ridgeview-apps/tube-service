import Foundation

public struct Station: Identifiable, Hashable, Codable {
    public let id: String
    public let name: String
    public let location: Location
    public let lineGroups: [LineGroup]
    
    public init(
        id: String,
        name: String,
        location: Location,
        lineGroups: [Station.LineGroup]
    ) {
        self.id = id
        self.name = name
        self.location = location
        self.lineGroups = lineGroups
    }
}

public extension Station {
    
    struct LineGroup: Hashable, Equatable, Codable {
        public let atcoCode: String
        public let lineIds: [LineID]
        
        public init(
            atcoCode: String,
            lineIds: [LineID]
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
