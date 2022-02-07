import Foundation
import Model

// MARK: - LineStatus
public extension LineStatus {
    
    enum FakeType {
        case lineId(TrainLine)
    }
    
    static func fake(ofType fakeType: FakeType = .lineId(.northern),
                     serviceDetails: [LineStatusServiceDetail] = [.fake(ofType: .goodService)]) -> Self {

        switch fakeType {
        case let .lineId(lineId):
            return .init(id: lineId, serviceDetails: serviceDetails)
        }
    }
    
    static func fakes() -> [LineStatus] {
        return JSONDecoder.decodeModelJSON(from: lineStatusJSONResponse)
    }
}

public extension Sequence where Element == LineStatus {
    
    static func fakes() -> [LineStatus] {
        LineStatus.fakes()
    }
}

// MARK: - LineStatusServiceDetail
public extension LineStatusServiceDetail {
    
    enum FakeType {
        case goodService
        case severeDelays
        case plannedClosure
    }
    
    static func fake(ofType fakeType: FakeType) -> LineStatusServiceDetail {
        switch fakeType {
        case .goodService:
            return  .init(statusSeverity: .goodService,
                          statusSeverityDescription: "Good Service",
                          reason: nil)
        case .plannedClosure:
            return .init(statusSeverity: .disrupted,
                         statusSeverityDescription: "Planned closure",
                         reason: "There are planned engineering works on this line.")
        case .severeDelays:
            return .init(statusSeverity: .disrupted,
                         statusSeverityDescription: "Severe delays.",
                         reason: "Severe delays while we try to fix a signal failure. Please use alternative routes where possible. Tickets are being accepted on local buses.")
        }
    }
}
