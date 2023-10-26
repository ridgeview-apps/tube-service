import Models
import Shared
import SwiftUI

// MARK: - Data types

public struct ArrivalsBoardState: Identifiable {
    
    public var id: String { platformName }
    
    let platformName: String
    let cellItems: [ArrivalsBoardCellItem]
}

struct ArrivalsBoardCellItem: Identifiable {

    struct NumberLabel {
        let value: Int
        let backgroundColor: Color
        let textColor: Color
        let textShadow: TextShadowSettings
        
        var valueText: String { String(value) }
    }
    let id: String
    let numberLabel: NumberLabel
    let destinationType: ArrivalsBoardDestinationType
    let secondsToArrival: Int?
    let subtitleType: ArrivalsBoardSubtitleType?
}

enum ArrivalsBoardDestinationType {
    case destination(String)
    case checkFrontOfTrain
}

enum ArrivalsBoardSubtitleType {
    case currentLocationName(String)
    case depatureTime(String)
}
