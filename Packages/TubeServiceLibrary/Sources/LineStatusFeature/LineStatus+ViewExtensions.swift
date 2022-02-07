import Model
import SwiftUI

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
        return Set(serviceDetails.compactMap { $0.reason }).sorted { $0 < $1 }
    }
    
    typealias SortProperties = (statusSeverity: Int,
                                transportType: Int,
                                lineName: String)
    
    var sortProperties: SortProperties {
        (statusSeverity.rawValue,
         id.transportType.rawValue,
         lineName: id.shortName)
    }
    
    var goodServiceMessage: LocalizedStringKey {
        switch id {
        case .bakerloo, .central, .circle, .district, .dlr, .hammersmithAndCity, .jubilee,
             .metropolitan, .overground, .northern, .piccadilly, .victoria, .waterlooAndCity:
            return "status.detail.good.service.on.the \(id.longName)"
        case .tflRail:
            return "status.detail.good.service.on.tfl.rail"
        case .tram:
            return "status.detail.good.service.on.trams"
        }
    }
}

extension Array where Element == LineStatus {
    func sortedByStatusSeverity() -> [LineStatus] {
        sorted { $0.sortProperties < $1.sortProperties }
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
