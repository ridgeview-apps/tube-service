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
        let uniqueStatusDescriptions = Set(serviceDetails.compactMap { $0.statusSeverityDescription }).sorted()
        return uniqueStatusDescriptions.joined(separator: ", ")
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
        case .bakerloo, .central, .circle, .district, .dlr, .elizabeth, .hammersmithAndCity, .jubilee,
             .metropolitan, .overground, .northern, .piccadilly, .victoria, .waterlooAndCity:
            return "status.detail.good.service.on.the \(id.longName)"
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
        case .dlr, .elizabeth, .overground, .tram:
            return .overground
        case .bakerloo, .central, .circle, .district, .hammersmithAndCity, .jubilee,
             .metropolitan, .northern, .piccadilly, .victoria, .waterlooAndCity:
            return .tube
        }
    }
}
