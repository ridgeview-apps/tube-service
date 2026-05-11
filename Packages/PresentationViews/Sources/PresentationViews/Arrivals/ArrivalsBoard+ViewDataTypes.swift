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
    
    enum TextType {
        case verbatim(String)
        case localized(LocalizedStringResource)
    }

    struct HeaderRowState {
        enum Style {
            case tube
            case scheduledDeparture
        }
        
        enum DestinationType {
            case towards(String)
            case checkFrontOfTrain
        }
        
        let style: Style
        let destination: DestinationType
        let countdownText: TextType
        let needsStrikethrough: Bool
    }
    
    struct DepartureStatusState {
        enum Style {
            case info
            case warning
        }
        
        let scheduledDeparture: TextType?
        let estimatedDeparture: TextType?
        let statusText: TextType?
        let style: Style
    }
    
    enum FooterRowType {        
        case tubeLiveLocation(String)
        case departureStatus(DepartureStatusState)
    }
    
    let id: String
    let numberLabel: NumberLabel
    let headerRow: HeaderRowState
    let footerRow: FooterRowType?
}


// MARK: - Countdown text formatter

enum CountdownTextFormatter {
    
    static func formattedText(forSeconds seconds: Int?) -> ArrivalsBoardCellItem.TextType {
        guard let seconds else {
            return .verbatim("--")
        }
        
        return countdownMessage(for: seconds)
    }
    
    private static func countdownMessage(for secondsRemaining: Int) -> ArrivalsBoardCellItem.TextType {
        let oneHour = 60 * 60
        if secondsRemaining < 60 {
            return .localized(.arrivalsBoardCountdownDue)
        } else if secondsRemaining < oneHour {
            let minutes = secondsRemaining / 60
            return .localized(.arrivalsBoardCountdownDueMinutes(minutes))
        } else {
            let formattedDuration = Duration
                                        .seconds(secondsRemaining)
                                        .formatted(
                                            .units(allowed: [.hours, .minutes],
                                                   width: .narrow)
                                        )
            return .verbatim(formattedDuration)
        }
    }
}

// MARK: - Departure time formatter

private let ukDateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.timeZone = .london
    dateFormatter.dateFormat = "HH:mm"
    return dateFormatter
}()

enum DepartureTimeFormatter {
    static func formattedText(for date: Date) -> String {
        ukDateFormatter.string(from: date)
    }
}
