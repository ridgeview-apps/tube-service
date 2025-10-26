import Models
import Shared
import SwiftUI

// MARK: - Data types

public struct ArrivalsBoardState: Identifiable, Sendable {
    
    public var id: String { platformName }
    
    let platformName: String
    let cellItems: [ArrivalsBoardCellItem]
}

struct ArrivalsBoardCellItem: Identifiable, Sendable {

    struct NumberLabel {
        let value: Int
        let backgroundColor: Color
        let textColor: Color
        let textShadow: TextShadowSettings
        
        var valueText: String { String(value) }
    }
    let id: String
    let numberLabel: NumberLabel
    let topLeadingTextItem: ArrivalsBoardTextItem
    let topTrailingTextItem: ArrivalsBoardTextItem
    let bottomLeadingTextItem: ArrivalsBoardTextItem?
    let bottomTrailingTextItem: ArrivalsBoardTextItem?
}

enum ArrivalsBoardDestinationType: Sendable {
    case known(String)
    case checkFrontOfTrain
}

enum ArrivalsBoardSubtitleType: Sendable {
    case currentLocationName(String)
    case depatureTime(String)
}

enum ArrivalsBoardTextItem {
    enum DepartureStatus {
        case onTime
        case delayed
        case cancelled
        case notStopping
        
        var localized: LocalizedStringResource {
            switch self {
            case .onTime:
                .arrivalsBoardDepartureStatusOnTime
            case .delayed:
                .arrivalsBoardDepartureStatusDelayed
            case .cancelled:
                .arrivalsBoardDepartureStatusCancelled
            case .notStopping:
                .arrivalsBoardDepartureStatusNotStopping
            }
        }
    }
    
    case destinationType(ArrivalsBoardDestinationType)
    case countdownSeconds(Int?)
    case scheduledDepartureTime(String)
    case currentPosition(String)
    case departureStatus(DepartureStatus) // On Time / Delayed / Cancelled / Not stopping
    case estimatedDepartureTime(String)
}
