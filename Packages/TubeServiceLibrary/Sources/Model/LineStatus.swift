public struct LineStatus: Codable, Identifiable, Equatable {
    private enum CodingKeys: String, CodingKey {
        case id, serviceDetails = "lineStatuses"
    }
    public let id: TrainLine
    public let serviceDetails: [LineStatusServiceDetail]
    
    public init(
        id: TrainLine,
        serviceDetails: [LineStatusServiceDetail]
    ) {
        self.id = id
        self.serviceDetails = serviceDetails
    }
}

public struct LineStatusServiceDetail: Codable, Equatable {
    public let statusSeverity: LineStatus.StatusSeverity
    public let statusSeverityDescription: String
    public let reason: String?
    
    public init(
        statusSeverity: LineStatus.StatusSeverity,
        statusSeverityDescription: String,
        reason: String?
    ) {
        self.statusSeverity = statusSeverity
        self.statusSeverityDescription = statusSeverityDescription
        self.reason = reason
    }
}


public extension LineStatus {
    
    enum StatusSeverity: Int, Codable {
        case disrupted
        case goodService
        
        public init(from decoder: Decoder) throws {
          let container = try decoder.singleValueContainer()
          switch try container.decode(Int.self) {
          case 10:
            self = .goodService
          default:
            self = .disrupted
          }
        }
    }
}

