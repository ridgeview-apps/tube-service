import Foundation
import Model

// MARK: - ArrivalDeparture

public extension ArrivalDeparture {
    
    static func fakeElizabethLineData() -> [Self] {
        JSONDecoder.decodeModelJSON(from: arrivalsElizabethLineJSONResponse)
    }
}
