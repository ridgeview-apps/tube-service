struct LineStatus: Codable, Identifiable, Equatable {
    private enum CodingKeys: String, CodingKey {
        case id, serviceDetails = "lineStatuses"
    }
    let id: TrainLine
    let serviceDetails: [LineStatusServiceDetail]
    
    var statusSeverity: StatusSeverity {
        serviceDetails.contains { $0.statusSeverity == .disrupted } ? .disrupted : .goodService
    }
    
    var isDisrupted: Bool {
        statusSeverity == .disrupted
    }
}

struct LineStatusServiceDetail: Codable, Equatable {
    let statusSeverity: LineStatus.StatusSeverity
    let statusSeverityDescription: String
    let reason: String?
}


extension LineStatus {
    
    enum StatusSeverity: Int, Codable {
        case disrupted
        case goodService
        
        init(from decoder: Decoder) throws {
          let container = try decoder.singleValueContainer()
          switch try container.decode(Int.self) {
          case 10:
            self = .goodService
          default:
            self = .disrupted
          }
        }
    }
    
    var shortText: String {
        Set(serviceDetails.compactMap { $0.statusSeverityDescription }).joined(separator: ", ")
    }
    
    var disruptionReasonsText: [String] {
        Set(serviceDetails.compactMap { $0.reason }).sorted { $0 < $1 }
    }
    
    typealias SortProperties = (statusSeverity: Int, transportType: Int, lineName: String)
    var sortProperties: SortProperties {
        (statusSeverity.rawValue, id.transportType.rawValue, lineName: id.shortName)
    }
}

extension Array where Element == LineStatus {
    func sortedByStatusThenName() -> [LineStatus] {
        self.sorted { $0.sortProperties < $1.sortProperties }
    }
}

private extension TrainLine {
    enum TransportType: Int {
        case tube, overground
    }
    
    var transportType: TransportType {
        switch self {
        case .dlr, .overground, .tflRail, .tram:
            return .overground
        case .bakerloo, .central, .circle, .district, .hammersmithAndCity, .jubilee,
             .metropolitan, .northern, .piccadilly, .victoria, .waterlooAndCity:
            return .tube
        }
    }
}
