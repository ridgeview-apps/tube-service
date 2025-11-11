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
    
    enum BottomTextMessage {
        case generalInfo(ArrivalsBoardTextItem?)
        case departureInfo(
            scheduled: ArrivalsBoardTextItem?,
            estimated: ArrivalsBoardTextItem?,
            status: ArrivalsBoardTextItem?
        )
    }
    
    let id: String
    let numberLabel: NumberLabel
    let destinationText: ArrivalsBoardTextItem
    var countdownText: ArrivalsBoardTextItem
    var bottomTextMessage: BottomTextMessage?
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
    let isStrikethrough: Bool
    
    private static func header(messageType: MessageType,
                               colorStyle: ColorStyle = .headerInfo,
                               isStrikethrough: Bool = false) -> ArrivalsBoardTextItem {
        .init(
            messageType: messageType,
            font: .headline,
            colorStyle: colorStyle,
            isStrikethrough: isStrikethrough
        )
    }
    
    private static func footerSmall(messageType: MessageType,
                                    colorStyle: ColorStyle = .footerInfo,
                                    isStrikethrough: Bool = false) -> ArrivalsBoardTextItem {
        .init(
            messageType: messageType,
            font: .caption2,
            colorStyle: colorStyle,
            isStrikethrough: isStrikethrough
        )
    }
    
    private static func footerMedium(messageType: MessageType,
                                     colorStyle: ColorStyle = .footerInfo,
                                     isStrikethrough: Bool = false) -> ArrivalsBoardTextItem {
        .init(
            messageType: messageType,
            font: .subheadline,
            colorStyle: colorStyle,
            isStrikethrough: isStrikethrough
        )
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
        return .footerSmall(messageType: .verbatim(locationName))
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
    
    static func departureTimeScheduled(departureTime: Date,
                                       isStrikethrough: Bool) -> ArrivalsBoardTextItem {
        let formattedTime = ukDateFormatter.string(from: departureTime)
        return .footerMedium(
            messageType: .localized(.arrivalsBoardDepartureTimeScheduled(formattedTime)),
            isStrikethrough: isStrikethrough
        )
    }
        
    static func departureTimeEstimated(departureTime: Date) -> ArrivalsBoardTextItem {
        let formattedTime = ukDateFormatter.string(from: departureTime)
        return .footerMedium(messageType: .localized(.arrivalsBoardDepartureTimeEstimated(formattedTime)),
                             colorStyle: .footerWarning)
    }
    
    // MARK: Departure status
    
    static func departureStatus(_ departureStatus: ArrivalDeparture.DepartureStatus) -> ArrivalsBoardTextItem {
        switch departureStatus {
        case .onTime:
            return .footerMedium(messageType: .localized(.arrivalsBoardDepartureStatusOnTime))
        case .cancelled:
            return .footerMedium(messageType: .localized(.arrivalsBoardDepartureStatusCancelled),
                                 colorStyle: .footerWarning)
        case .delayed:
            return .footerMedium(messageType: .localized(.arrivalsBoardDepartureStatusDelayed),
                                 colorStyle: .footerWarning)
        case .notStoppingHere:
            return .footerMedium(messageType: .localized(.arrivalsBoardDepartureStatusNotStopping),
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
