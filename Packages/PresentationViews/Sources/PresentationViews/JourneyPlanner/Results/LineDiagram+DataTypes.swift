import Foundation
import Models
import SwiftUI

struct LineDiagramItem: Identifiable, Equatable {
    
    // swiftlint:disable type_name
    struct ID: Hashable {
        let type: ItemType
        let journeyItemID: JourneyItemID
    }
    // swiftlint:enable type_name
    
    let id: ID
    let style: LineDiagramItem.Style
    var detailItemPadding: LineDiagramItem.Style.DetailItemPadding = .zero
    
    var type: ItemType { id.type }
    var journeyItemID: JourneyItemID { id.journeyItemID }
}

public typealias LineDiagramItemJourneyID = String
public typealias LineDiagramItemJourneyLegID = String

extension LineDiagramItem {
    
    typealias JourneyID = LineDiagramItemJourneyID
    typealias JourneyLegID = LineDiagramItemJourneyLegID
    
    struct JourneyItemID: Hashable {
        let journeyID: JourneyID
        let legID: JourneyLegID
    }
    
    enum DetailItem: Hashable {
        case title(String, Font)
        case stopsToggleButton
    }
    
    struct LegDetail: Hashable {
        let durationMinutes: Int?
        let instructionSummary: String
        let stopPointsCount: Int
        
        var shouldShowStopPointsToggle: Bool {
            stopPointsCount > 1
        }
    }
    
    enum ItemType: Hashable {
        enum ToggleButtonTitleID {
            case showStops
            case hideStops
        }
        case departurePoint(name: String, time: Date?)
        case arrivalPoint(name: String, time: Date?)
        case legDetail(LegDetail)
        case stopPointTickItem(name: String)
    }
    
    enum Orientation: Equatable {
        case horizontal, vertical
    }
    
    struct Style: Equatable {
        let elementType: ElementType
        let lineStyle: LineStyle
        let hasTrailingLine: Bool
    }
}

extension LineDiagramItem.Style {
    enum TickPosition {
        case start, center, end
    }
    
    struct DetailItemPadding: Equatable {
        var top: CGFloat = 0
        var bottom: CGFloat = 0
        
        static let zero = DetailItemPadding(top: 0, bottom: 0)
    }
    
    struct CircleTextOverlay: Equatable {
        let text: String
        let color: Color
    }
    
    enum ElementType: Equatable {
        case stopPointCircle(CircleTextOverlay)
        case stopPointImage(Image)
        case stopPointTick(TickPosition)
        case straightLine
    }
    
    struct LineStyle: Equatable {
        enum FillType {
            case double, solid, dashed
        }
        let color: Color
        let fill: FillType
    }
}

extension LineDiagramItem.Style.LineStyle {
    static let invisible = Self(color: .clear, fill: .solid)
}

extension LineDiagramItem.Style {
    static func stopPointTick(_ lineStyle: LineStyle,
                              position: TickPosition = .center) -> Self {
        .init(elementType: .stopPointTick(position),
              lineStyle: lineStyle,
              hasTrailingLine: false)
    }
    
    static func stopPointCircle(_ trainLineID: TrainLineID, hasTrailingLine: Bool) -> Self {
        let firstLetterOfLineName = String(trainLineID.name.prefix(1))
        let textOverlay = CircleTextOverlay(text: firstLetterOfLineName, color: trainLineID.textColor)
        return .init(elementType: .stopPointCircle(textOverlay),
                     lineStyle: .init(trainLineID: trainLineID),
                     hasTrailingLine: hasTrailingLine)
    }
    
    static func stopPointImage(_ modeID: ModeID, hasTrailingLine: Bool) -> Self {
        return .init(elementType: .stopPointImage(modeID.image),
                     lineStyle: .init(modeID: modeID),
                     hasTrailingLine: hasTrailingLine)
    }
    
    static func straightLine(_ lineStyle: LineStyle) -> Self {
        return .init(elementType: .straightLine, lineStyle: lineStyle, hasTrailingLine: false)
    }
}

extension ModeID {
    
    var foregroundColor: Color? {
        switch self {
        case .bus, .replacementBus:
            return .bus
        case .cableCar:
            return .cableCar
        case .coach:
            return .coach
        case .cycleHire:
            return .cycleHire
        case .nationalRail:
            return .nationalRail
        case .riverBus, .riverTour:
            return .riverBus
        case .walking, .taxi, .cycle:
            return .adaptive(lightMode: .black,
                             darkMode: .white)
        case .tram:
            return .tram
        case .dlr, .elizabethLine, .interchangeKeepSitting, .interchangeSecure,
             .overground, .tube:
            return nil
        }
    }
    
    var image: Image {
        switch self {
        case .bus, .coach, .replacementBus:
            Image(systemName: "bus.doubledecker.fill")
        case .cableCar:
            Image(systemName: "cablecar.fill")
        case .cycle, .cycleHire:
            Image(systemName: "bicycle")
        case .nationalRail:
            Image("national-rail", bundle: .module)
        case .riverBus, .riverTour:
            Image(systemName: "ferry.fill")
        case .taxi:
            Image(systemName: "car.side.fill")
        case .walking:
            Image(systemName: "figure.walk")
        case .tram:
            Image(systemName: "tram")
        case .dlr, .elizabethLine, .overground, .tube, .interchangeKeepSitting, .interchangeSecure:
            Image("")
        }
    }
}
extension LineDiagramItem.Style.LineStyle {
    
    init(trainLineID: TrainLineID) {
        switch trainLineID {
        case .bakerloo, .central, .circle, .district, .hammersmithAndCity, .jubilee,
                .metropolitan, .northern, .piccadilly, .victoria, .waterlooAndCity:
            self = .init(color: trainLineID.backgroundColor, fill: .solid)
        case .dlr, .elizabeth, .tram, .overground:
            self = .init(color: trainLineID.backgroundColor, fill: .double)
        }
    }
    
    init(modeID: ModeID) {
        guard let foregroundColor = modeID.foregroundColor else {
            assertionFailure("Unsupported line style for \(modeID)")
            self = .invisible
            return
        }
        switch modeID {
        case .bus:
            self = .init(color: foregroundColor, fill: .solid)
        case .nationalRail:
            self = .init(color: foregroundColor, fill: .double)
        default:
            self = .init(color: foregroundColor, fill: .dashed)
        }
    }
}
