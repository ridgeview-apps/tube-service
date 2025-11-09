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
    let destinationText: ArrivalsBoardTextItem
    var countdownText: ArrivalsBoardTextItem
    var bottomLeadingTextItem: ArrivalsBoardTextItem?
    var bottomTrailingTextItem: ArrivalsBoardTextItem?
}

enum ArrivalsBoardDestinationType {
    case checkFrontOfTrain
    case towards(String)
}

struct ArrivalsBoardTextItem {
    
    enum MessageType {
        case verbatim(String)
        case localized(LocalizedStringResource)
    }
    
    enum ColorStyle: Hashable {
        case headerInfo
        case footerInfo
        case footerWarning
    }
    
    let messageType: MessageType
    let font: Font
    let colorStyle: ColorStyle
    
    private static func header(messageType: MessageType,
                               colorStyle: ColorStyle = .headerInfo) -> ArrivalsBoardTextItem {
        .init(messageType: messageType, font: .headline, colorStyle: colorStyle)
    }
    
    private static func footer(messageType: MessageType,
                               colorStyle: ColorStyle = .footerInfo) -> ArrivalsBoardTextItem {
        .init(messageType: messageType, font: .caption2, colorStyle: colorStyle)
    }
}

extension ArrivalsBoardTextItem {
    
    // MARK: - Destination
    
    static func destination(_ desinationType: ArrivalsBoardDestinationType) -> ArrivalsBoardTextItem {
        switch desinationType {
        case .checkFrontOfTrain:
            return .header(messageType: .localized(.arrivalsCheckFrontOfTrain))
        case .towards(let destinationName):
            return .header(messageType: .verbatim(destinationName))
        }
    }
    
    // MARK: - Vehicle location
    
    static func currentVehicleLocation(_ locationName: String) -> ArrivalsBoardTextItem {
        return .footer(messageType: .verbatim(locationName))
    }
    
    // MARK: - Countdown
    
    static func countdownSeconds(_ seconds: Int?) -> ArrivalsBoardTextItem {
        guard let seconds else {
            return .header(messageType: .verbatim("--"))
        }
        return .header(messageType: countdownMessage(for: seconds))
    }
    
    private static func countdownMessage(for secondsRemaining: Int) -> MessageType {
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
    
    // MARK: - Departure time
    
    static func departureTimeInfo(departureTime: Date) -> ArrivalsBoardTextItem {
        let formattedTime = ukDateFormatter.string(from: departureTime)
        return .footer(messageType: .localized(.arrivalsBoardDepartureTime(formattedTime)))
    }
    
    static func departureTimeWarning(departureTime: Date) -> ArrivalsBoardTextItem {
        let formattedTime = ukDateFormatter.string(from: departureTime)
        return .footer(messageType: .localized(.arrivalsBoardDepartureTime(formattedTime)),
                             colorStyle: .footerWarning)
    }
    
    static func departureTimeNever(_ departureTime: Date) -> ArrivalsBoardTextItem {
        let formattedTime = ukDateFormatter.string(from: departureTime)
        return .footer(messageType: .localized(.arrivalsBoardDepartureTimeNever(formattedTime)),
                             colorStyle: .footerWarning)
    }
    
    static func departureTimeDelayedWithEstimate(scheduledTime: Date,
                                                 estimatedTime: Date) -> ArrivalsBoardTextItem {
        let scheduledTimeFormatted = ukDateFormatter.string(from: scheduledTime)
        let estimatedTimeFormatted = ukDateFormatter.string(from: estimatedTime)
        return .footer(
            messageType: .localized(.arrivalsBoardDepartureTimeScheduledEstimated(scheduledTimeFormatted,
                                                                                  estimatedTimeFormatted)),
            colorStyle: .footerWarning
        )
    }
    
    // MARK: Departure status
    
    static func departureStatus(_ departureStatus: ArrivalDeparture.DepartureStatus) -> ArrivalsBoardTextItem {
        switch departureStatus {
        case .onTime:
            return .footer(messageType: .localized(.arrivalsBoardDepartureStatusOnTime))
        case .cancelled:
            return .footer(messageType: .localized(.arrivalsBoardDepartureStatusCancelled),
                                 colorStyle: .footerWarning)
        case .delayed:
            return .footer(messageType: .localized(.arrivalsBoardDepartureStatusDelayed),
                                 colorStyle: .footerWarning)
        case .notStoppingHere:
            return .footer(messageType: .localized(.arrivalsBoardDepartureStatusNotStopping),
                                 colorStyle: .footerWarning)
        }
    }
}


private let ukDateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.timeZone = .london
    dateFormatter.dateFormat = "HH:mm"
    return dateFormatter
}()
