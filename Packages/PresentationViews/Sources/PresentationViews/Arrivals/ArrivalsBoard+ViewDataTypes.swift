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
    let countdownText: ArrivalsBoardTextItem?
    var bottomLeadingTextItem: ArrivalsBoardTextItem?
    var bottomTrailingTextItem1: ArrivalsBoardTextItem?
    var bottomTrailingTextItem2: ArrivalsBoardTextItem?
}

struct ArrivalsBoardTextItem {
    enum MessageType {
        case verbatim(String)
        case localized(LocalizedStringResource)
    }
    
    struct Style {
        
        enum ColorStyle {
            case primary
            case secondary
            case warning
        }
        
        let font: Font
        let colorStyle: ColorStyle
        let isStrikeThrough: Bool
        let isBold: Bool
        
        static func header(
            colorStyle: ColorStyle = .primary,
            isStrikeThrough: Bool = false,
            isBold: Bool = false
        ) -> Style {
            .init(
                font: .headline,
                colorStyle: colorStyle,
                isStrikeThrough: isStrikeThrough,
                isBold: isBold
            )
        }
        
        static func footerSmall(
            colorStyle: ColorStyle = .secondary,
            isStrikeThrough: Bool = false,
            isBold: Bool = false
        ) -> Style {
            .init(
                font: .caption2,
                colorStyle: colorStyle,
                isStrikeThrough: isStrikeThrough,
                isBold: isBold
            )
        }
        
        static func footerMedium(
            colorStyle: ColorStyle = .secondary,
            isStrikeThrough: Bool = false,
            isBold: Bool = false
        ) -> Style {
            .init(
                font: .subheadline,
                colorStyle: colorStyle,
                isStrikeThrough: isStrikeThrough,
                isBold: isBold
            )
        }
    }
    
    let messageType: MessageType
    let style: Style
        
    static func verbatimMessage(_ rawString: String,
                                style: Style) -> ArrivalsBoardTextItem {
        .init(messageType: .verbatim(rawString), style: style)
    }
    
    static func localizedMessage(_ resource: LocalizedStringResource,
                                 style: Style) -> ArrivalsBoardTextItem {
        .init(messageType: .localized(resource), style: style)
    }
    
    static func countdownSeconds(_ seconds: Int?,
                                 style: Style) -> ArrivalsBoardTextItem? {
        guard let seconds else { return nil }
        return .init(messageType: countdownMessage(for: seconds), style: style)
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
}
