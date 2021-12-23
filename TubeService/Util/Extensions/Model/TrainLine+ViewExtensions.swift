import Model
import SwiftUI

extension TrainLine {
    
    var longName: String {
        switch self {
        case .dlr, .overground, .tflRail, .tram:
            return shortName
        case .bakerloo, .central, .circle, .district, .hammersmithAndCity, .jubilee,
             .metropolitan, .northern, .piccadilly, .victoria, .waterlooAndCity:
            return "\(shortName) line"
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .bakerloo:
            return .rgb(137, 78, 36)
        case .central:
            return .rgb(220, 36, 31)
        case .circle:
            return .rgb(255, 206, 0)
        case .district:
            return .rgb(0, 114, 41)
        case .hammersmithAndCity:
            return .rgb(215, 173, 175)
        case .jubilee:
            return .rgb(143, 134, 152)
        case .metropolitan:
            return .rgb(117, 16, 86)
        case .northern:
            return .rgb(0, 0, 0)
        case .piccadilly:
            return .rgb(0, 25, 168)
        case .victoria:
            return .rgb(0, 160, 226)
        case .waterlooAndCity:
            return .rgb(118, 208, 189)
        case .dlr:
            return .rgb(0, 175, 173)
        case .tram:
            return .rgb(0, 189, 25)
        case .tflRail:
            return .rgb(0, 25, 168)
        case .overground:
            return .rgb(239, 123, 16)
        }
    }
    
    var textColor: Color {
        switch self {
        case .bakerloo, .central, .circle, .district, .jubilee, .metropolitan, .northern, .piccadilly, .tram, .tflRail:
            return .white
        case .dlr, .hammersmithAndCity, .victoria, .waterlooAndCity, .overground:
            return .black
        }
    }
}
