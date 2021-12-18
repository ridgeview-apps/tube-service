import Model

extension LineStatus {

    var statusSeverity: StatusSeverity {
        serviceDetails.contains { $0.statusSeverity == .disrupted } ? .disrupted : .goodService
    }
    
    var isDisrupted: Bool {
        statusSeverity == .disrupted
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
